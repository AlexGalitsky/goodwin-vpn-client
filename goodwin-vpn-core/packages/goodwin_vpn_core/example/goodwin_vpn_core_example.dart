import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

void main() {
  const parser = ShareLinkParser();
  const builder = XrayConfigBuilder(socksUser: 'gw', socksPass: 'test');

  const sample =
      'vless://11111111-2222-3333-4444-555555555555@example.com:443'
      '?encryption=none&security=tls&type=tcp&sni=example.com#demo';

  final profile = parser.parse(sample) as XrayProfile;
  print(parser.describe(profile));
  print(builder.buildJson(profile));
}
