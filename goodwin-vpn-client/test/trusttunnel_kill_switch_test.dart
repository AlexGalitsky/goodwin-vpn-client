import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_client/trusttunnel_vpn.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:vpn_plugin/models/configuration.dart';
import 'package:vpn_plugin/models/logs/log_record.dart';
import 'package:vpn_plugin/models/query_log_row.dart';
import 'package:vpn_plugin/models/vpn_mode.dart';
import 'package:vpn_plugin/platform_api.g.dart';
import 'package:vpn_plugin/vpn_plugin.dart';

void main() {
  final profile = TrustTunnelProfile(
    name: 'demo',
    endpoint: 'demo.example:443',
    hostname: 'demo.example',
    addresses: const ['203.0.113.10'],
    username: 'user',
    password: 'pass',
    upstreamProtocol: 'http2',
    dnsUpstreams: const ['1.1.1.1'],
  );

  test('start arms plugin Kill Switch; stop disarms then disconnects', () async {
    final plugin = FakeVpnPlugin();
    final vpn = TrustTunnelVpn(plugin: plugin, isSupported: true);

    await vpn.start(profile, killSwitch: true);
    expect(plugin.startConfigs, hasLength(1));
    expect(plugin.startConfigs.single.killSwitchEnabled, isTrue);
    expect(plugin.stopCalls, 0);

    await vpn.stop();
    expect(plugin.updateConfigs, isNotEmpty);
    expect(plugin.updateConfigs.last!.killSwitchEnabled, isFalse);
    expect(plugin.startConfigs.last.killSwitchEnabled, isFalse);
    expect(plugin.stopCalls, 1);
    expect(await plugin.getCurrentState(), VpnManagerState.disconnected);
  });

  test('stop without Kill Switch does not rewrite config', () async {
    final plugin = FakeVpnPlugin();
    final vpn = TrustTunnelVpn(plugin: plugin, isSupported: true);

    await vpn.start(profile);
    expect(plugin.startConfigs.single.killSwitchEnabled, isFalse);

    await vpn.stop();
    expect(plugin.updateConfigs, isEmpty);
    expect(plugin.startConfigs, hasLength(1));
    expect(plugin.stopCalls, 1);
  });

  test('Kill Switch disarm keeps general mode and domain exclusions', () async {
    final plugin = FakeVpnPlugin();
    final vpn = TrustTunnelVpn(plugin: plugin, isSupported: true);

    await vpn.start(
      profile,
      excludeRoutes: const ['.corp.local', '10.1.0.0/16'],
      killSwitch: true,
    );
    expect(plugin.startConfigs.single.vpnMode, VpnMode.general);
    expect(
      plugin.startConfigs.single.endpoint.exclusions,
      contains('.corp.local'),
    );
    expect(
      plugin.startConfigs.single.tun.excludedRoutes,
      contains('10.1.0.0/16'),
    );

    await vpn.stop();
    expect(plugin.updateConfigs, isNotEmpty);
    expect(plugin.updateConfigs.last!.vpnMode, VpnMode.general);
    expect(plugin.updateConfigs.last!.killSwitchEnabled, isFalse);
    expect(
      plugin.updateConfigs.last!.endpoint.exclusions,
      contains('.corp.local'),
    );
    expect(plugin.stopCalls, 1);
  });
}

class FakeVpnPlugin implements VpnPlugin {
  final _states = StreamController<VpnManagerState>.broadcast();
  var current = VpnManagerState.disconnected;
  final startConfigs = <Configuration>[];
  final updateConfigs = <Configuration?>[];
  var stopCalls = 0;

  @override
  Stream<VpnManagerState> get states => _states.stream;

  @override
  Stream<QueryLogRow> get queryLog => const Stream.empty();

  @override
  Future<VpnManagerState> getCurrentState() async => current;

  @override
  Future<void> start({required Configuration configuration}) async {
    startConfigs.add(configuration);
    current = VpnManagerState.connected;
    _states.add(current);
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    current = VpnManagerState.disconnected;
    _states.add(current);
  }

  @override
  Future<void> updateConfiguration({required Configuration? configuration}) async {
    updateConfigs.add(configuration);
  }

  @override
  Future<void> clearLogs() async {}

  @override
  Future<List<LogRecord>> exportLogsFor(List<String> paths) async => const [];

  @override
  Future<List<String>> fetchLogsPath() async => const [];
}
