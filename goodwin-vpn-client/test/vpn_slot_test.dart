import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/tunnel_elevation.dart';
import 'package:goodwin_vpn_client/vpn/vpn_slot.dart';

import 'support/fakes.dart';

void main() {
  test('release waits for TrustTunnel disconnected before stopping hev', () async {
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    await owned.start(sampleTrustTunnel());
    slot.mark(VpnSlotOwner.trustTunnel);

    var released = false;
    final future = slot.release().then((_) => released = true);
    await Future<void>.delayed(Duration.zero);
    expect(released, isFalse);
    expect(owned.stopCalls, 1);
    expect(tunnel.stopCalls, 0, reason: 'hev must not stop until TT disconnected');

    owned.emitDisconnected();
    await future;
    expect(released, isTrue);
    expect(tunnel.stopCalls, 1);
    expect(slot.owner, VpnSlotOwner.none);
  });

  test('release stops system tunnel when TrustTunnel was already idle', () async {
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    await slot.release();
    expect(owned.stopCalls, 1);
    expect(tunnel.stopCalls, 1);
  });

  test('release does not clear owner when system tunnel stop fails', () async {
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    slot.mark(VpnSlotOwner.socksTun);
    tunnel.stopError = const OnDemandDisarmFailed();

    await expectLater(slot.release(), throwsA(isA<OnDemandDisarmFailed>()));
    expect(slot.owner, VpnSlotOwner.socksTun);
  });
}
