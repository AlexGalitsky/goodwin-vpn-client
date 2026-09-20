import 'dart:async';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import 'package:goodwin_vpn_client/features/connection/domain/node_endpoint.dart';
import 'package:goodwin_vpn_client/features/connection/domain/tcp_latency_probe.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo_client.dart';
import 'package:goodwin_vpn_client/session/goodwin_service.dart';
import 'package:goodwin_vpn_client/session/goodwin_service_client.dart';
import 'package:goodwin_vpn_client/session/go_core_switch.dart';
import 'package:goodwin_vpn_client/session/process_restarter.dart';
import 'package:goodwin_vpn_client/session/connectivity_monitor.dart';
import 'package:goodwin_vpn_client/session/socks_core_resolver.dart';
import 'package:goodwin_vpn_client/session/socks_inbound.dart';
import 'package:goodwin_vpn_client/session/subscription_client.dart';
import 'package:goodwin_vpn_client/session/subscription_parser.dart';
import 'package:goodwin_vpn_client/vpn/system_tunnel.dart';

/// SOCKS engine stand-in ([XrayVpnCore] / [HysteriaVpnCore]).
class FakeSocksEngine implements VpnCore {
  FakeSocksEngine({this.id = 'fake', this.engineVersion = 'test'});

  @override
  final String id;

  @override
  final String? engineVersion;

  var startCalls = 0;
  var stopCalls = 0;
  var adoptCalls = 0;
  var running = false;

  /// Native instance still alive after a Dart restart (new wrapper).
  var nativeRunning = false;
  String? lastConfig;

  @override
  bool get isRunning => running;

  @override
  void start({required String instanceId, required String configJson}) {
    startCalls++;
    lastConfig = configJson;
    running = true;
    nativeRunning = true;
  }

  @override
  void stop(String instanceId) {
    stopCalls++;
    running = false;
    nativeRunning = false;
  }

  @override
  bool isInstanceRunning(String instanceId) => nativeRunning;

  @override
  void adopt(String instanceId) {
    adoptCalls++;
    running = true;
    nativeRunning = true;
  }
}

class FakeSystemTunnel implements SystemTunnel {
  FakeSystemTunnel({
    this.isSupported = true,
    this.supportsIpv6RouteExclude = true,
    bool needsElevationOnPrepare = false,
  }) : _needsElevationOnPrepare = needsElevationOnPrepare;

  final _events = StreamController<SystemTunnelEvent>.broadcast();
  Completer<void>? blockStart;
  Completer<void>? blockStop;
  Object? startError;
  Object? stopError;

  var startCalls = 0;
  var stopCalls = 0;
  var prepareCalls = 0;
  var prepareResult = true;
  var established = false;
  var elevationRequests = 0;
  var elevationResult = true;
  String? lastBypassHost;
  List<String> lastExcludeRoutes = const [];
  List<String> lastDnsServers = const [];
  List<String> lastDisallowedPackages = const [];
  var lastKillSwitch = false;
  String? lastSocksUsername;
  String? lastSocksPassword;

  final bool _needsElevationOnPrepare;

  @override
  final bool isSupported;

  @override
  final bool supportsIpv6RouteExclude;

  @override
  bool get needsElevationOnPrepare => _needsElevationOnPrepare;

  @override
  Stream<SystemTunnelEvent> get events => _events.stream;

  void emit(SystemTunnelEvent event) => _events.add(event);

  void revoke({String message = 'onRevoke'}) {
    emit(SystemTunnelEvent(SystemTunnelKind.revoked, message: message));
  }

  void emitStopped({String? message}) {
    established = false;
    emit(SystemTunnelEvent(SystemTunnelKind.stopped, message: message));
  }

  @override
  Future<String?> nativeLibraryDir() async => null;

  @override
  Future<bool> prepare() async {
    prepareCalls++;
    return prepareResult;
  }

  @override
  Future<bool> requestElevation() async {
    elevationRequests++;
    return elevationResult;
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
    startCalls++;
    lastBypassHost = bypassHost;
    lastExcludeRoutes = List<String>.from(excludeRoutes);
    lastDnsServers = List<String>.from(dnsServers);
    lastDisallowedPackages = List<String>.from(disallowedPackages);
    lastKillSwitch = killSwitch;
    lastSocksUsername = socksUsername;
    lastSocksPassword = socksPassword;
    final error = startError;
    if (error != null) {
      emit(
        SystemTunnelEvent(SystemTunnelKind.failed, message: error.toString()),
      );
      throw error;
    }
    final block = blockStart;
    if (block != null) await block.future;
    established = true;
    emit(const SystemTunnelEvent(SystemTunnelKind.established));
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    if (stopError != null) {
      throw stopError!;
    }
    if (!established) {
      emit(
        const SystemTunnelEvent(
          SystemTunnelKind.stopped,
          message: 'already stopped',
        ),
      );
      return;
    }
    final block = blockStop;
    if (block != null) await block.future;
    established = false;
    emit(const SystemTunnelEvent(SystemTunnelKind.stopped));
  }

