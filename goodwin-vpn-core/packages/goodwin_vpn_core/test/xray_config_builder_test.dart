import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:test/test.dart';

void main() {
  const parser = ShareLinkParser();
  const builder = XrayConfigBuilder(
    socksPort: 10808,
    socksUser: 'gw',
    socksPass: 'test',
  );

  XrayProfile sampleVless() {
    const link =
        'vless://11111111-2222-3333-4444-555555555555@example.com:8443'
        '?encryption=none&type=grpc&serviceName=svc&mode=gun'
        '&security=reality&sni=www.cloudflare.com&fp=chrome'
        '&pbk=PUBLICKEY&sid=abcd1234#TestNode';
    return parser.parse(link) as XrayProfile;
  }

  test('vless reality grpc → valid outbound shape', () {
    final profile = sampleVless();
    final cfg = builder.buildMap(profile);

    expect(cfg['inbounds'], isA<List>());
    final outbound = (cfg['outbounds'] as List).first as Map<String, dynamic>;
    expect(outbound['protocol'], 'vless');
    expect(outbound['streamSettings']['network'], 'grpc');
    expect(outbound['streamSettings']['security'], 'reality');
    expect(outbound['streamSettings']['realitySettings']['publicKey'], 'PUBLICKEY');
    expect(outbound['streamSettings']['grpcSettings']['serviceName'], 'svc');
    expect(outbound['streamSettings']['grpcSettings']['multiMode'], isFalse);

    final inbound = (cfg['inbounds'] as List).first as Map<String, dynamic>;
    expect(inbound['settings']['auth'], 'password');
    expect(inbound['settings']['accounts'][0]['user'], 'gw');
    expect(inbound['settings']['accounts'][0]['pass'], 'test');
    expect(cfg['inbounds'].toString(), isNot(contains('noauth')));

    final sniffing = inbound['sniffing'] as Map<String, dynamic>;
    expect(sniffing['enabled'], isTrue);
    expect(sniffing['destOverride'], ['http', 'tls', 'quic']);
    expect(sniffing['routeOnly'], isTrue);

    final user = outbound['settings']['vnext'][0]['users'][0] as Map<String, dynamic>;
    expect(user['id'], '11111111-2222-3333-4444-555555555555');
    expect(user['encryption'], 'none');
  });

  test('default routing is global (socks-in → proxy)', () {
    final rules = builder.buildMap(sampleVless())['routing']['rules'] as List;
    expect(rules, hasLength(1));
    expect(rules.single['outboundTag'], 'proxy');
    expect(rules.single['inboundTag'], ['socks-in']);
  });

  test('direct mode catch-all → direct', () {
    final cfg = builder.buildMap(
      sampleVless(),
      options: const XrayBuildOptions(defaultOutbound: 'direct'),
    );
    final rules = cfg['routing']['rules'] as List;
    expect(rules.single['outboundTag'], 'direct');
  });

  test('rules mode inserts extraRules before catch-all', () {
    final cfg = builder.buildMap(
      sampleVless(),
      options: XrayBuildOptions(
        defaultOutbound: 'proxy',
        extraRules: [
          {
            'type': 'field',
            'domain': ['domain:ads.example'],
            'outboundTag': 'block',
          },
          {
            'type': 'field',
            'ip': ['10.0.0.0/8'],
            'outboundTag': 'direct',
          },
        ],
      ),
    );
    final rules = cfg['routing']['rules'] as List;
    expect(rules, hasLength(3));
    expect(rules[0]['outboundTag'], 'block');
    expect(rules[1]['outboundTag'], 'direct');
    expect(rules[2]['outboundTag'], 'proxy');
    expect(rules[2]['inboundTag'], ['socks-in']);
  });

  test('dns / mux / fragment options', () {
    final tls = XrayProfile(
      name: 'tls',
      protocol: XrayProtocol.vless,
      address: 'example.com',
      port: 443,
      id: '11111111-2222-3333-4444-555555555555',
      network: 'tcp',
      security: 'tls',
      sni: 'example.com',
    );
    final cfg = builder.buildMap(
      tls,
      options: const XrayBuildOptions(
        dnsServers: ['1.1.1.1', 'https://dns.google/dns-query'],
        mux: true,
        fragment: true,
      ),
    );

    expect(cfg['dns']['servers'], ['1.1.1.1', 'https://dns.google/dns-query']);

    final outbounds = cfg['outbounds'] as List;
    final proxy = outbounds.first as Map<String, dynamic>;
    expect(proxy['mux']['enabled'], isTrue);
    expect(proxy['streamSettings']['sockopt']['dialerProxy'], 'fragment');
    expect(
      outbounds.any((o) => (o as Map)['tag'] == 'fragment'),
      isTrue,
    );
  });

  test('typical Goodwin VLESS share link ignores fragment toggle', () {
    const link =
        'vless://11111111-2222-3333-4444-555555555555@example.com:443'
        '?encryption=none&type=grpc&security=reality&pbk=PUBLICKEY&sid=abcd'
        '&sni=www.cloudflare.com&fp=chrome&serviceName=goodwin&mode=gun#Node';
    final profile = parser.parse(link) as XrayProfile;
    expect(profile.security, 'reality');
    expect(profile.network, 'grpc');
    expect(profile.flow, isNull);
    final cfg = builder.buildMap(
      profile,
      options: const XrayBuildOptions(mux: true, fragment: true),
    );
    final proxy = (cfg['outbounds'] as List).first as Map<String, dynamic>;
    expect(proxy['mux']['enabled'], isTrue);
    expect(proxy['streamSettings'].containsKey('sockopt'), isFalse);
    expect(
      (cfg['outbounds'] as List).any((o) => (o as Map)['tag'] == 'fragment'),
      isFalse,
    );
  });

  test('mux is omitted with xtls-rprx-vision-udp443', () {
    final profile = XrayProfile(
      name: 'vision-udp',
      protocol: XrayProtocol.vless,
      address: 'example.com',
      port: 443,
      id: '11111111-2222-3333-4444-555555555555',
      flow: 'xtls-rprx-vision-udp443',
      network: 'tcp',
      security: 'tls',
      sni: 'example.com',
    );
    final cfg = builder.buildMap(
      profile,
      options: const XrayBuildOptions(mux: true, fragment: true),
    );
    final proxy = (cfg['outbounds'] as List).first as Map<String, dynamic>;
    expect(proxy.containsKey('mux'), isFalse);
    expect(proxy['streamSettings']['sockopt']['dialerProxy'], 'fragment');
  });

  test('mux is omitted with xtls-rprx-vision', () {
    final profile = XrayProfile(
      name: 'vision',
      protocol: XrayProtocol.vless,
      address: 'example.com',
      port: 443,
      id: '11111111-2222-3333-4444-555555555555',
      flow: 'xtls-rprx-vision',
      network: 'tcp',
      security: 'reality',
      sni: 'www.cloudflare.com',
      publicKey: 'PUBLICKEY',
      shortId: 'abcd',
    );
    final cfg = builder.buildMap(
      profile,
      options: const XrayBuildOptions(mux: true, fragment: true),
    );
    final proxy = (cfg['outbounds'] as List).first as Map<String, dynamic>;
    expect(proxy.containsKey('mux'), isFalse);
    expect(proxy['streamSettings'].containsKey('sockopt'), isFalse);
    expect(
      (cfg['outbounds'] as List).any((o) => (o as Map)['tag'] == 'fragment'),
      isFalse,
    );
  });

  test('fragment is omitted on Reality even when toggled', () {
    final cfg = builder.buildMap(
      sampleVless(),
      options: const XrayBuildOptions(mux: true, fragment: true),
    );
    final proxy = (cfg['outbounds'] as List).first as Map<String, dynamic>;
    expect(proxy['mux']['enabled'], isTrue);
    expect(proxy['streamSettings'].containsKey('sockopt'), isFalse);
    expect(
      (cfg['outbounds'] as List).any((o) => (o as Map)['tag'] == 'fragment'),
      isFalse,
    );
  });

  test('invalid defaultOutbound falls back to proxy', () {
    final cfg = builder.buildMap(
      sampleVless(),
      options: const XrayBuildOptions(defaultOutbound: 'block'),
    );
    final rules = cfg['routing']['rules'] as List;
    expect(rules.single['outboundTag'], 'proxy');
  });

  test('vmess ws tls → stream settings', () {
    final profile = XrayProfile(
      name: 'm',
      protocol: XrayProtocol.vmess,
      address: '1.2.3.4',
      port: 443,
      id: 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
      network: 'ws',
      security: 'tls',
      sni: 'cdn.example.com',
      wsPath: '/ray',
      wsHost: 'cdn.example.com',
      vmessSecurity: 'auto',
    );
    final outbound = builder.buildMap(profile)['outbounds'].first as Map<String, dynamic>;
    expect(outbound['protocol'], 'vmess');
    expect(outbound['streamSettings']['wsSettings']['path'], '/ray');
    expect(outbound['settings']['vnext'][0]['users'][0]['security'], 'auto');
  });

  test('trojan → servers password', () {
    final profile = XrayProfile(
      name: 't',
      protocol: XrayProtocol.trojan,
      address: 't.example',
      port: 443,
      id: 'secret',
      security: 'tls',
      sni: 't.example',
    );
    final outbound = builder.buildMap(profile)['outbounds'].first as Map<String, dynamic>;
    expect(outbound['protocol'], 'trojan');
    expect(outbound['settings']['servers'][0]['password'], 'secret');
  });

  test('buildMap rejects shadowsocks protocol', () {
    final profile = XrayProfile(
      name: 'ss',
      protocol: XrayProtocol.shadowsocks,
      address: 'ss.example',
      port: 8388,
      id: 'pw',
      encryption: 'aes-256-gcm',
    );
    expect(() => builder.buildMap(profile), throwsA(isA<FormatException>()));
  });

  test('buildMap rejects unsupported network', () {
    final profile = XrayProfile(
      name: 'x',
      protocol: XrayProtocol.vless,
      address: 'x.example',
      port: 443,
      id: '11111111-2222-3333-4444-555555555555',
      network: 'httpupgrade',
    );
    expect(() => builder.buildMap(profile), throwsA(isA<FormatException>()));
  });
}
