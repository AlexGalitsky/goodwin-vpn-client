import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:vpn_plugin/domain/configuration_codec.dart';
import 'package:vpn_plugin/models/configuration.dart';
import 'package:vpn_plugin/models/configuration_log_level.dart';
import 'package:vpn_plugin/models/endpoint.dart';
import 'package:vpn_plugin/models/socks.dart';
import 'package:vpn_plugin/models/tun.dart';
import 'package:vpn_plugin/models/upstream_protocol.dart';
import 'package:vpn_plugin/models/vpn_mode.dart';
import 'package:vpn_plugin/platform_api.g.dart';
import 'package:vpn_plugin/vpn_plugin.dart';

import 'vpn/system_tunnel.dart';
import 'vpn/trusttunnel_excludes.dart';
import 'session/tunnel_elevation.dart';

/// Official TrustTunnel Flutter plugin — owns system VPN
/// (Android VpnService, Windows vpn_easy, macOS Packet Tunnel).
class TrustTunnelVpn implements OwnedVpnEngine {
  TrustTunnelVpn({
    VpnPlugin? plugin,
    bool? isSupported,
  })  : _plugin = plugin ?? VpnPluginImpl(),
        _supportedOverride = isSupported;

  final VpnPlugin _plugin;
  final bool? _supportedOverride;
  StreamSubscription<VpnManagerState>? _states;
  TrustTunnelProfile? _activeProfile;
  List<String> _activeExcludes = const [];
  var _killSwitchArmed = false;
  var _expectStop = false;
  final _unexpectedDrops = StreamController<void>.broadcast();

  @override
  Stream<void> get unexpectedDrops => _unexpectedDrops.stream;

  @override
  bool get isSupported =>
      _supportedOverride ??
      (Platform.isAndroid ||
          Platform.isWindows ||
          Platform.isMacOS ||
          Platform.isIOS);

  Configuration configurationFromProfile(
    TrustTunnelProfile profile, {
    List<String> excludeRoutes = const [],
    bool killSwitch = false,
  }) {
    final hostname = profile.hostname?.trim() ?? '';
    final username = profile.username;
    final password = profile.password;
    if (hostname.isEmpty || profile.addresses.isEmpty || username == null || password == null) {
      throw StateError(
        'incomplete tt:// profile — need hostname, addresses, username, password (spec v1 TLV)',
      );
    }

    final protocol = switch (profile.upstreamProtocol) {
      'http3' => UpStreamProtocol.http3,
      _ => UpStreamProtocol.http2,
    };

    final dns = profile.dnsUpstreams.isNotEmpty
        ? profile.dnsUpstreams
        : const ['1.1.1.1', '8.8.8.8'];

    // Always-exclude IPs/CIDRs must go to listener.tun.excluded_routes (OS bypass).
    // Putting CIDRs only in top-level `exclusions` is wrong for LAN/IP reachability
    // and can fail for ranges like 192.162.0.0/16. Domains stay in `exclusions`.
    final split = splitTrustTunnelExcludes(excludeRoutes);

    // R1: always general. Direct/selective is not enabled until verified on device.
    // Rules `direct` hosts/CIDRs are merged into exclusions / tun.excludedRoutes.
    return Configuration(
      logLevel: ConfigurationLogLevel.info,
      vpnMode: VpnMode.general,
      // Session-scoped: on while TT owns the slot. [stop] disarms before
      // disconnect so hev can establish(). Never leave this true across handoff.
      killSwitchEnabled: killSwitch,
      postQuantumGroupEnabled: true,
      endpoint: Endpoint(
        name: profile.name,
        hostName: hostname,
        username: username,
        password: password,
        hasIpv6: profile.hasIpv6,
        addresses: profile.addresses,
        dnsUpStreams: dns,
        customSni: profile.customSni ?? '',
        skipVerification: profile.skipVerification,
        antiDpi: profile.antiDpi,
        upStreamProtocol: protocol,
        exclusions: split.domainExclusions,
      ),
      tun: Tun(excludedRoutes: split.tunCidrs),
      socks: const Socks(),
    );
  }

  /// Full client TOML for `vpn_easy_start` / ConfigurationCodec (Windows in-process).
  String encodeToml(
    TrustTunnelProfile profile, {
    List<String> excludeRoutes = const [],
    bool killSwitch = false,
  }) {
    return const ConfigurationCodec().encode(
      configurationFromProfile(
        profile,
        excludeRoutes: excludeRoutes,
        killSwitch: killSwitch,
      ),
    );
  }

