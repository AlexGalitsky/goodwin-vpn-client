import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'session/socks_session.dart';
import 'vpn/system_tunnel.dart';

/// macOS Packet Tunnel (SocksTunnel.appex) → local SOCKS (same contract as [WindowsVpnBridge]).
class MacOSVpnBridge implements SystemTunnel {
  MacOSVpnBridge();

  static const _channel = MethodChannel('website.goodwin.vpn/macos');
  static const _eventChannel = EventChannel('website.goodwin.vpn/macos/events');

  static const _waitTimeout = Duration(seconds: 30);

  StreamController<SystemTunnelEvent>? _controller;

  @override
  bool get isSupported => Platform.isMacOS;

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
  Future<bool> requestElevation() async {
    if (!isSupported) return false;
    final ok = await _channel.invokeMethod<bool>('requestElevation');
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

    // Resolve VPS host in the main app BEFORE the tunnel captures DNS.
    // Extension-side getaddrinfo often fails or loops; without /32 and /128
    // exclude, the core→VPS path is sucked into the TUN.
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
        'socksHost': socksHost,
        'socksPort': socksPort,
        if (bypassIp != null && bypassIp.isNotEmpty) 'bypassHost': bypassIp,
        if (bypassIps.isNotEmpty) 'bypassHosts': bypassIps,
        if (mergedExcludes.isNotEmpty) 'excludeRoutes': mergedExcludes,
        if (dnsServers.isNotEmpty) 'dnsServers': dnsServers,
      }),
      kinds: {SystemTunnelKind.established, SystemTunnelKind.failed},
      label: 'macOS TUN establish',
    );
    if (event.kind == SystemTunnelKind.failed) {
      throw StateError(event.message ?? 'macOS TUN establish failed');
    }
  }

  @override
  Future<void> stop() async {
    if (!isSupported) return;
    if (!await isEstablished()) return;
    await _invokeAndWait(
      () => _channel.invokeMethod<void>('stopVpn'),
      kinds: {SystemTunnelKind.stopped},
      label: 'macOS TUN stop',
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
