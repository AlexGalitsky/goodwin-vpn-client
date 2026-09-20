import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/connection/domain/node_endpoint.dart';
import 'package:goodwin_vpn_client/features/connection/domain/tcp_latency_probe.dart';
import 'package:goodwin_vpn_client/features/connection/presentation/bloc/connection_selection_cubit.dart';
import 'package:goodwin_vpn_client/features/servers/presentation/profile_display.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';

class FakeLatencyProbe implements LatencyProbe {
  FakeLatencyProbe(this.results);

  final Map<String, int?> results;

  @override
  Future<int?> measure(
    NodeEndpoint endpoint, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    return results['${endpoint.host}:${endpoint.port}'];
  }
}

void main() {
  const fastLink =
      'vless://11111111-2222-3333-4444-555555555555@fast.example:443';
  const slowLink =
      'vless://11111111-2222-3333-4444-555555555555@slow.example:8443';

  group('ConnectionSelectionCubit', () {
    test('select and clear', () {
      final cubit = ConnectionSelectionCubit(probe: FakeLatencyProbe({}));
      addTearDown(cubit.close);

      cubit.selectProfile('p1');
      expect(cubit.state.selectedProfileId, 'p1');
      cubit.clearSelection();
      expect(cubit.state.selectedProfileId, isNull);
    });

    test('selectMatchingLink hydrates from last share link', () {
      final cubit = ConnectionSelectionCubit(probe: FakeLatencyProbe({}));
      addTearDown(cubit.close);
      cubit.selectMatchingLink(
        const [
          SavedProfile(id: 'a', name: 'A', link: 'vless://a'),
          SavedProfile(id: 'b', name: 'B', link: 'hy2://b'),
        ],
        'hy2://b',
      );
      expect(cubit.state.selectedProfileId, 'b');
    });

    test('pingProfiles records live RTT and failures', () async {
      final cubit = ConnectionSelectionCubit(
        probe: FakeLatencyProbe({
          'fast.example:443': 32,
          'slow.example:8443': null,
        }),
      );
      addTearDown(cubit.close);

      const fast = SavedProfile(id: 'fast', name: 'Fast', link: fastLink);
      const slow = SavedProfile(id: 'slow', name: 'Slow', link: slowLink);
      await cubit.pingProfiles([slow, fast]);

      expect(cubit.state.pinging, isFalse);
      expect(cubit.state.pingByProfileId['fast']?.milliseconds, 32);
      expect(cubit.state.pingByProfileId['slow']?.failed, isTrue);
    });
  });

  group('profileDisplayName', () {
    test('prefers custom name', () {
      const profile = SavedProfile(
        id: '1',
        name: 'Frankfurt',
        link: 'vless://example',
      );
      expect(profileDisplayName(profile), 'Frankfurt');
    });
  });
}