  @override
  Future<bool> isEstablished() async => established;
}

/// TrustTunnel plugin stand-in. [stop] does not complete until [emitDisconnected].
class FakeOwnedVpnEngine implements OwnedVpnEngine {
  FakeOwnedVpnEngine({this.isSupported = true});

  final states = StreamController<bool>.broadcast();
  final unexpectedDropController = StreamController<void>.broadcast();
  Completer<void>? _disconnecting;
  var connected = false;
  var startCalls = 0;
  var stopCalls = 0;
  TrustTunnelProfile? lastProfile;
  List<String> lastExcludeRoutes = const [];
  var lastKillSwitch = false;

  @override
  final bool isSupported;

  @override
  Stream<void> get unexpectedDrops => unexpectedDropController.stream;

  /// Completes the in-flight [stop], like `VpnManagerState.disconnected`.
  void emitDisconnected() {
    if (!connected && _disconnecting == null) return;
    connected = false;
    states.add(false);
    final gate = _disconnecting;
    _disconnecting = null;
    if (gate != null && !gate.isCompleted) {
      gate.complete();
    }
  }

  /// OS toggle while connected — not an in-app [stop].
  void dropFromOs() {
    connected = false;
    states.add(false);
    unexpectedDropController.add(null);
  }

  @override
  Future<bool> isConnected() async => connected;

  @override
  Future<void> start(
    TrustTunnelProfile profile, {
    List<String> excludeRoutes = const [],
    bool killSwitch = false,
  }) async {
    startCalls++;
    lastProfile = profile;
    lastExcludeRoutes = List<String>.from(excludeRoutes);
    lastKillSwitch = killSwitch;
    connected = true;
    states.add(true);
  }

  @override
  Future<void> stop({Duration timeout = const Duration(seconds: 15)}) async {
    stopCalls++;
    if (!connected) return;
    _disconnecting ??= Completer<void>();
    await _disconnecting!.future.timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'TrustTunnel did not disconnect within ${timeout.inSeconds}s',
      ),
    );
  }
}

class FakeSocksCoreResolver implements SocksCoreResolver {
  FakeSocksCoreResolver(this.core, {this.enforceGoSwitch = false});

  final FakeSocksEngine core;
  final profiles = <VpnProfile>[];
  final bool enforceGoSwitch;
  String? _loadedGoCoreId;
  XrayBuildOptions? lastXrayOptions;
  String? lastConfigJson;

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
    final id = switch (profile) {
      XrayProfile() => 'xray',
      HysteriaProfile() => 'hysteria2',
      TrustTunnelProfile() => throw StateError(
        'TrustTunnel is not a SOCKS engine',
      ),
    };
    if (enforceGoSwitch && _loadedGoCoreId != null && _loadedGoCoreId != id) {
      throw GoCoreSwitchRequired(from: _loadedGoCoreId!, to: id);
    }
    _loadedGoCoreId = id;
    profiles.add(profile);
    lastXrayOptions = xrayOptions;
    final configJson = switch (profile) {
      XrayProfile() => XrayConfigBuilder(
        socksPort: socks.port,
        socksUser: socks.username,
        socksPass: socks.password,
      ).buildJson(profile, options: xrayOptions, pretty: false),
      HysteriaProfile() => HysteriaConfigBuilder(
        socksPort: socks.port,
        socksUser: socks.username,
        socksPass: socks.password,
      ).buildJson(profile, pretty: false),
      TrustTunnelProfile() => '{"port":${socks.port}}',
    };
    lastConfigJson = configJson;
    return SocksEngineBundle(
      core: core,
      configJson: configJson,
      profileName: switch (profile) {
        XrayProfile(:final name) => name,
        HysteriaProfile(:final name) => name,
        TrustTunnelProfile(:final name) => name,
      },
      serverHost: switch (profile) {
        XrayProfile(:final address) => address,
        HysteriaProfile(:final address) => address,
        TrustTunnelProfile() => '',
      },
    );
  }
}

class RecordingProcessRestarter implements ProcessRestarter {
  var calls = 0;

