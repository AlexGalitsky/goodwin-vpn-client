import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'vpn/system_tunnel.dart';

/// Android VpnService + hev-socks5-tunnel (TUN → local SOCKS).
///
/// [start] / [stop] wait for [events], not for MethodChannel returning.
class AndroidVpnBridge implements SystemTunnel {
  AndroidVpnBridge();

  static const _channel = MethodChannel('website.goodwin.vpn/android');
  static const _eventChannel = EventChannel('website.goodwin.vpn/android/events');

  static const _waitTimeout = Duration(seconds: 15);

  StreamController<SystemTunnelEvent>? _controller;

  @override
  bool get isSupported => Platform.isAndroid;

  @override
  bool get needsElevationOnPrepare => false;

  bool _supportsIpv6RouteExclude = false;

  @override
  bool get supportsIpv6RouteExclude => _supportsIpv6RouteExclude;

  @override
  Future<bool> requestElevation() async => false;

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
    final sdk = await _channel.invokeMethod<int>('sdkInt');
    _supportsIpv6RouteExclude = (sdk ?? 0) >= 33;
    return ok ?? false;
  }

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
    final event = await _invokeAndWait(
      () => _channel.invokeMethod<void>(
        'startVpn',
        androidStartVpnArgs(
          socksHost: socksHost,
          socksPort: socksPort,
          socksUsername: socksUsername,
          socksPassword: socksPassword,
          bypassHost: bypassHost,
          excludeRoutes: excludeRoutes,
          dnsServers: dnsServers,
          disallowedPackages: disallowedPackages,
        ),
      ),
      kinds: {SystemTunnelKind.established, SystemTunnelKind.failed},
      label: 'system VPN establish',
    );
    if (event.kind == SystemTunnelKind.failed) {
      throw StateError(event.message ?? 'system VPN establish failed');
    }
  }

  @override
  Future<void> stop() async {
    if (!isSupported) return;
    // Idle release on Connect must not wait for STOPPED — the service emits
    // nothing when the TUN was never up (would hang 15s and block Connect).
    if (!await isEstablished()) return;
    await _invokeAndWait(
      () => _channel.invokeMethod<void>('stopVpn'),
      kinds: {SystemTunnelKind.stopped},
      label: 'system VPN stop',
    );
  }

  @override
  Future<String?> nativeLibraryDir() async {
    if (!isSupported) return null;
    return _channel.invokeMethod<String>('nativeLibraryDir');
  }

  @override
  Future<bool> isEstablished() async {
    if (!isSupported) return false;
    final ok = await _channel.invokeMethod<bool>('isEstablished');
    return ok ?? false;
  }

  Future<SystemTunnelEvent> _invokeAndWait(
    Future<void> Function() invoke, {
    required Set<SystemTunnelKind> kinds,
    required String label,
  }) async {
    _ensureNativeListen();
    final done = Completer<SystemTunnelEvent>();
    final sub = events.listen((event) {
      if (kinds.contains(event.kind) && !done.isCompleted) {
        done.complete(event);
      }
    });
    try {
      await invoke();
      return await done.future.timeout(
        _waitTimeout,
        onTimeout: () => throw TimeoutException(
          '$label timed out after ${_waitTimeout.inSeconds}s',
        ),
      );
    } finally {
      await sub.cancel();
    }
  }
}

/// MethodChannel payload for Android `startVpn` (testable without Events).
Map<String, Object?> androidStartVpnArgs({
  required String socksHost,
  required int socksPort,
  String? socksUsername,
  String? socksPassword,
  String? bypassHost,
  List<String> excludeRoutes = const [],
  List<String> dnsServers = const [],
  List<String> disallowedPackages = const [],
}) {
  final dns = [
    for (final server in dnsServers)
      if (server.trim().isNotEmpty) server.trim(),
  ];
  final disallowed = [
    for (final package in disallowedPackages)
      if (package.trim().isNotEmpty) package.trim(),
  ];
  final user = socksUsername?.trim() ?? '';
  final pass = socksPassword?.trim() ?? '';
  return {
    'socksHost': socksHost,
    'socksPort': socksPort,
    if (user.isNotEmpty) 'socksUsername': user,
    if (pass.isNotEmpty) 'socksPassword': pass,
    if (bypassHost != null && bypassHost.trim().isNotEmpty)
      'bypassHost': bypassHost.trim(),
    if (excludeRoutes.isNotEmpty)
      'excludeRoutes': [
        for (final route in excludeRoutes)
          if (route.trim().isNotEmpty) route.trim(),
      ],
    if (dns.isNotEmpty) 'dnsServers': dns,
    if (disallowed.isNotEmpty) 'disallowedPackages': disallowed,
  };
}
