import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_client/trusttunnel_vpn.dart';
import 'package:goodwin_vpn_client/vpn/trusttunnel_excludes.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:vpn_plugin/models/configuration_log_level.dart';
import 'package:vpn_plugin/models/vpn_mode.dart';

void main() {
  final vpn = TrustTunnelVpn();

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

  test('encodeToml puts IP/CIDR excludes on listener.tun.excluded_routes', () {
    final toml = vpn.encodeToml(
      profile,
      excludeRoutes: const [
        '192.162.0.0/16',
        '192.162.1.1',
        '*.lan.example',
      ],
    );
    expect(toml, contains('[listener.tun]'));
    expect(toml, contains('excluded_routes'));
    expect(toml, contains('192.162.0.0/16'));
    expect(toml, contains('192.162.1.1/32'));
    expect(toml, contains('192.168.0.0/16')); // default private
    expect(toml, contains('exclusions'));
    expect(toml, contains('*.lan.example'));
    // CIDR must not be forced only into app-level exclusions.
    expect(toml, contains('killswitch_enabled'));
  });

  test('splitTrustTunnelExcludes normalizes hosts and keeps defaults', () {
    final split = splitTrustTunnelExcludes(const [
      '192.162.1.100',
      '192.162.0.0/16',
      'corp.local',
    ]);
    expect(split.tunCidrs, contains('192.162.1.100/32'));
    expect(split.tunCidrs, contains('192.162.0.0/16'));
    expect(split.tunCidrs, contains('10.0.0.0/8'));
    expect(split.domainExclusions, ['corp.local']);
  });

  test('decodeDeepLink builds Configuration from tt profile fields', () {
    final config = vpn.configurationFromProfile(profile);
    expect(config.endpoint.hostName, 'demo.example');
    expect(config.endpoint.addresses, ['203.0.113.10']);
    expect(config.logLevel, ConfigurationLogLevel.info);
    expect(config.tun.excludedRoutes, contains('192.168.0.0/16'));
    expect(config.killSwitchEnabled, isFalse);
    expect(config.vpnMode, VpnMode.general);
    expect(
      vpn.configurationFromProfile(profile, killSwitch: true).killSwitchEnabled,
      isTrue,
    );
    expect(vpn.encodeToml(profile, killSwitch: true), contains('killswitch_enabled'));
  });

  test('decodeDeepLink rejects non-tt links', () {
    expect(
      () => vpn.decodeDeepLink('hy2://user@host:443/'),
      throwsA(isA<FormatException>()),
    );
  });
}
