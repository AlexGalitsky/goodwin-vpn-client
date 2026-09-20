import 'dart:io';

import 'android_vpn.dart';
import 'ios_vpn.dart';
import 'macos_vpn.dart';
import 'vpn/system_tunnel.dart';
import 'windows_vpn.dart';

/// Platform [SystemTunnel] for hev/Wintun/macOS/iOS Packet Tunnel (not TrustTunnel).
SystemTunnel createSystemTunnel() {
  if (Platform.isAndroid) return AndroidVpnBridge();
  if (Platform.isWindows) return WindowsVpnBridge();
  if (Platform.isMacOS) return MacOSVpnBridge();
  if (Platform.isIOS) return IosVpnBridge();
  return _NoOpSystemTunnel();
}

class _NoOpSystemTunnel implements SystemTunnel {
  @override
  bool get isSupported => false;

  @override
  bool get needsElevationOnPrepare => false;

  @override
  bool get supportsIpv6RouteExclude => true;

  @override
  Future<bool> requestElevation() async => false;

  @override
  Stream<SystemTunnelEvent> get events => const Stream.empty();

  @override
  Future<bool> prepare() async => true;

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
  }) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<bool> isEstablished() async => false;

  @override
  Future<String?> nativeLibraryDir() async => null;
}