  @override
  Future<void> restart() async {
    calls++;
  }
}

class FakeConnectivityMonitor implements ConnectivityMonitor {
  FakeConnectivityMonitor({List<ConnectivityResult>? initial})
    : current = initial ?? const [ConnectivityResult.wifi];

  final _events = StreamController<List<ConnectivityResult>>.broadcast();
  List<ConnectivityResult> current;

  @override
  Stream<List<ConnectivityResult>> get onChanged => _events.stream;

  void emit(List<ConnectivityResult> results) {
    current = results;
    _events.add(results);
  }

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => current;

  void close() => _events.close();
}

XrayProfile sampleXray() => const XrayProfile(
  name: 'vless-test',
  protocol: XrayProtocol.vless,
  address: '203.0.113.1',
  port: 443,
  id: 'id',
);

/// Fleet share-link shape: VLESS + gRPC + REALITY, no Vision flow.
XrayProfile sampleGoodwinVless() => const XrayProfile(
  name: 'vless-grpc',
  protocol: XrayProtocol.vless,
  address: '203.0.113.1',
  port: 443,
  id: 'id',
  network: 'grpc',
  security: 'reality',
  sni: 'www.cloudflare.com',
  fingerprint: 'chrome',
  publicKey: 'PUBLICKEY',
  shortId: 'abcd',
  serviceName: 'goodwin',
  grpcMode: 'gun',
);

/// Public Reality+Vision template (tcp). Mux would make Xray refuse to start.
XrayProfile sampleVisionVless() => const XrayProfile(
  name: 'vless-vision',
  protocol: XrayProtocol.vless,
  address: '203.0.113.1',
  port: 443,
  id: 'id',
  flow: 'xtls-rprx-vision',
  network: 'tcp',
  security: 'reality',
  sni: 'www.cloudflare.com',
  fingerprint: 'chrome',
  publicKey: 'PUBLICKEY',
  shortId: 'abcd',
);

HysteriaProfile sampleHysteria() => const HysteriaProfile(
  name: 'hy2-test',
  address: '203.0.113.1',
  port: 443,
  password: 'secret',
);

TrustTunnelProfile sampleTrustTunnel() => const TrustTunnelProfile(
  name: 'tt-test',
  endpoint: 'example.com',
  hostname: 'example.com',
  addresses: ['203.0.113.1'],
  username: 'user',
  password: 'pass',
);

class FakeSubscriptionClient implements SubscriptionClient {
  FakeSubscriptionClient({
    this.document,
    Map<String, SubscriptionDocument>? byUrl,
    this.error,
  }) : byUrl = byUrl ?? {};

  SubscriptionDocument? document;
  final Map<String, SubscriptionDocument> byUrl;
  Object? error;
  var fetchCount = 0;
  final fetchedUrls = <Uri>[];

  @override
  Future<SubscriptionDocument> fetch(Uri url) async {
    fetchCount++;
    fetchedUrls.add(url);
    if (error != null) {
      throw error!;
    }
    final hit = byUrl[url.toString()] ?? document;
    if (hit == null) {
      throw SubscriptionParseException('no document for $url');
    }
    return hit;
  }
}

class FakeGoodwinServiceClient implements GoodwinServiceClient {
  FakeGoodwinServiceClient({this.catalog, this.error});

  GoodwinServiceCatalog? catalog;
  Object? error;
  var fetchCount = 0;
  final fetchedBases = <String>[];

  @override
  Future<GoodwinServiceCatalog?> fetchCatalog(String serviceBase) async {
    fetchCount++;
    fetchedBases.add(serviceBase);
    if (error != null) throw error!;
    return catalog;
  }
}

class FakeGoodwinGeoClient implements GoodwinGeoClient {
  FakeGoodwinGeoClient({this.manifest, this.packBytes});

  GeoManifest? manifest;
  Uint8List? packBytes;
  var manifestCount = 0;
  var packCount = 0;

  @override
  Future<GeoManifest?> fetchManifest(String serviceBase) async {
    manifestCount++;
    return manifest;
  }

  @override
  Future<Uint8List?> fetchPackBytes({
    required String serviceBase,
    required GeoPackMeta meta,
  }) async {
    packCount++;
    return packBytes;
  }
}

class FakeLatencyProbe implements LatencyProbe {
  FakeLatencyProbe({this.milliseconds = 42});

  final int? milliseconds;
  var measureCalls = 0;

  @override
  Future<int?> measure(
    NodeEndpoint endpoint, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    measureCalls++;
    return milliseconds;
  }
}
