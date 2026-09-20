import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/connection/domain/ping_sample.dart';
import 'package:goodwin_vpn_client/features/servers/presentation/profile_groups.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';

void main() {
  const sub = VpnSubscription(
    id: 's1',
    name: 'Panel',
    url: 'https://panel.example/sub',
  );
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
  const manual = SavedProfile(id: 'm1', name: 'Solo', link: 'vless://solo');

  test('groups manual vs subscription and sorts by ping', () {
    final groups = groupProfiles(
      profiles: const [slow, manual, fast],
      subscriptions: const [sub],
      pingById: {
        'slow': const PingSample.ok(180),
        'fast': const PingSample.ok(40),
      },
    );
    expect(groups, hasLength(2));
    expect(groups.first.isManual, isTrue);
    expect(groups.first.nodes.single.id, 'm1');
    expect(groups.last.subscription?.id, 's1');
    expect(groups.last.nodes.map((p) => p.id), ['fast', 'slow']);
  });

  test('filters by query across groups', () {
    final groups = groupProfiles(
      profiles: const [slow, manual, fast],
      subscriptions: const [sub],
      query: 'solo',
    );
    expect(groups, hasLength(1));
    expect(groups.single.nodes.single.id, 'm1');
  });
}
