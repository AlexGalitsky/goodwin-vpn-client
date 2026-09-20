import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goodwin_vpn_client/features/routing/data/prefs_vpn_routing_engine.dart';
import 'package:goodwin_vpn_client/features/routing/data/stub_vpn_routing_engine.dart';
import 'package:goodwin_vpn_client/features/routing/domain/models/routing_models.dart';
import 'package:goodwin_vpn_client/features/routing/domain/usecases/routing_use_cases.dart';
import 'package:goodwin_vpn_client/features/routing/presentation/bloc/routing_bloc.dart';

void main() {
  group('RoutingSnapshot codec', () {
    test('round-trips mode, presets, rules', () {
      const original = RoutingSnapshot(
        mode: RoutingMode.rules,
        enabledPresets: {RoutingPresetId.blockAds},
        customRules: [
          RoutingRule(
            id: 'rule_1',
            matcher: '10.0.0.0/8',
            action: RoutingAction.direct,
          ),
        ],
      );
      final restored = RoutingSnapshot.decode(original.encode());
      expect(restored, original);
    });

    test('decode empty / invalid → defaults', () {
      expect(RoutingSnapshot.decode(null).mode, RoutingMode.global);
      expect(RoutingSnapshot.decode('').mode, RoutingMode.global);
      expect(RoutingSnapshot.decode('not-json').mode, RoutingMode.global);
    });
  });

  group('StubVpnRoutingEngine', () {
    test('presets, mode, and rules round-trip', () async {
      final engine = StubVpnRoutingEngine();
      var snap = await engine.setMode(RoutingMode.rules);
      expect(snap.mode, RoutingMode.rules);

      snap = await engine.setPreset(
        id: RoutingPresetId.blockAds,
        enabled: true,
      );
      expect(snap.isPresetEnabled(RoutingPresetId.blockAds), isTrue);

      snap = await engine.addRule(
        matcher: '.ads.example',
        action: RoutingAction.block,
      );
      expect(snap.customRules, hasLength(1));
      expect(snap.customRules.first.matcher, '.ads.example');

      snap = await engine.removeRule(snap.customRules.first.id);
      expect(snap.customRules, isEmpty);

      await engine.reset();
      snap = await engine.load();
      expect(snap.enabledPresets, isEmpty);
      expect(snap.mode, RoutingMode.global);
    });
  });

  group('PrefsVpnRoutingEngine', () {
    test('survives a new engine instance (prefs round-trip)', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final first = PrefsVpnRoutingEngine(prefs);

      await first.setMode(RoutingMode.direct);
      await first.setPreset(id: RoutingPresetId.bypassRegion, enabled: true);
      await first.addRule(
        matcher: '192.168.0.0/16',
        action: RoutingAction.direct,
      );

      final second = PrefsVpnRoutingEngine(prefs);
      final snap = await second.load();
      expect(snap.mode, RoutingMode.direct);
      expect(snap.isPresetEnabled(RoutingPresetId.bypassRegion), isTrue);
      expect(snap.customRules, hasLength(1));
      expect(snap.customRules.first.matcher, '192.168.0.0/16');
    });
  });

  group('RoutingBloc', () {
    RoutingBloc buildBloc(StubVpnRoutingEngine engine) {
      return RoutingBloc(
        loadRouting: LoadRoutingSnapshotUseCase(engine),
        setMode: SetRoutingModeUseCase(engine),
        setPreset: SetRoutingPresetUseCase(engine),
        addRule: AddRoutingRuleUseCase(engine),
        removeRule: RemoveRoutingRuleUseCase(engine),
        resetRouting: ResetRoutingUseCase(engine),
      );
    }

    test('toggle preset updates state', () async {
      final engine = StubVpnRoutingEngine();
      final bloc = buildBloc(engine);
      addTearDown(bloc.close);

      bloc.add(const RoutingLoadRequested());
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<RoutingState>().having((s) => s.loading, 'loading', isFalse),
        ),
      );

      bloc.add(
        const RoutingPresetToggled(
          id: RoutingPresetId.protectBanking,
          enabled: true,
        ),
      );
      await expectLater(
        bloc.stream,
        emits(
          isA<RoutingState>().having(
            (s) => s.snapshot.isPresetEnabled(RoutingPresetId.protectBanking),
            'banking',
            isTrue,
          ),
        ),
      );
    });

    test('mode change updates state', () async {
      final engine = StubVpnRoutingEngine();
      final bloc = buildBloc(engine);
      addTearDown(bloc.close);

      bloc.add(const RoutingLoadRequested());
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<RoutingState>().having((s) => s.loading, 'loading', isFalse),
        ),
      );

      bloc.add(const RoutingModeChanged(RoutingMode.rules));
      await expectLater(
        bloc.stream,
        emits(
          isA<RoutingState>().having(
            (s) => s.snapshot.mode,
            'mode',
            RoutingMode.rules,
          ),
        ),
      );
    });
  });
}