  /// Windows deep-link path: Dart TLV parse → Configuration (no native deeplink-ffi).
  Configuration decodeDeepLink(String uri, {List<String> excludeRoutes = const []}) {
    final profile = const ShareLinkParser().parse(uri.trim());
    if (profile is! TrustTunnelProfile) {
      throw FormatException('expected tt:// TrustTunnel deep link, got ${profile.runtimeType}');
    }
    return configurationFromProfile(profile, excludeRoutes: excludeRoutes);
  }

  @override
  Future<void> start(
    TrustTunnelProfile profile, {
    List<String> excludeRoutes = const [],
    bool killSwitch = false,
    Duration timeout = const Duration(seconds: 45),
  }) async {
    if (!isSupported) {
      throw StateError(
        'TrustTunnel engine is supported on Android, Windows, macOS, and iOS only',
      );
    }

    // Ensure previous TT session released the system VPN before starting again.
    await stop(timeout: const Duration(seconds: 10));

    final config = configurationFromProfile(
      profile,
      excludeRoutes: excludeRoutes,
      killSwitch: killSwitch,
    );
    final connected = Completer<void>();
    await _states?.cancel();
    _expectStop = false;
    _states = _plugin.states.listen((state) {
      if (state == VpnManagerState.connected && !connected.isCompleted) {
        connected.complete();
      } else if (state == VpnManagerState.disconnected &&
          connected.isCompleted &&
          !_expectStop) {
        if (!_unexpectedDrops.isClosed) {
          _unexpectedDrops.add(null);
        }
        _clearSession();
      }
    });

    try {
      await _plugin.start(configuration: config);
    } on PlatformException catch (e) {
      if (e.code == 'elevation_required') {
        throw const TunnelElevationRequired();
      }
      rethrow;
    }
    await connected.future.timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'TrustTunnel did not reach connected within ${timeout.inSeconds}s',
      ),
    );
    _activeProfile = profile;
    _activeExcludes = List<String>.from(excludeRoutes);
    _killSwitchArmed = killSwitch;
  }

  @override
  Future<bool> isConnected() async {
    if (!isSupported) return false;
    try {
      return await _plugin.getCurrentState() == VpnManagerState.connected;
    } catch (_) {
      return false;
    }
  }

  /// Stops the engine and waits until the platform reports [VpnManagerState.disconnected]
  /// so another VpnService (hev) can establish a TUN.
  @override
  Future<void> stop({Duration timeout = const Duration(seconds: 15)}) async {
    if (!isSupported) return;

    try {
      final current = await _plugin.getCurrentState();
      if (current == VpnManagerState.disconnected) {
        _clearSession();
        return;
      }
    } catch (_) {}

    await _disarmKillSwitch();

    _expectStop = true;
    final done = Completer<void>();
    await _states?.cancel();
    _states = _plugin.states.listen((state) {
      if (state == VpnManagerState.disconnected && !done.isCompleted) {
        done.complete();
      }
    });

    try {
      await _plugin.stop();
      try {
        final after = await _plugin.getCurrentState();
        if (after == VpnManagerState.disconnected && !done.isCompleted) {
          done.complete();
        }
      } catch (_) {}
      await done.future.timeout(
        timeout,
        onTimeout: () => throw TimeoutException(
          'TrustTunnel did not disconnect within ${timeout.inSeconds}s',
        ),
      );
    } finally {
      await _states?.cancel();
      _states = null;
      _expectStop = false;
      _clearSession();
    }
  }

  /// Apply KS-off config to the running plugin *before* [VpnPlugin.stop], so
  /// on-demand / block-without-VPN does not hold the OS slot for hev.
  Future<void> _disarmKillSwitch() async {
    if (!_killSwitchArmed) return;
    final profile = _activeProfile;
    final excludes = _activeExcludes;
    _killSwitchArmed = false;
    if (profile == null) return;

    final disarmed = configurationFromProfile(
      profile,
      excludeRoutes: excludes,
      killSwitch: false,
    );
    try {
      await _plugin.updateConfiguration(configuration: disarmed);
    } catch (_) {}
    try {
      await _plugin.start(configuration: disarmed);
    } catch (_) {}
  }

  void _clearSession() {
    _killSwitchArmed = false;
    _activeProfile = null;
    _activeExcludes = const [];
  }
}
