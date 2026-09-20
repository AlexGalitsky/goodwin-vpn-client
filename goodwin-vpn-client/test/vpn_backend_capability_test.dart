import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import 'package:goodwin_vpn_client/features/routing/domain/vpn_backend_capability.dart';

void main() {
  group('vpnBackendKindForLink', () {
    test('classifies share links', () {
      expect(
        vpnBackendKindForLink(
          'vless://11111111-2222-3333-4444-555555555555@ex.com:443'
          '?encryption=none&type=tcp&security=none',
        ),
        VpnBackendKind.xray,
      );
      expect(
        vpnBackendKindForLink('hy2://secret@ex.com:443'),
        VpnBackendKind.hysteria,
      );
      expect(vpnBackendKindForLink(null), VpnBackendKind.unknown);
      expect(vpnBackendKindForLink(''), VpnBackendKind.unknown);
    });
  });

  group('vpnBackendKindForProfile', () {
    test('maps profile types', () {
      expect(
        vpnBackendKindForProfile(
          const XrayProfile(
            name: 'x',
            protocol: XrayProtocol.vless,
            address: 'a',
            port: 1,
            id: 'id',
          ),
        ),
        VpnBackendKind.xray,
      );
      expect(
        vpnBackendKindForProfile(
          const HysteriaProfile(
            name: 'h',
            address: 'a',
            port: 1,
            password: 'p',
          ),
        ),
        VpnBackendKind.hysteria,
      );
      expect(
        vpnBackendKindForProfile(
          const TrustTunnelProfile(name: 't', endpoint: 'e'),
        ),
        VpnBackendKind.trustTunnel,
      );
    });
  });

  test('capability banners mention limits for non-xray', () {
    expect(
      routingCapabilityBanner(VpnBackendKind.hysteria),
      contains('not applied'),
    );
    expect(
      routingCapabilityBanner(VpnBackendKind.trustTunnel),
      contains('Per-app split'),
    );
    expect(
      VpnBackendKind.hysteria.supportsRichRouting,
      isFalse,
    );
    expect(VpnBackendKind.xray.supportsRichRouting, isTrue);
  });
}
