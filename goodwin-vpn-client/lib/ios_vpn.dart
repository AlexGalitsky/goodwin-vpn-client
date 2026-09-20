import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'session/socks_session.dart';
import 'session/tunnel_elevation.dart';
import 'vpn/system_tunnel.dart';

/// iOS Packet Tunnel (SocksTunnel.appex) hosts Xray/Hy2 + tun2socks (one Go runtime).
class IosVpnBridge implements SystemTunnel {
  IosVpnBridge();

  static const _channel = MethodChannel('website.goodwin.vpn/ios');
  static const _eventChannel = EventChannel('website.goodwin.vpn/ios/events');

  static const _waitTimeout = Duration(seconds: 45);

  StreamController<SystemTunnelEvent>? _controller;

  @override
  bool get isSupported => Platform.isIOS;

  @override
  bool get needsElevationOnPrepare => false;

  @override
  bool get supportsIpv6RouteExclude => true;

  @override
  Stream<SystemTunnelEvent> get events {
    _ensureNativeListen();
    return _controller!.stream;
  }

  void _ensureNativeListen() {
    if (_controller != null) return;
    _controller = StreamController<SystemTunnelEvent>.broadcast();
    if (!isSupported) return;
    _eventChannel.receiveBroadcastStream().listen((raw) {
      final event = _parse(raw);
      if (event != null) {
        _controller!.add(event);
      }
    });
  }

  static SystemTunnelEvent? _parse(dynamic raw) {
    if (raw is! Map) return null;
    final kindRaw = raw['kind']?.toString();
    final message = raw['message']?.toString();
    final kind = switch (kindRaw) {
      'established' => SystemTunnelKind.established,
      'failed' => SystemTunnelKind.failed,
      'revoked' => SystemTunnelKind.revoked,
      'stopped' => SystemTunnelKind.stopped,
      _ => null,
    };
    if (kind == null) return null;
    return SystemTunnelEvent(kind, message: message);
  }

  @override
  Future<bool> prepare() async {
    if (!isSupported) return true;
    final ok = await _channel.invokeMethod<bool>('prepare');
    return ok ?? false;
  }

  @override
  Future<bool> requestElevation() async => false;

  @override
  Future<void> start({
    String socksHost = '127.0.0.1',
    int socksPort = 10808,
    String? socksUsername,
    String? socksPassword,
    String? bypassHost,
    List<String> excludeRoutes = const [],
    List<String> dnsServers = const [],
    String? engineId,
    String? configJson,
    List<String> disallowedPackages = const [],
    bool killSwitch = false,
  }) async {
    if (!isSupported) return;
    if (engineId == null || engineId.isEmpty) {
      throw StateError('iOS SOCKS NE requires engineId');
    }
    if (configJson == null || configJson.isEmpty) {
      throw StateError('iOS SOCKS NE requires configJson');
    }

    final bypassIps = await SocksSession.resolveTunnelPins(bypassHost ?? '');
    final mergedExcludes = <String>{
      ...excludeRoutes,
      for (final ip in bypassIps) SocksSession.pinCidr(ip),
    }.toList();
    final bypassIp = bypassIps.isNotEmpty
        ? SocksSession.selectDialPin(bypassIps)
        : bypassHost;

    final event = await _invokeAndWait(
      () => _channel.invokeMethod<void>('startVpn', {
        'core': engineId,
        'configJson': configJson,
        'socksHost': socksHost,
        'socksPort': socksPort,
        if (bypassIp != null && bypassIp.isNotEmpty) 'bypassHost': bypassIp,
        if (bypassIps.isNotEmpty) 'bypassHosts': bypassIps,
        if (mergedExcludes.isNotEmpty) 'excludeRoutes': mergedExcludes,
        if (dnsServers.isNotEmpty) 'dnsServers': dnsServers,
        'killSwitch': killSwitch,
      }),
      kinds: {SystemTunnelKind.established, SystemTunnelKind.failed},
      label: 'iOS TUN establish',
    );
    if (event.kind == SystemTunnelKind.failed) {
      throw StateError(event.message ?? 'iOS TUN establish failed');
    }
  }

  @override
  Future<void> stop() async {
    if (!isSupported) return;
    if (!await isEstablished()) return;
    try {
      final event = await _invokeAndWait(
        () => _channel.invokeMethod<void>('stopVpn'),
        kinds: {SystemTunnelKind.stopped, SystemTunnelKind.failed},
        label: 'iOS TUN stop',
      );
      if (event.kind == SystemTunnelKind.failed) {
        throw OnDemandDisarmFailed(event.message);
      }
    } on OnDemandDisarmFailed {
      rethrow;
    } on PlatformException catch (e) {
      throw OnDemandDisarmFailed(e.message);
    }
  }

  @override
  Future<bool> isEstablished() async {
    if (!isSupported) return false;
    final ok = await _channel.invokeMethod<bool>('isEstablished');
    return ok ?? false;
  }

  @override
  Future<String?> nativeLibraryDir() async => null;

  Future<SystemTunnelEvent> _invokeAndWait(
    Future<void> Function() invoke, {
    required Set<SystemTunnelKind> kinds,
    required String label,
  }) async {
    _ensureNativeListen();
    final done = Completer<SystemTunnelEvent>();
    late final StreamSubscription<SystemTunnelEvent> sub;
    sub = events.listen((e) {
      if (kinds.contains(e.kind) && !done.isCompleted) {
        done.complete(e);
      }
    });
    try {
      await invoke();
      return await done.future.timeout(
        _waitTimeout,
        onTimeout: () => throw TimeoutException('$label timed out'),
      );
    } finally {
      await sub.cancel();
    }
  }
}
