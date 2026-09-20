import 'dart:async';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import '../../features/connection/domain/node_endpoint.dart';
import '../../features/connection/domain/tcp_latency_probe.dart';
import '../../session/socks_core_resolver.dart';
import '../../session/socks_inbound.dart';
import '../../vpn/system_tunnel.dart';

/// Minimal fakes for store screenshots (no real VPN I/O).
class StoreDemoSocksEngine implements VpnCore {
  var running = false;

  @override
  String get id => 'xray';

  @override
  String? get engineVersion => 'store-demo';

  @override
  bool get isRunning => running;

  @override
  void start({required String instanceId, required String configJson}) {
    running = true;
  }

  @override
  void stop(String instanceId) {
    running = false;
  }

  @override
  bool isInstanceRunning(String instanceId) => running;

  @override
  void adopt(String instanceId) {
    running = true;
  }
}

class StoreDemoSocksCoreResolver implements SocksCoreResolver {
  StoreDemoSocksCoreResolver(this.core);

  final StoreDemoSocksEngine core;
  String? _loadedGoCoreId;

  @override
  String? get loadedGoCoreId => _loadedGoCoreId;

  @override
  Future<SocksEngineBundle> resolve(
    VpnProfile profile, {
    required SystemTunnel tunnel,
    required SocksInbound socks,
    required void Function(String line) log,
    XrayBuildOptions xrayOptions = const XrayBuildOptions(),
  }) async {
    _loadedGoCoreId = core.id;
    final host = switch (profile) {
      XrayProfile(:final address) => address,
      HysteriaProfile(:final address) => address,
      TrustTunnelProfile(:final endpoint) => endpoint,
    };
    return SocksEngineBundle(
      core: core,
      configJson: '{}',
      profileName: profile.name,
      serverHost: host,
    );
  }
}

class StoreDemoSystemTunnel implements SystemTunnel {
  final _events = StreamController<SystemTunnelEvent>.broadcast();

  @override
  bool get isSupported => true;

  @override
  bool get supportsIpv6RouteExclude => true;

  @override
  bool get needsElevationOnPrepare => false;

  @override
  Stream<SystemTunnelEvent> get events => _events.stream;

  @override
  Future<bool> prepare() async => true;

  @override
  Future<bool> requestElevation() async => true;

  @override
  Future<bool> isEstablished() async => true;

  @override
  Future<String?> nativeLibraryDir() async => null;

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
    _events.add(const SystemTunnelEvent(SystemTunnelKind.established));
  }

  @override
  Future<void> stop() async {
    _events.add(const SystemTunnelEvent(SystemTunnelKind.stopped));
  }

  void dispose() => unawaited(_events.close());
}

class StoreDemoOwnedEngine implements OwnedVpnEngine {
  @override
  bool get isSupported => true;

  @override
  Stream<void> get unexpectedDrops => const Stream.empty();

  @override
  Future<bool> isConnected() async => false;

  @override
  Future<void> start(
    TrustTunnelProfile profile, {
    List<String> excludeRoutes = const [],
    bool killSwitch = false,
  }) async {}

  @override
  Future<void> stop({Duration timeout = const Duration(seconds: 15)}) async {}
}

class StoreDemoLatencyProbe implements LatencyProbe {
  const StoreDemoLatencyProbe({this.milliseconds = 48});

  final int milliseconds;

  @override
  Future<int?> measure(
    NodeEndpoint endpoint, {
    Duration timeout = const Duration(seconds: 3),
  }) async =>
      milliseconds;
}

XrayProfile storeDemoParseProfile(String _) => const XrayProfile(
      name: 'demo',
      protocol: XrayProtocol.vless,
      address: '203.0.113.10',
      port: 443,
      id: '00000000-0000-4000-8000-000000000001',
    );
