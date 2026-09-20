import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/routing/domain/models/routing_models.dart';
import 'package:goodwin_vpn_client/features/routing/domain/vpn_backend_capability.dart';
import 'package:goodwin_vpn_client/features/routing/domain/vpn_ui_features.dart';
import 'package:goodwin_vpn_client/features/split/domain/split_apps.dart';

void main() {
  group('VpnUiFeatures', () {
    test('Android SOCKS TUN shows per-app and Kill Switch', () {
      final features = VpnUiFeatures.resolve(
        isAndroid: true,
        tunnelSupported: true,
        backend: VpnBackendKind.xray,
        androidSdkInt: 33,
      );
      expect(features.perAppSplit, isTrue);
      expect(features.killSwitch, isTrue);
      expect(features.excludeCidr, isTrue);
      expect(features.geosite, isFalse);
      expect(features.richRouting, isTrue);
      expect(features.xrayCoreTuning, isTrue);
      expect(features.qrCamera, isTrue);
    });

    test('hides per-app for TrustTunnel; KS stays on Android TT', () {
      expect(
        VpnUiFeatures.resolve(
          isAndroid: false,
          tunnelSupported: true,
          backend: VpnBackendKind.xray,
        ).perAppSplit,
        isFalse,
      );
      expect(
        VpnUiFeatures.resolve(
          isAndroid: false,
          tunnelSupported: true,
          backend: VpnBackendKind.xray,
        ).killSwitch,
        isFalse,
      );
      final tt = VpnUiFeatures.resolve(
        isAndroid: true,
        tunnelSupported: true,
        backend: VpnBackendKind.trustTunnel,
        androidSdkInt: 33,
      );
      expect(tt.perAppSplit, isFalse);
      expect(tt.killSwitch, isTrue);
      expect(tt.rulesRouting, isTrue);
      expect(tt.directRouting, isFalse);
      expect(tt.blockRouting, isFalse);
      expect(tt.richRouting, isFalse);
      expect(tt.xrayCoreTuning, isFalse);
      expect(tt.excludeCidr, isTrue);
      expect(tt.qrCamera, isTrue);
      expect(tt.displayMode(RoutingMode.direct), RoutingMode.global);
      expect(tt.displayMode(RoutingMode.rules), RoutingMode.rules);
      expect(tt.allowedActions, isNot(contains(RoutingAction.block)));
      expect(
        tt.allowedActions,
        containsAll([RoutingAction.proxy, RoutingAction.direct]),
      );
    });

    test('Android below 13 hides working Bypass LAN and explains why', () {
      final features = VpnUiFeatures.resolve(
        isAndroid: true,
        tunnelSupported: true,
        backend: VpnBackendKind.xray,
        androidSdkInt: 32,
      );
      expect(features.excludeCidr, isFalse);
      expect(features.excludeCidrUnavailableHint, contains('Android 13'));
    });

    test('Linux without TUN hides split and CIDR, keeps Xray controls', () {
      final features = VpnUiFeatures.resolve(
        isAndroid: false,
        tunnelSupported: false,
      );
      expect(features.perAppSplit, isFalse);
      expect(features.killSwitch, isFalse);
      expect(features.excludeCidr, isFalse);
      expect(features.geosite, isFalse);
      expect(features.richRouting, isTrue);
      expect(features.xrayCoreTuning, isTrue);
      expect(features.qrCamera, isFalse);
    });

    test(
      'Hysteria2 hides Rules/Direct/block; stored Rules display as Global',
      () {
        final features = VpnUiFeatures.resolve(
          isAndroid: true,
          tunnelSupported: true,
          backend: VpnBackendKind.hysteria,
          androidSdkInt: 33,
        );
        expect(features.rulesRouting, isFalse);
        expect(features.directRouting, isFalse);
        expect(features.blockRouting, isFalse);
        expect(features.richRouting, isFalse);
        expect(features.displayMode(RoutingMode.rules), RoutingMode.global);
        expect(features.displayMode(RoutingMode.direct), RoutingMode.global);
      },
    );

    test('Xray keeps full routing including Direct and block', () {
      final features = VpnUiFeatures.resolve(
        isAndroid: true,
        tunnelSupported: true,
        backend: VpnBackendKind.xray,
        androidSdkInt: 33,
      );
      expect(features.rulesRouting, isTrue);
      expect(features.directRouting, isTrue);
      expect(features.blockRouting, isTrue);
      expect(features.richRouting, isTrue);
      expect(features.displayMode(RoutingMode.direct), RoutingMode.direct);
      expect(features.allowedActions, contains(RoutingAction.block));
    });

    test('iOS SOCKS shows Kill Switch and hides Android split', () {
      final features = VpnUiFeatures.resolve(
        isAndroid: false,
        isIos: true,
        tunnelSupported: true,
        backend: VpnBackendKind.xray,
      );
      expect(features.qrCamera, isTrue);
      expect(features.perAppSplit, isFalse);
      expect(features.killSwitch, isTrue);
    });

    test('iOS TrustTunnel shows Kill Switch, not Android split', () {
      final features = VpnUiFeatures.resolve(
        isAndroid: false,
        isIos: true,
        tunnelSupported: true,
        backend: VpnBackendKind.trustTunnel,
      );
      expect(features.killSwitch, isTrue);
      expect(features.perAppSplit, isFalse);
      expect(features.rulesRouting, isTrue);
      expect(features.directRouting, isFalse);
      expect(features.blockRouting, isFalse);
    });
  });

  test('mergeDisallowedPackages uniques user picks and banking list', () {
    final merged = mergeDisallowedPackages(
      userSelected: const ['com.example.bank', ' ru.sberbankmobile '],
      protectBanking: true,
    );
    expect(merged.first, 'com.example.bank');
    expect(merged, contains('ru.sberbankmobile'));
    expect(merged.where((p) => p == 'ru.sberbankmobile'), hasLength(1));
    expect(merged, isNot(contains('')));
  });
}
