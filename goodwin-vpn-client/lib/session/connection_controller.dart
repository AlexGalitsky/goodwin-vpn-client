import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import '../vpn/system_tunnel.dart';
import '../vpn/vpn_slot.dart';
import 'connectivity_monitor.dart';
import 'connect_policy.dart';
import 'session_store.dart';
import 'socks_core_resolver.dart';
import 'socks_session.dart';
import 'trusttunnel_session.dart';
import 'go_core_switch.dart';
import 'network_reconnect.dart';
import 'process_restarter.dart';
import 'backup_codec.dart';
import 'goodwin_service.dart';
import 'goodwin_service_client.dart';
import 'goodwin_geo_prefetch.dart';
import 'import_uri.dart';
import 'saved_profile.dart';
import 'subscription.dart';
import 'subscription_client.dart';
import 'subscription_parser.dart';
import 'secret_log.dart';
import 'tunnel_elevation.dart';
import 'vpn_connection_state.dart';
import 'vpn_session.dart';

typedef ShareLinkParse = VpnProfile Function(String raw);

const _restoredTrustTunnel = TrustTunnelProfile(
  name: 'restored',
  endpoint: 'restored',
);

/// FSM for connect/disconnect. VPN ownership is [VpnSlot], not boolean flags.
class ConnectionController {
  ConnectionController({
    required this.slot,
    required this.tunnel,
    required this.owned,
    required this.cores,
    required this.onState,
    SessionStore? store,
    ProcessRestarter? restarter,
    ConnectPolicyResolver? connectPolicy,
    this.connectivity,
    this.networkDebounce = const Duration(milliseconds: 1500),
    this.parseShareLink = _defaultParse,
    this.socksPort = 10808,
    this.instanceId = 'flutter-ui',
    SubscriptionClient? subscriptionClient,
    GoodwinServiceClient? serviceClient,
    this.geoPrefetch,
    this.killSwitchEnabled,
    bool Function()? extensionHostedCore,
  }) : store = store ?? MemorySessionStore(),
       restarter = restarter ?? MessageProcessRestarter(),
       connectPolicy =
           connectPolicy ?? const PassthroughConnectPolicyResolver(),
       subscriptionClient = subscriptionClient ?? HttpSubscriptionClient(),
       serviceClient = serviceClient ?? HttpGoodwinServiceClient(),
       extensionHostedCore = extensionHostedCore ?? _platformIsIos;

  final VpnSlot slot;
  final SystemTunnel tunnel;
  final OwnedVpnEngine owned;
  final SocksCoreResolver cores;
  final SessionStore store;
  final ProcessRestarter restarter;
  final ConnectPolicyResolver connectPolicy;
  final ConnectivityMonitor? connectivity;
  final Duration networkDebounce;
  final void Function(VpnConnectionState state) onState;
  final ShareLinkParse parseShareLink;
  final int socksPort;
  final String instanceId;
  final SubscriptionClient subscriptionClient;
  final GoodwinServiceClient serviceClient;
  final GoodwinGeoPrefetcher? geoPrefetch;
  final bool Function()? killSwitchEnabled;
  final bool Function() extensionHostedCore;

  static bool _platformIsIos() => Platform.isIOS;

  static VpnProfile _defaultParse(String raw) =>
      const ShareLinkParser().parse(raw.trim());

  VpnConnectionState _state = const VpnConnectionState(
    phase: ConnectionPhase.idle,
  );
  VpnSession? _session;
  Future<void> _tail = Future.value();
  Timer? _networkDebounce;
  String? _lastConnectivityKey;
  var _disposed = false;
  var _tunnelEpoch = 0;

