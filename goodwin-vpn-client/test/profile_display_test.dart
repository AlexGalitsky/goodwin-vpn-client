import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/servers/presentation/profile_display.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';

void main() {
  const vless =
      'vless://11111111-2222-3333-4444-555555555555@example.com:443'
      '?encryption=none&type=tcp&security=tls#Titan';
  const hy2 = 'hysteria2://secret@hy.example.com:443?insecure=1#HyNode';

  test('protocol kind is a short chip label', () {
    expect(protocolKindForLink(vless), 'vless');
    expect(protocolKindForLink(hy2), 'hy2');
  });

  test('display name does not bake protocol into the title', () {
    expect(
      profileDisplayName(const SavedProfile(id: '1', name: 'Titan', link: vless)),
      'Titan',
    );
    expect(shareLinkShortLabel(vless), 'Titan');
    expect(shareLinkShortLabel(vless), isNot(contains('vless')));
    expect(shareLinkShortLabel(hy2), isNot(contains('hy2')));
  });
}
