import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/home/presentation/home_connect_link.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';

void main() {
  const alpha = SavedProfile(id: 'a', name: 'Alpha', link: 'vless://a');
  const beta = SavedProfile(id: 'b', name: 'Beta', link: 'hy2://b');

  test('prefers selected saved profile', () {
    expect(
      resolveHomeConnectLink(
        savedProfiles: const [alpha, beta],
        selectedProfileId: 'b',
        activeShareLink: 'vless://a',
      ),
      'hy2://b',
    );
  });

  test('falls back to last share link', () {
    expect(
      resolveHomeConnectLink(
        savedProfiles: const [alpha, beta],
        selectedProfileId: 'missing',
        activeShareLink: 'vless://a',
      ),
      'vless://a',
    );
  });

  test('falls back to first saved profile', () {
    expect(
      resolveHomeConnectLink(
        savedProfiles: const [alpha, beta],
        selectedProfileId: null,
        activeShareLink: null,
      ),
      'vless://a',
    );
  });

  test('empty catalog with no last link', () {
    expect(
      resolveHomeConnectLink(
        savedProfiles: const [],
        selectedProfileId: null,
        activeShareLink: '  ',
      ),
      isNull,
    );
  });
}
