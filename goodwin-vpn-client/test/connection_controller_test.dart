import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import 'package:goodwin_vpn_client/session/connection_controller.dart';
import 'package:goodwin_vpn_client/session/session_store.dart';
import 'package:goodwin_vpn_client/session/tunnel_elevation.dart';
import 'package:goodwin_vpn_client/session/vpn_connection_state.dart';
import 'package:goodwin_vpn_client/vpn/vpn_slot.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'support/fakes.dart';

void main() {
  late FakeSystemTunnel tunnel;
  late FakeOwnedVpnEngine owned;
  late FakeSocksEngine core;
  late FakeSocksCoreResolver cores;
  late VpnSlot slot;
  late ConnectionController controller;
  late VpnConnectionState last;
  late StreamSubscription<dynamic> eventsSub;
  late MemorySessionStore store;

  setUp(() {
    tunnel = FakeSystemTunnel();
    owned = FakeOwnedVpnEngine();
    core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
    cores = FakeSocksCoreResolver(core);
    slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    last = const VpnConnectionState(phase: ConnectionPhase.idle);
    store = MemorySessionStore();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      parseShareLink: (raw) => switch (raw) {
        'hy2' => sampleHysteria(),
        'tt' => sampleTrustTunnel(),
        _ => sampleXray(),
      },
      killSwitchEnabled: () => true,
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);
  });

  tearDown(() async {
    await eventsSub.cancel();
    controller.dispose();
  });

  test('connect Xray → disconnect → connect Hysteria uses the same SOCKS path', () async {
    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);
    expect(cores.profiles.single, isA<XrayProfile>());
    // start + reconnect after TUN routes (anti-loop).
    expect(core.startCalls, 2);
    expect(tunnel.prepareCalls, 1);
    expect(tunnel.startCalls, 1);
    expect(owned.startCalls, 0);
    expect(slot.owner, VpnSlotOwner.socksTun);

    await controller.disconnect();
    expect(last.phase, ConnectionPhase.idle);
    expect(core.stopCalls, greaterThan(0));

    await controller.connect('hy2');
    expect(cores.profiles.last, isA<HysteriaProfile>());
    expect(core.startCalls, 4);
    expect(tunnel.startCalls, 2);
    expect(last.phase, ConnectionPhase.connected);
  });

  test('TT → disconnect → Xray waits for disconnected before hev starts', () async {
    await controller.connect('tt');
    expect(last.phase, ConnectionPhase.connected);
    expect(owned.startCalls, 1);
    expect(tunnel.startCalls, 0);
    expect(slot.owner, VpnSlotOwner.trustTunnel);

    final disconnecting = controller.disconnect();
    await Future<void>.delayed(Duration.zero);
    expect(last.phase, ConnectionPhase.disconnecting);
    expect(owned.connected, isTrue, reason: 'TT still holds the VPN slot');
    expect(tunnel.startCalls, 0);
    expect(core.startCalls, 0);

    await controller.connect('vless');
    expect(core.startCalls, 0, reason: 'connect during disconnecting is ignored');
    expect(tunnel.startCalls, 0);

    owned.emitDisconnected();
    await disconnecting;
    expect(last.phase, ConnectionPhase.idle);
    expect(slot.owner, VpnSlotOwner.none);

    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);
    expect(cores.profiles.last, isA<XrayProfile>());
    expect(core.startCalls, 2);
    expect(tunnel.startCalls, 1);
    expect(slot.owner, VpnSlotOwner.socksTun);
  });

  test('TrustTunnel uses OwnedVpnEngine, not hev TUN', () async {
    await controller.connect('tt');
    expect(owned.startCalls, 1);
    expect(owned.lastProfile, isA<TrustTunnelProfile>());
    expect(owned.lastKillSwitch, isTrue);
    expect(tunnel.startCalls, 0);
    expect(core.startCalls, 0);
    expect(last.message, contains('TrustTunnel'));
  });

  test('connect while connecting is ignored', () async {
    tunnel.blockStart = Completer<void>();
    final first = controller.connect('vless');
    await Future<void>.delayed(Duration.zero);
    expect(last.phase, ConnectionPhase.connecting);

    await controller.connect('hy2');
    expect(cores.profiles, hasLength(1));

    tunnel.blockStart!.complete();
    await first;
    expect(last.phase, ConnectionPhase.connected);
    expect(core.startCalls, 2);
  });

  test('tunnel failed stops engine and goes to error', () async {
    tunnel.startError = StateError('establish failed');
    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.error);
    expect(core.startCalls, 1);
    expect(core.stopCalls, greaterThan(0));
    expect(core.running, isFalse);
    expect(last.message, contains('establish failed'));
  });

  test('revoked mid-session stops engine and is not connected', () async {
    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);

    tunnel.revoke();
    await Future<void>.delayed(Duration.zero);
    expect(last.phase, ConnectionPhase.error);
    expect(core.stopCalls, greaterThan(0));
    expect(core.running, isFalse);
    expect(slot.owner, VpnSlotOwner.none);
  });

  test('unexpected stopped mid-session (FGS kill) leaves UI not connected', () async {
    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);

    tunnel.emitStopped(message: 'VpnService.onDestroy');
    await Future<void>.delayed(Duration.zero);
    expect(last.phase, ConnectionPhase.error);
    expect(last.message, contains('onDestroy'));
    expect(core.running, isFalse);
    expect(slot.owner, VpnSlotOwner.none);
  });

  test('stopped during intentional disconnect does not flip to error', () async {
    await controller.connect('vless');
    tunnel.blockStop = Completer<void>();
    final disconnecting = controller.disconnect();
    await Future<void>.delayed(Duration.zero);
    expect(last.phase, ConnectionPhase.disconnecting);

    tunnel.emitStopped(message: 'early stopped event');
    await Future<void>.delayed(Duration.zero);
    expect(last.phase, ConnectionPhase.disconnecting);

    tunnel.blockStop!.complete();
    await disconnecting;
    expect(last.phase, ConnectionPhase.idle);
  });

  test('restore: TrustTunnel still connected → UI connected, no start', () async {
    owned.connected = true;
    await store.saveLastShareLink('tt');

    await controller.restoreFromOs();

    expect(last.phase, ConnectionPhase.connected);
    expect(owned.startCalls, 0);
    expect(tunnel.startCalls, 0);
    expect(slot.owner, VpnSlotOwner.trustTunnel);
    expect(last.message, contains('TrustTunnel'));

    final disconnecting = controller.disconnect();
    await Future<void>.delayed(Duration.zero);
    expect(last.phase, ConnectionPhase.disconnecting);
    owned.emitDisconnected();
    await disconnecting;
    expect(last.phase, ConnectionPhase.idle);
    expect(owned.stopCalls, 1);
  });

  test('restore: TUN up without SOCKS but last link → reconnect core', () async {
    tunnel.established = true;
    await store.saveLastShareLink('vless');
    core.nativeRunning = false;

    await controller.restoreFromOs();

    expect(last.phase, ConnectionPhase.connected);
    expect(core.startCalls, greaterThan(0));
    expect(tunnel.startCalls, 1);
    expect(slot.owner, VpnSlotOwner.socksTun);
  });

  test('restore: orphan TUN without last link → stop tunnel, stay idle', () async {
    tunnel.established = true;
    core.nativeRunning = false;

    await controller.restoreFromOs();

    expect(last.phase, ConnectionPhase.idle);
    expect(tunnel.stopCalls, 1);
    expect(core.startCalls, 0);
    expect(core.adoptCalls, 0);
    expect(tunnel.established, isFalse);
  });

  test('restore: hev TUN + native SOCKS → attach, no start', () async {
    tunnel.established = true;
    core.nativeRunning = true;
    await store.saveLastShareLink('vless');

    await controller.restoreFromOs();

    expect(last.phase, ConnectionPhase.connected);
    expect(core.startCalls, 0);
    expect(core.adoptCalls, 1);
    expect(core.running, isTrue);
    expect(tunnel.startCalls, 0);
    expect(slot.owner, VpnSlotOwner.socksTun);
  });

  test('restore: autoConnect + last link, OS idle → connect', () async {
    store.autoConnectValue = true;
    await store.saveLastShareLink('vless');

    await controller.restoreFromOs();

    expect(last.phase, ConnectionPhase.connected);
    expect(last.autoConnect, isTrue);
    expect(core.startCalls, 2);
    expect(tunnel.startCalls, 1);
  });

  test('restore: autoConnect off → idle even with last link', () async {
    store.autoConnectValue = false;
    await store.saveLastShareLink('vless');

    await controller.restoreFromOs();

    expect(last.phase, ConnectionPhase.idle);
    expect(core.startCalls, 0);
    expect(tunnel.startCalls, 0);
  });

  test('successful connect persists last share link and saved list', () async {
    await controller.connect('hy2');
    expect(await store.lastShareLink(), 'hy2');
    expect(await store.savedShareLinks(), ['hy2']);
    expect(last.connectedAt, isNotNull);

    await controller.disconnect();
    expect(last.connectedAt, isNull);
    await controller.connect('vless');
    expect(await store.savedShareLinks(), ['vless', 'hy2']);
    expect(last.connectedAt, isNotNull);
  });

  test('saveShareLinkToList dedupes and remove works', () async {
    await controller.saveShareLinkToList('vless://a');
    await controller.saveShareLinkToList('hy2://b');
    await controller.saveShareLinkToList('vless://a');
    expect(last.savedLinks, ['vless://a', 'hy2://b']);

    await controller.removeSavedShareLink('hy2://b');
    expect(last.savedLinks, ['vless://a']);
  });

  test('rename and update saved profile', () async {
    await controller.saveShareLinkToList('vless://a', name: 'Alpha');
    final id = last.savedProfiles.single.id;
    await controller.renameSavedProfile(id, 'Beta');
    expect(last.savedProfiles.single.name, 'Beta');
    await controller.updateSavedProfile(id: id, link: 'vless://b');
    expect(last.savedProfiles.single.link, 'vless://b');
    expect(last.savedProfiles.single.name, 'Beta');
  });

  test('exclude routes persist in state', () async {
    await controller.setExcludeRoutes(['1.2.3.4', '10.0.0.0/8', '1.2.3.4']);
    expect(last.excludeRoutes, ['1.2.3.4', '10.0.0.0/8']);
  });

  test('disallowed packages persist in state', () async {
    await controller.setDisallowedPackages(['ru.sberbankmobile', ' ru.sberbankmobile ']);
    expect(last.disallowedPackages, ['ru.sberbankmobile']);
  });

  test('smartConnect persists in store and state', () async {
    await controller.setSmartConnect(true);
    expect(last.smartConnect, isTrue);
    expect(await store.smartConnect(), isTrue);
  });

  test('restore hydrates smartConnect from store', () async {
    store.smartConnectValue = true;
    await controller.restoreFromOs();
    expect(last.smartConnect, isTrue);
  });

  test('selectShareLink remembers next connect without starting', () async {
    await controller.selectShareLink('vless://pending');
    expect(await store.lastShareLink(), 'vless://pending');
    expect(last.activeShareLink, 'vless://pending');
    expect(last.phase, ConnectionPhase.idle);
    expect(tunnel.startCalls, 0);
  });

  test('Xray → Hysteria triggers process restart and pending connect', () async {
    final restarter = RecordingProcessRestarter();
    cores = FakeSocksCoreResolver(core, enforceGoSwitch: true);
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      restarter: restarter,
      parseShareLink: (raw) => switch (raw) {
        'hy2' => sampleHysteria(),
        'tt' => sampleTrustTunnel(),
        _ => sampleXray(),
      },
      onState: (s) => last = s,
    );
    await eventsSub.cancel();
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);
    await controller.disconnect();
    expect(last.phase, ConnectionPhase.idle);

    await controller.connect('hy2');
    expect(restarter.calls, 1);
    expect(await store.pendingConnect(), isTrue);
    expect(await store.lastShareLink(), 'hy2');
    expect(last.phase, ConnectionPhase.idle);
    expect(last.message, contains('Restarting'));
  });

  test('restore: pending connect after Go-core restart connects last link', () async {
    store.pendingConnectValue = true;
    await store.saveLastShareLink('hy2');

    await controller.restoreFromOs();

    expect(await store.pendingConnect(), isFalse);
    expect(last.phase, ConnectionPhase.connected);
    expect(cores.profiles.last, isA<HysteriaProfile>());
  });

  test('network change while connected triggers reconnect', () async {
    final connectivity = FakeConnectivityMonitor();
    controller.dispose();
    await eventsSub.cancel();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      connectivity: connectivity,
      networkDebounce: Duration.zero,
      parseShareLink: (raw) => switch (raw) {
        'hy2' => sampleHysteria(),
        'tt' => sampleTrustTunnel(),
        _ => sampleXray(),
      },
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);
    expect(core.startCalls, 2);

    connectivity.emit([ConnectivityResult.mobile]);
    controller.handleConnectivityChange([ConnectivityResult.mobile]);
    // Post-TUN reconnect uses a 150ms delay.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(last.phase, ConnectionPhase.connected);
    expect(core.startCalls, 4);
    expect(last.logs.any((l) => l.contains('network')), isTrue);
    connectivity.close();
  });

  test('VPN other/vpn noise does not reconnect', () async {
    final connectivity = FakeConnectivityMonitor();
    controller.dispose();
    await eventsSub.cancel();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      connectivity: connectivity,
      networkDebounce: Duration.zero,
      parseShareLink: (raw) => sampleXray(),
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    await controller.connect('vless');
    expect(core.startCalls, 2);

    // iOS/macOS: NE up often reports wifi+other (or other alone).
    controller.handleConnectivityChange([
      ConnectivityResult.wifi,
      ConnectivityResult.other,
    ]);
    controller.handleConnectivityChange([ConnectivityResult.other]);
    controller.handleConnectivityChange([
      ConnectivityResult.wifi,
      ConnectivityResult.vpn,
    ]);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(core.startCalls, 2);
    expect(last.phase, ConnectionPhase.connected);
    expect(last.logs.any((l) => l.contains('network changed')), isFalse);
    connectivity.close();
  });

  test('none while connected does not reconnect', () async {
    final connectivity = FakeConnectivityMonitor();
    controller.dispose();
    await eventsSub.cancel();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      connectivity: connectivity,
      networkDebounce: Duration.zero,
      parseShareLink: (raw) => sampleXray(),
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    await controller.connect('vless');
    expect(core.startCalls, 2);

    controller.handleConnectivityChange([ConnectivityResult.wifi]);
    controller.handleConnectivityChange([ConnectivityResult.none]);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(core.startCalls, 2);
    expect(tunnel.startCalls, 1);
    expect(last.phase, ConnectionPhase.connected);
    expect(last.logs.any((l) => l.contains('ignore none')), isTrue);
    connectivity.close();
  });

  test('network change while idle does not reconnect', () async {
    final connectivity = FakeConnectivityMonitor();
    controller.dispose();
    await eventsSub.cancel();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      connectivity: connectivity,
      networkDebounce: Duration.zero,
      parseShareLink: (raw) => sampleXray(),
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    controller.handleConnectivityChange([ConnectivityResult.mobile]);
    await Future<void>.delayed(Duration.zero);
    expect(core.startCalls, 0);
    expect(last.phase, ConnectionPhase.idle);
    connectivity.close();
  });

  test('Windows prepare denied sets elevationRequired', () async {
    tunnel = FakeSystemTunnel(needsElevationOnPrepare: true);
    tunnel.prepareResult = false;
    slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    controller.dispose();
    await eventsSub.cancel();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      parseShareLink: (raw) => sampleXray(),
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.error);
    expect(last.elevationRequired, isTrue);
    expect(core.startCalls, 0);
    expect(tunnel.startCalls, 0);
  });

  test('SOCKS connect uses password auth', () async {
    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);
    expect(tunnel.lastSocksUsername, 'gw');
    expect(tunnel.lastSocksPassword, 'test');
    expect(cores.lastConfigJson, contains('"auth":"password"'));
    expect(cores.lastConfigJson, isNot(contains('noauth')));
  });

  test('TrustTunnel OS drop → error, not connected', () async {
    await controller.connect('tt');
    expect(last.phase, ConnectionPhase.connected);
    owned.dropFromOs();
    controller.handleOwnedDrop();
    await Future<void>.delayed(Duration.zero);
    expect(last.phase, ConnectionPhase.error);
    expect(last.message, contains('TrustTunnel'));
  });

  test('restore: extension-hosted TUN adopts without native core', () async {
    await eventsSub.cancel();
    controller.dispose();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      parseShareLink: (_) => sampleXray(),
      extensionHostedCore: () => true,
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);
    tunnel.established = true;
    core.nativeRunning = false;
    await store.saveLastShareLink('vless');

    await controller.restoreFromOs().timeout(const Duration(seconds: 5));

    expect(last.phase, ConnectionPhase.connected);
    expect(core.adoptCalls, 1);
    expect(core.startCalls, 0);
    expect(tunnel.startCalls, 0);
  });

  test('unresolved VPS fails connect instead of Connected', () async {
    controller.dispose();
    await eventsSub.cancel();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      parseShareLink: (_) => const XrayProfile(
        name: 'vless-test',
        protocol: XrayProtocol.vless,
        address: 'no-such-host.invalid',
        port: 443,
        id: 'id',
      ),
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    await controller.connect('vless').timeout(const Duration(seconds: 8));
    expect(last.phase, ConnectionPhase.error);
    expect(last.message, contains('could not resolve'));
    expect(tunnel.startCalls, 0);
  });

  test('revoke during reconnect does not leave connected', () async {
    final connectivity = FakeConnectivityMonitor();
    controller.dispose();
    await eventsSub.cancel();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      connectivity: connectivity,
      networkDebounce: Duration.zero,
      parseShareLink: (_) => sampleXray(),
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);

    tunnel.blockStart = Completer<void>();
    controller.handleConnectivityChange([ConnectivityResult.mobile]);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(last.phase, ConnectionPhase.connecting);

    tunnel.revoke();
    await Future<void>.delayed(Duration.zero);
    tunnel.blockStart!.complete();
    await Future<void>.delayed(const Duration(milliseconds: 250));

    expect(last.phase, ConnectionPhase.error);
    expect(last.phase, isNot(ConnectionPhase.connected));
    expect(slot.owner, VpnSlotOwner.none);
    connectivity.close();
  });

  test('IPv6-only VPS fails when OS cannot exclude v6', () async {
    controller.dispose();
    await eventsSub.cancel();
    tunnel = FakeSystemTunnel(supportsIpv6RouteExclude: false);
    slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      parseShareLink: (_) => const XrayProfile(
        name: 'v6',
        protocol: XrayProtocol.vless,
        address: '2001:db8::1',
        port: 443,
        id: 'id',
      ),
      onState: (s) => last = s,
    );
    eventsSub = tunnel.events.listen(controller.handleTunnelEvent);

    await controller.connect('vless').timeout(const Duration(seconds: 8));
    expect(last.phase, ConnectionPhase.error);
    expect(last.message, contains('IPv6-only'));
    expect(tunnel.startCalls, 0);
  });

  test('iOS on-demand save fail keeps Connected, does not look disconnected',
      () async {
    await controller.connect('vless');
    expect(last.phase, ConnectionPhase.connected);
    expect(slot.owner, VpnSlotOwner.socksTun);
    tunnel.stopError = const OnDemandDisarmFailed();

    await controller.disconnect();

    expect(last.phase, ConnectionPhase.connected);
    expect(last.message, contains(OnDemandDisarmFailed.marker));
    expect(slot.owner, VpnSlotOwner.socksTun);
    expect(tunnel.established, isTrue);
  });
}
