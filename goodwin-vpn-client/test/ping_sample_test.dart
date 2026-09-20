import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/connection/domain/ping_sample.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';

void main() {
  const slow = SavedProfile(id: 'slow', name: 'Slow', link: 'vless://slow');
  const fast = SavedProfile(id: 'fast', name: 'Fast', link: 'vless://fast');
  const dead = SavedProfile(id: 'dead', name: 'Dead', link: 'vless://dead');
  const fresh = SavedProfile(id: 'new', name: 'New', link: 'vless://new');

  test('sorts reachable by latency, then failed, then unpinged', () {
    final sorted = sortProfilesByPing(
      const [slow, fresh, dead, fast],
      {
        'slow': const PingSample.ok(180),
        'fast': const PingSample.ok(40),
        'dead': const PingSample.fail(),
      },
    );
    expect(sorted.map((p) => p.id), ['fast', 'slow', 'dead', 'new']);
  });

  test('pingLabel hides failures', () {
    expect(pingLabel(null), '—');
    expect(pingLabel(const PingSample.fail()), '—');
    expect(pingLabel(const PingSample.ok(42)), '42ms');
  });

  test('pickLowestPingProfile skips failures and missing samples', () {
    expect(
      pickLowestPingProfile(
        const [slow, fresh, dead, fast],
        {
          'slow': const PingSample.ok(180),
          'fast': const PingSample.ok(40),
          'dead': const PingSample.fail(),
        },
      )?.id,
      'fast',
    );
    expect(
      pickLowestPingProfile(const [slow, dead], {
        'slow': const PingSample.fail(),
        'dead': const PingSample.fail(),
      }),
      isNull,
    );
  });

  test('formatUptime', () {
    expect(formatUptime(const Duration(seconds: 5)), '00:05');
    expect(formatUptime(const Duration(minutes: 3, seconds: 7)), '03:07');
    expect(formatUptime(const Duration(hours: 1, minutes: 2)), '1h 02m');
  });
}