  VpnConnectionState get state => _state;

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _networkDebounce?.cancel();
    // Live OS TUN (iOS Packet Tunnel / Always-on) must survive a Dart
    // isolate restart so [restoreFromOs] can adopt it. Only tear down when
    // this isolate actually owns a session.
    if (_session != null) {
      unawaited(() async {
        try {
          await _tearDown();
        } catch (e) {
          log('dispose stop: $e');
        }
      }());
    }
  }

  bool get _connectBlocked =>
      _state.phase == ConnectionPhase.connecting ||
      _state.phase == ConnectionPhase.connected ||
      _state.phase == ConnectionPhase.disconnecting;

  Future<void> _enqueue(Future<void> Function() job) {
    final done = Completer<void>();
    _tail = _tail.then((_) async {
      try {
        await job();
        if (!done.isCompleted) done.complete();
      } catch (e, st) {
        if (!done.isCompleted) done.completeError(e, st);
      }
    });
    return done.future;
  }

  Future<void> connect(String shareLink) {
    if (_connectBlocked) return Future.value();
    _emit(
      phase: ConnectionPhase.connecting,
      message: 'Connecting…',
      elevationRequired: false,
    );
    return _enqueue(() => _performConnect(shareLink));
  }

  Future<void> disconnect() {
    if (_state.phase == ConnectionPhase.disconnecting ||
        _state.phase == ConnectionPhase.idle) {
      return Future.value();
    }
    return _enqueue(() async {
      if (_state.phase == ConnectionPhase.disconnecting ||
          _state.phase == ConnectionPhase.idle) {
        return;
      }
      _emit(phase: ConnectionPhase.disconnecting, message: 'Disconnecting…');
      _networkDebounce?.cancel();
      try {
        await _tearDown();
        _lastConnectivityKey = null;
        log('VPN slot released');
        _emit(
          phase: ConnectionPhase.idle,
          message: 'Disconnected',
          elevationRequired: false,
        );
      } on OnDemandDisarmFailed catch (e) {
        log('stop error: $e');
        _emit(
          phase: ConnectionPhase.connected,
          message: redactForLog('$e'),
        );
      } catch (e) {
        log('stop error: $e');
        _emit(phase: ConnectionPhase.error, message: redactForLog('$e'));
      }
    });
  }

  Future<void> setAutoConnect(bool enabled) async {
    await store.setAutoConnect(enabled);
    _emit(autoConnect: enabled);
  }

  Future<void> setSmartConnect(bool enabled) async {
    await store.setSmartConnect(enabled);
    _emit(smartConnect: enabled);
  }

  Future<void> saveShareLinkToList(String link, {String? name}) async {
    final saved = await store.addSavedProfile(link, name: name);
    _emit(savedProfiles: saved);
  }

  Future<void> removeSavedShareLink(String link) async {
    await store.removeSavedShareLink(link);
    _emit(savedProfiles: await store.savedProfiles());
  }

  Future<void> removeSavedProfile(String id) async {
    final saved = await store.removeSavedProfile(id);
    _emit(savedProfiles: saved);
  }

  Future<void> renameSavedProfile(String id, String name) async {
    final saved = await store.renameSavedProfile(id, name);
    _emit(savedProfiles: saved);
  }

  Future<void> updateSavedProfile({
    required String id,
    String? name,
    String? link,
  }) async {
    final saved = await store.updateSavedProfile(
      id: id,
      name: name,
      link: link,
    );
    _emit(savedProfiles: saved);
  }

  Future<void> setExcludeRoutes(List<String> routes) async {
    await store.setExcludeRoutes(routes);
    _emit(excludeRoutes: await store.excludeRoutes());
  }

  Future<void> setDisallowedPackages(List<String> packages) async {
    await store.setDisallowedPackages(packages);
    _emit(disallowedPackages: await store.disallowedPackages());
  }

  /// Remember which share link Home will connect, without starting a session.
  Future<void> selectShareLink(String link) async {
    final trimmed = link.trim();
    if (trimmed.isEmpty) return;
    await store.saveLastShareLink(trimmed);
    _emit(activeShareLink: trimmed);
  }

  Future<void> importInput(String raw, {String? name}) async {
    final trimmed = unwrapImportText(raw);
    if (trimmed.isEmpty) return;
    if (looksLikeSubscriptionUrl(trimmed)) {
      await importSubscription(trimmed, name: name);
      return;
    }
    parseShareLink(trimmed);
    await saveShareLinkToList(trimmed, name: name);
  }

  Future<BackupMergeResult> restoreBackup(ProfileBackup backup) async {
    final result = mergeProfileBackup(
      currentSubscriptions: await store.subscriptions(),
      currentProfiles: await store.savedProfiles(),
      backup: backup,
    );
    final written = await store.replaceCatalog(
      subscriptions: result.subscriptions,
      profiles: result.profiles,
    );
    _emit(
      subscriptions: written.subscriptions,
      savedProfiles: written.profiles,
    );
    log(
      'backup restore: +${result.addedSubscriptions} subscription(s), '
      '+${result.addedProfiles} profile(s)',
    );
    return result;
  }

  Future<void> importSubscription(String url, {String? name}) async {
    await _applyFetchedSubscription(url.trim(), preferredName: name);
  }

  Future<void> refreshSubscription(String id) async {
    final sub =
        _state.subscriptions.where((s) => s.id == id).firstOrNull ??
        (await store.subscriptions()).where((s) => s.id == id).firstOrNull;
    if (sub == null) {
      throw SubscriptionParseException('Subscription not found');
    }
    await _applyFetchedSubscription(sub.url, existing: sub);
  }

  Future<void> removeSubscription(String id) async {
    final result = await store.removeSubscription(id);
    _emit(subscriptions: result.subscriptions, savedProfiles: result.profiles);
  }

  Future<void> refreshDueSubscriptions() async {
    final due = [
      for (final sub in await store.subscriptions())
        if (sub.isDue) sub,
    ];
    for (final sub in due) {
      try {
        await _applyFetchedSubscription(sub.url, existing: sub);
      } on SubscriptionRevokedException {
        // Catalog kept; [VpnSubscription.revoked] drives the banner.
      } catch (e) {
        log('subscription refresh failed ${sub.name}: $e');
      }
    }
  }

  Future<void> _applyFetchedSubscription(
    String url, {
    VpnSubscription? existing,
    String? preferredName,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) {
      throw SubscriptionParseException('Invalid subscription URL');
    }
    requireHttpsSubscriptionUri(uri);
    final stored =
        existing ??
        (await store.subscriptions()).where((s) => s.url == url).firstOrNull;
    log('fetch subscription $url');
    late final SubscriptionDocument doc;
    try {
      doc = await subscriptionClient.fetch(uri);
    } on SubscriptionRevokedException {
      if (stored != null) {
        await _markSubscriptionRevoked(stored);
      }
      rethrow;
    }
    final parsed = parseSubscriptionDocument(doc);
    final gw = detectGoodwinService(headers: doc.headers, subscriptionUrl: uri);
    GoodwinServiceCatalog? catalog;
    if (gw != null) {
      try {
        catalog = await serviceClient.fetchCatalog(gw.serviceBase);
      } catch (e) {
        log('service catalog failed');
      }
      if (catalog?.hasFeature(kGoodwinFeatureGeoPacks) == true) {
        try {
          await geoPrefetch?.prefetch(gw.serviceBase);
        } catch (_) {
          log('geo pack prefetch failed');
        }
      }
    }
    final profileTitle = parsed.title?.trim();
    final accountLabel = (profileTitle != null && profileTitle.isNotEmpty)
        ? profileTitle
        : stored?.accountLabel;
    final catalogName = catalog?.name?.trim();
    final providerFromCatalog = (catalogName != null && catalogName.isNotEmpty)
        ? catalogName
        : (stored?.serviceName?.trim().isNotEmpty == true
            ? stored!.serviceName!.trim()
            : null);
    final host = uri.host.trim();
    final storedName = stored?.name.trim();
    final String title;
    if (preferredName?.trim().isNotEmpty == true) {
      title = preferredName!.trim();
    } else if (providerFromCatalog != null) {
      title = providerFromCatalog;
    } else if (host.isNotEmpty) {
      title = host;
    } else if (storedName != null &&
        storedName.isNotEmpty &&
        storedName != accountLabel) {
      title = storedName;
    } else {
      title = 'Subscription';
    }
    final sub = VpnSubscription(
      id: stored?.id ?? VpnSubscription.newId(),
      name: title,
      url: url,
      accountLabel: accountLabel,
      lastFetched: DateTime.now().toUtc(),
      intervalHours: parsed.intervalHours ?? stored?.intervalHours ?? 24,
      userinfo: parsed.userinfo ?? stored?.userinfo,
      revoked: false,
      serviceBase: gw?.serviceBase,
      protocolVersion: gw?.protocolVersion,
      serviceName: catalog?.name ?? (gw == null ? null : stored?.serviceName),
      privacyUrl:
          catalog?.privacyUrl ?? (gw == null ? null : stored?.privacyUrl),
      supportUrl:
          catalog?.supportUrl ?? (gw == null ? null : stored?.supportUrl),
      features:
          catalog?.features ??
          (gw == null ? const [] : stored?.features ?? const []),
    );
    final persisted = (await store.upsertSubscription(
      sub,
    )).firstWhere((s) => s.url == url, orElse: () => sub);
    final previous = (await store.savedProfiles())
        .where((p) => p.subscriptionId == persisted.id)
        .toList();
    final byLink = {for (final p in previous) p.link: p};
    final nodes = <SavedProfile>[];
    for (final link in parsed.links) {
      String remark = '';
      try {
        remark = parseShareLink(link).name.trim();
      } catch (_) {}
      final old = byLink[link];
      nodes.add(
        old?.copyWith(
              name: remark.isNotEmpty ? remark : old.name,
              subscriptionId: persisted.id,
            ) ??
            SavedProfile.fromLink(
              link,
              name: remark,
              subscriptionId: persisted.id,
            ),
      );
    }
    final profiles = await store.replaceSubscriptionNodes(
      subscriptionId: persisted.id,
      nodes: nodes,
    );
    _emit(subscriptions: await store.subscriptions(), savedProfiles: profiles);
    log('subscription ${sub.name}: ${nodes.length} node(s)');
  }

  Future<void> _markSubscriptionRevoked(VpnSubscription existing) async {
    final updated = existing.copyWith(
      revoked: true,
      lastFetched: DateTime.now().toUtc(),
    );
    await store.upsertSubscription(updated);
    _emit(
      subscriptions: await store.subscriptions(),
      savedProfiles: await store.savedProfiles(),
    );
    log('subscription ${existing.name}: link revoked — paste a new URL');
  }

  /// Align UI with a live OS VPN after Flutter/process restart. Opt-in reconnect
  /// only if nothing is already up.
  Future<void> restoreFromOs() {
    return _enqueue(() async {
      try {
      final auto = await store.autoConnect();
      final smart = await store.smartConnect();
      final saved = await store.savedProfiles();
      final excludes = await store.excludeRoutes();
      final disallowed = await store.disallowedPackages();
      final pending = await store.pendingConnect();
      final lastLink = await store.lastShareLink();
      final subs = await store.subscriptions();
      final sessionStarted = await store.connectedAt();
      if (pending) {
        await store.setPendingConnect(false);
      }
      _emit(
        autoConnect: auto,
        smartConnect: smart,
        savedProfiles: saved,
        excludeRoutes: excludes,
        disallowedPackages: disallowed,
        activeShareLink: lastLink,
        subscriptions: subs,
        connectedAt: sessionStarted,
      );
      if (_connectBlocked) return;

      if (await owned.isConnected()) {
          await _adoptTrustTunnel();
          return;
        }

        if (await tunnel.isEstablished()) {
          if (await _adoptSocksIfRunning()) {
            return;
          }
          final link = lastLink;
          if (link != null && link.isNotEmpty) {
            // Always-on / Block-without-VPN: tearing the TUN down leaves the
            // device offline. Reconnect the SOCKS core instead.
            log('TUN up, SOCKS down — restoring proxy');
            _emit(phase: ConnectionPhase.connecting, message: 'Restoring VPN…');
            await _performConnect(link, reuseSocksSession: true);
            return;
          }
          log('orphan TUN — no last link, stopping tunnel');
          await tunnel.stop();
          slot.mark(VpnSlotOwner.none);
        }

        final link = lastLink;
        if (pending && link != null && link.isNotEmpty) {
          log('pending connect after Go-core process restart');
          _emit(phase: ConnectionPhase.connecting, message: 'Connecting…');
          await _performConnect(link, reuseSocksSession: true);
          return;
        }

        if (!auto) {
          if (_state.phase != ConnectionPhase.connected) {
            unawaited(store.setConnectedAt(null));
          }
          return;
        }
        if (link == null || link.isEmpty) {
          if (_state.phase != ConnectionPhase.connected) {
            unawaited(store.setConnectedAt(null));
          }
          return;
        }
        _emit(phase: ConnectionPhase.connecting, message: 'Connecting…');
        await _performConnect(link);
      } catch (e) {
        log('restore: $e');
      }
    });
  }

  void handleConnectivityChange(List<ConnectivityResult> results) {
    if (connectivity == null) return;
    final key = connectivityKey(results);
    if (key == _lastConnectivityKey) return;
    // Apple NE: brief `other`-only snapshots — not a real path change.
    if (key == 'online') return;
    // iOS Hy2: tun2socks DNS blips report `none` while Packet Tunnel is still
    // up. Reconnecting then flaps the status-bar VPN. Real offline usually
    // also stops the NE (stopped/revoked).
    if (key == 'none' && _state.phase == ConnectionPhase.connected) {
      log('network: ignore none while connected');
      return;
    }
    final previous = _lastConnectivityKey;
    _lastConnectivityKey = key;

    if (_state.phase != ConnectionPhase.connected) return;
    if (previous == null) return;

    log('network: $previous → $key');
    _networkDebounce?.cancel();
    if (networkDebounce == Duration.zero) {
      unawaited(_scheduleNetworkReconnect());
    } else {
      _networkDebounce = Timer(networkDebounce, () {
        unawaited(_scheduleNetworkReconnect());
      });
    }
  }

  Future<void> _scheduleNetworkReconnect() {
    return _enqueue(() async {
      if (_state.phase != ConnectionPhase.connected) return;
      final link = await store.lastShareLink();
      if (link == null || link.isEmpty) return;
      await _reconnectAfterNetworkChange(link);
    });
  }

  void handleOwnedDrop() {
    if (_state.phase == ConnectionPhase.connected ||
        _state.phase == ConnectionPhase.connecting) {
      _invalidateTunnel('TrustTunnel disconnected by the system');
    }
  }

  void handleTunnelEvent(SystemTunnelEvent event) {
    switch (event.kind) {
      case SystemTunnelKind.revoked:
        _invalidateTunnel(event.message ?? 'VPN revoked by the system');
      case SystemTunnelKind.stopped:
        // Pre-connect [VpnSlot.release] also emits stopped — ignore while connecting.
        // FGS/process death while live arrives in connected.
        if (_state.phase == ConnectionPhase.connected) {
          _invalidateTunnel(event.message ?? 'VPN service stopped');
        }
      case SystemTunnelKind.established:
      case SystemTunnelKind.failed:
        break;
    }
  }

  void _invalidateTunnel(String message) {
    _tunnelEpoch++;
    unawaited(_enqueue(() async {
      if (_state.phase == ConnectionPhase.disconnecting ||
          _state.phase == ConnectionPhase.idle) {
        return;
      }
      _onTunnelGone(message);
    }));
  }

  void _onTunnelGone(String message) {
    log('system VPN gone: $message');
    slot.mark(VpnSlotOwner.none);
    _session?.stopEngine();
    _session = null;
    _emit(phase: ConnectionPhase.error, message: message);
  }

  void clearLogs() {
    _emit(logs: const []);
  }

  void log(String line) {
    final stamp = DateTime.now().toIso8601String().substring(11, 19);
    _emit(
      logs: [
        '[$stamp] ${redactForLog(line)}',
        ..._state.logs,
      ].take(200).toList(),
    );
  }

  Future<void> _performConnect(
    String shareLink, {
    bool reuseSocksSession = false,
  }) async {
    if (_state.phase != ConnectionPhase.connecting) return;
    final epoch = _tunnelEpoch;
    log('parse share link');

    try {
      final profile = parseShareLink(shareLink);
      await _tearDown();
      _session = await _openSession(
        profile,
        shareLink: shareLink,
        reuseSocksSession: reuseSocksSession,
      );
      await _session!.start();
      if (_state.phase != ConnectionPhase.connecting || epoch != _tunnelEpoch) {
        await _tearDown();
        return;
      }
      await store.saveLastShareLink(shareLink);
      final saved = await store.addSavedProfile(shareLink);
      log('backend=${_backendLabel(profile)}');
      _emit(
        phase: ConnectionPhase.connected,
        message: _session!.connectedMessage,
        coreVersion: _session!.engineVersion,
        savedProfiles: saved,
        elevationRequired: false,
        activeShareLink: shareLink,
      );
      await _seedConnectivityKey();
    } on GoCoreSwitchRequired catch (e) {
      log('Go core switch ${e.from}→${e.to}: restarting process');
      await store.saveLastShareLink(shareLink);
      await store.addSavedProfile(shareLink);
      await store.setPendingConnect(true);
      // Belt-and-suspenders: tearDown already ran, but ensure TUN is down
      // before exit(0) skips macOS terminate handlers.
      try {
        if (await tunnel.isEstablished()) {
          await tunnel.stop();
        }
      } catch (_) {}
      _emit(
        phase: ConnectionPhase.idle,
        message: 'Restarting to switch ${e.from} → ${e.to}…',
        activeShareLink: shareLink,
      );
      try {
        await restarter.restart();
      } catch (re) {
        await store.setPendingConnect(false);
        log('restart failed: $re');
        _emit(
          phase: ConnectionPhase.error,
          message: redactForLog(re.toString()),
        );
      }
    } on TunnelElevationRequired catch (e) {
      log('$e');
      await _tearDown();
      if (_state.phase == ConnectionPhase.connecting) {
        _emit(
          phase: ConnectionPhase.error,
          message:
              'Administrator rights required for system VPN. '
              'Approve UAC to relaunch, then Connect again.',
          elevationRequired: true,
        );
      }
    } catch (e) {
      log('error: $e');
      await _tearDown();
      if (_state.phase == ConnectionPhase.connecting) {
        _emit(phase: ConnectionPhase.error, message: redactForLog('$e'));
      }
    }
  }

  Future<void> _reconnectAfterNetworkChange(String shareLink) async {
    for (var attempt = 0; attempt < kNetworkReconnectMaxAttempts; attempt++) {
      if (_state.phase != ConnectionPhase.connected &&
          _state.phase != ConnectionPhase.connecting) {
        return;
      }

      if (attempt == 0) {
        log('network changed — reconnecting…');
        _emit(
          phase: ConnectionPhase.connecting,
          message: 'Network changed — reconnecting…',
        );
      } else {
        final delay = networkReconnectDelay(attempt);
        log(
          'network reconnect attempt ${attempt + 1}/$kNetworkReconnectMaxAttempts',
        );
        _emit(
          phase: ConnectionPhase.connecting,
          message:
              'Reconnecting (${attempt + 1}/$kNetworkReconnectMaxAttempts)…',
        );
        await Future<void>.delayed(delay);
      }

      try {
        final epoch = _tunnelEpoch;
        final profile = parseShareLink(shareLink);
        await _tearDown();
        _session = await _openSession(
          profile,
          shareLink: shareLink,
          reuseSocksSession: true,
        );
        await _session!.start();
        if (epoch != _tunnelEpoch ||
            (_state.phase != ConnectionPhase.connected &&
                _state.phase != ConnectionPhase.connecting)) {
          await _tearDown();
          return;
        }
        log('backend=${_backendLabel(profile)} (network reconnect)');
        _emit(
          phase: ConnectionPhase.connected,
          message: _session!.connectedMessage,
          coreVersion: _session!.engineVersion,
          activeShareLink: shareLink,
        );
        await _seedConnectivityKey();
        return;
      } catch (e) {
        log('network reconnect failed: $e');
        await _tearDown();
      }
    }

    _emit(
      phase: ConnectionPhase.error,
      message:
          'Network reconnect failed after $kNetworkReconnectMaxAttempts attempts',
    );
    _lastConnectivityKey = null;
  }

  Future<void> _seedConnectivityKey() async {
    final monitor = connectivity;
    if (monitor == null) return;
    try {
      _lastConnectivityKey = connectivityKey(await monitor.checkConnectivity());
    } catch (_) {}
  }

  Future<void> _adoptTrustTunnel() async {
    final profile = await _lastTrustTunnelProfile() ?? _restoredTrustTunnel;
    final session = TrustTunnelSession(
      profile: profile,
      slot: slot,
      owned: owned,
      log: log,
      tunnel: tunnel,
    );
    session.attachExisting();
    _session = session;
    log('OS: TrustTunnel still connected');
    _emit(
      phase: ConnectionPhase.connected,
      message: session.connectedMessage,
      coreVersion: session.engineVersion,
      activeShareLink: await store.lastShareLink(),
    );
  }

  Future<bool> _adoptSocksIfRunning() async {
    final link = await store.lastShareLink();
    if (link == null || link.isEmpty) return false;
    late final VpnProfile profile;
    try {
      profile = parseShareLink(link);
    } catch (_) {
      return false;
    }
    if (profile is TrustTunnelProfile) return false;

    final session = await _openSession(
      profile,
      shareLink: link,
      reuseSocksSession: true,
    ) as SocksSession;
    if (!session.core.isInstanceRunning(instanceId) &&
        !extensionHostedCore()) {
      return false;
    }
    session.attachExisting();
    _session = session;
    log('OS: hev TUN + SOCKS still running');
    _emit(
      phase: ConnectionPhase.connected,
      message: session.connectedMessage,
      coreVersion: session.engineVersion,
      activeShareLink: link,
    );
    return true;
  }

  Future<TrustTunnelProfile?> _lastTrustTunnelProfile() async {
    final link = await store.lastShareLink();
    if (link == null || link.isEmpty) return null;
    try {
      final profile = parseShareLink(link);
      if (profile is TrustTunnelProfile) return profile;
    } catch (_) {}
    return null;
  }

  Future<VpnSession> _openSession(
    VpnProfile profile, {
    String? shareLink,
    bool reuseSocksSession = false,
  }) async {
    final homeExcludes = await store.excludeRoutes();
    final policy = await connectPolicy.resolve(
      profile,
      shareLink: shareLink,
      reuseSocksSession: reuseSocksSession,
    );
    for (final note in policy.logNotes) {
      log(note);
    }
    final excludes = <String>{
      ...homeExcludes,
      ...policy.extraExcludeRoutes,
    }.toList();
    final disallowed = <String>{
      ...await store.disallowedPackages(),
      ...policy.extraDisallowedPackages,
    }.toList();

    return switch (profile) {
      TrustTunnelProfile() => TrustTunnelSession(
        profile: profile,
        slot: slot,
        owned: owned,
        log: log,
        tunnel: tunnel,
        excludeRoutes: excludes,
        killSwitch: killSwitchEnabled?.call() ?? false,
      ),
      XrayProfile() || HysteriaProfile() => SocksSession(
        bundle: await cores.resolve(
          profile,
          tunnel: tunnel,
          socks: policy.socks,
          log: log,
          xrayOptions: policy.xrayOptions,
        ),
        slot: slot,
        tunnel: tunnel,
        instanceId: instanceId,
        socks: policy.socks,
        log: log,
        excludeRoutes: excludes,
        dnsServers: policy.tunDnsServers,
        disallowedPackages: disallowed,
        killSwitch: killSwitchEnabled?.call() ?? false,
      ),
    };
  }

  Future<void> _tearDown() async {
    final session = _session;
    if (session != null) {
      await session.stop();
      _session = null;
    } else {
      await slot.release();
    }
  }

  String _backendLabel(VpnProfile profile) => switch (profile) {
    TrustTunnelProfile() => 'trusttunnel',
    HysteriaProfile() => 'hysteria2',
    XrayProfile() => 'xray',
  };

  void _emit({
    ConnectionPhase? phase,
    String? message,
    List<String>? logs,
    String? coreVersion,
    bool? autoConnect,
    bool? smartConnect,
    List<SavedProfile>? savedProfiles,
    List<String>? excludeRoutes,
    List<String>? disallowedPackages,
    bool? elevationRequired,
    String? activeShareLink,
    List<VpnSubscription>? subscriptions,
    DateTime? connectedAt,
  }) {
    var nextConnectedAt = connectedAt ?? _state.connectedAt;
    var clearConnectedAt = false;
    if (phase == ConnectionPhase.connected) {
      nextConnectedAt = nextConnectedAt ?? DateTime.now().toUtc();
      unawaited(store.setConnectedAt(nextConnectedAt));
    } else if (phase == ConnectionPhase.idle ||
        phase == ConnectionPhase.error) {
      clearConnectedAt = true;
      unawaited(store.setConnectedAt(null));
    }
    _state = _state.copyWith(
      phase: phase,
      message: message,
      logs: logs,
      coreVersion: coreVersion,
      autoConnect: autoConnect,
      smartConnect: smartConnect,
      savedProfiles: savedProfiles,
      excludeRoutes: excludeRoutes,
      disallowedPackages: disallowedPackages,
      elevationRequired: elevationRequired,
      activeShareLink: activeShareLink,
      connectedAt: nextConnectedAt,
      clearConnectedAt: clearConnectedAt,
      subscriptions: subscriptions,
    );
    onState(_state);
  }
}
