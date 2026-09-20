import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/connection/domain/ping_sample.dart';
import 'package:goodwin_vpn_client/features/connection/domain/smart_connect.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';

void main() {
  const slow = SavedProfile(
    id: 'slow',
    name: 'Slow',
    link: 'vless://slow',
    subscriptionId: 's1',
  );
  const fast = SavedProfile(
    id: 'fast',
    name: 'Fast',
    link: 'vless://fast',
    subscriptionId: 's1',
  );
  const other = SavedProfile(
    id: 'other',
    name: 'Other',
    link: 'vless://other',
    subscriptionId: 's2',
  );
  const manual = SavedProfile(id: 'm1', name: 'Solo', link: 'vless://solo');

  test('picks the lowest ping in the selected subscription', () {
    final picked = resolveSmartConnectProfile(
      savedProfiles: const [slow, fast, other, manual],
      selectedProfileId: 'slow',
      activeShareLink: 'vless://slow',
      pingById: {
        'slow': const PingSample.ok(180),
        'fast': const PingSample.ok(40),
        'other': const PingSample.ok(10),
      },
    );
    expect(picked?.id, 'fast');
  });

  test('does not jump to another subscription or a standalone link', () {
    expect(
      resolveSmartConnectProfile(
        savedProfiles: const [slow, fast, other, manual],
        selectedProfileId: 'm1',
        activeShareLink: 'vless://solo',
        pingById: {
          'fast': const PingSample.ok(40),
          'other': const PingSample.ok(10),
        },
      ),
      isNull,
    );
  });

  test('returns null when the subscription has a single node', () {
    expect(
      resolveSmartConnectProfile(
        savedProfiles: const [other, manual],
        selectedProfileId: 'other',
        activeShareLink: other.link,
        pingById: {'other': const PingSample.ok(10)},
      ),
      isNull,
    );
  });

  test('anchor falls back to the last share link', () {
    final anchor = anchorProfileForConnect(
      savedProfiles: const [slow, fast],
      selectedProfileId: 'missing',
      activeShareLink: 'vless://fast',
    );
    expect(anchor?.id, 'fast');
  });
}
