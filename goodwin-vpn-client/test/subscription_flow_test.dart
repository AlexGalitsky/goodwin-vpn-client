import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import 'package:goodwin_vpn_client/session/backup_codec.dart';
import 'package:goodwin_vpn_client/session/connection_controller.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo_cache.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo_prefetch.dart';
import 'package:goodwin_vpn_client/session/goodwin_service.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';
import 'package:goodwin_vpn_client/session/session_store.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';
import 'package:goodwin_vpn_client/session/subscription_parser.dart';
import 'package:goodwin_vpn_client/session/vpn_connection_state.dart';
import 'package:goodwin_vpn_client/vpn/vpn_slot.dart';

import 'support/fakes.dart';

const _linkA =
    'vless://11111111-2222-3333-4444-555555555555@a.example.com:443'
    '?encryption=none&security=none#NodeA';
const _linkB =
    'vless://11111111-2222-3333-4444-555555555555@b.example.com:443'
    '?encryption=none&security=none#NodeB';
const _linkC =
    'vless://11111111-2222-3333-4444-555555555555@c.example.com:443'
    '?encryption=none&security=none#NodeC';

void main() {
  late FakeSystemTunnel tunnel;
  late FakeOwnedVpnEngine owned;
  late FakeSocksEngine core;
  late FakeSocksCoreResolver cores;
  late VpnSlot slot;
  late ConnectionController controller;
  late VpnConnectionState last;
  late MemorySessionStore store;
  late FakeSubscriptionClient client;
  late FakeGoodwinServiceClient serviceClient;
  late FakeGoodwinGeoClient geoClient;
  late MemoryGeoPackCache geoCache;

  setUp(() {
    tunnel = FakeSystemTunnel();
    owned = FakeOwnedVpnEngine();
    core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
    cores = FakeSocksCoreResolver(core);
    slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    last = const VpnConnectionState(phase: ConnectionPhase.idle);
    store = MemorySessionStore();
    client = FakeSubscriptionClient(
      document: const SubscriptionDocument(
        body: '$_linkA\n$_linkB',
        headers: {
          'profile-title': 'Panel',
          'profile-update-interval': '12',
          'subscription-userinfo':
              'upload=0; download=1048576; total=1073741824; expire=1893456000',
        },
      ),
    );
    serviceClient = FakeGoodwinServiceClient();
    geoClient = FakeGoodwinGeoClient();
    geoCache = MemoryGeoPackCache();
    controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      subscriptionClient: client,
      serviceClient: serviceClient,
      geoPrefetch: GoodwinGeoPrefetcher(client: geoClient, cache: geoCache),
      parseShareLink: (raw) => const ShareLinkParser().parse(raw),
      onState: (s) => last = s,
    );
  });

  tearDown(() => controller.dispose());

  test('importSubscription creates nodes from a fake HTTP body', () async {
    await controller.importSubscription('https://panel.example/sub');
    expect(client.fetchCount, 1);
    expect(last.subscriptions, hasLength(1));
    expect(last.subscriptions.single.name, 'Panel');
    expect(last.subscriptions.single.intervalHours, 12);
    expect(last.savedProfiles, hasLength(2));
    expect(
      last.savedProfiles.every(
        (p) => p.subscriptionId == last.subscriptions.single.id,
      ),
      isTrue,
    );
    expect(last.savedProfiles.map((p) => p.link), [_linkA, _linkB]);
    expect(last.savedProfiles.map((p) => p.name), ['NodeA', 'NodeB']);
    expect(last.subscriptions.single.serviceBase, isNull);
    expect(last.subscriptions.single.isGoodwinService, isFalse);
    expect(serviceClient.fetchCount, 0);
  });

  test(
    'Goodwin-VPN header persists serviceBase; generic refresh clears it',
    () async {
      client.document = SubscriptionDocument(
        body: '$_linkA\n$_linkB',
        headers: {
          ...client.document!.headers,
          'Goodwin-VPN': 'v1; base="https://panel.example"',
        },
      );
      await controller.importSubscription('https://panel.example/sub');
      expect(last.subscriptions.single.serviceBase, 'https://panel.example');
      expect(last.subscriptions.single.protocolVersion, 1);
      expect(last.subscriptions.single.isGoodwinService, isTrue);

      client.document = const SubscriptionDocument(
        body: '$_linkA',
        headers: {'profile-title': 'Panel'},
      );
      await controller.refreshSubscription(last.subscriptions.single.id);
      expect(last.subscriptions.single.serviceBase, isNull);
      expect(last.subscriptions.single.isGoodwinService, isFalse);
    },
  );

  test('Goodwin-VPN with another host is treated as generic', () async {
    client.document = const SubscriptionDocument(
      body: '$_linkA',
      headers: {'Goodwin-VPN': 'v1; base="https://evil.example"'},
    );
    await controller.importSubscription('https://panel.example/sub');
    expect(last.subscriptions.single.serviceBase, isNull);
    expect(serviceClient.fetchCount, 0);
  });

  test(
    'service catalog persists name, privacy, and ignores unknown features',
    () async {
      client.document = const SubscriptionDocument(
        body: '$_linkA',
        headers: {'Goodwin-VPN': 'v1; base="https://panel.example"'},
      );
      serviceClient.catalog = const GoodwinServiceCatalog(
        version: 1,
        name: 'Goodwin VPN',
        privacyUrl: 'https://panel.example/privacy',
        features: ['geo-packs', 'billing-never'],
      );
      await controller.importSubscription('https://panel.example/sub');
      expect(serviceClient.fetchCount, 1);
      expect(serviceClient.fetchedBases, ['https://panel.example']);
      expect(last.subscriptions.single.name, 'Goodwin VPN');
      expect(last.subscriptions.single.serviceName, 'Goodwin VPN');
      expect(
        last.subscriptions.single.privacyUrl,
        'https://panel.example/privacy',
      );
      expect(last.subscriptions.single.features, [
        'geo-packs',
        'billing-never',
      ]);
      expect(last.savedProfiles, hasLength(1));
    },
  );

  test('geo-packs feature prefetches ads into cache', () async {
    const raw =
        '{"id":"ads","domains":[],"suffixes":[".doubleclick.net"],"cidrs":[]}';
    final body = Uint8List.fromList(utf8.encode(raw));
    geoClient.manifest = GeoManifest(
      version: '2026.09.12',
      packs: [
        GeoPackMeta(
          id: 'ads',
          url: 'https://panel.example/gw/v1/geo/packs/ads',
          sha256: sha256Hex(body),
          bytes: body.length,
        ),
      ],
    );
    geoClient.packBytes = body;
    client.document = const SubscriptionDocument(
      body: '$_linkA',
      headers: {'Goodwin-VPN': 'v1; base="https://panel.example"'},
    );
    serviceClient.catalog = const GoodwinServiceCatalog(
      version: 1,
      features: ['geo-packs'],
    );
    await controller.importSubscription('https://panel.example/sub');
    expect(geoClient.manifestCount, 1);
    expect(geoClient.packCount, 1);
    final ads = await geoCache.readAds('https://panel.example');
    expect(ads?.suffixes, contains('.doubleclick.net'));
  });

  test('generic /sub does not fetch geo packs', () async {
    await controller.importSubscription('https://panel.example/sub');
    expect(geoClient.manifestCount, 0);
    expect(await geoCache.readAds('https://panel.example'), isNull);
  });

  test('profile-title wins over the service catalog name', () async {
    client.document = const SubscriptionDocument(
      body: '$_linkA',
      headers: {
        'profile-title': 'Panel',
        'Goodwin-VPN': 'v1; base="https://panel.example"',
      },
    );
    serviceClient.catalog = const GoodwinServiceCatalog(
      version: 1,
      name: 'Goodwin VPN',
    );
    await controller.importSubscription('https://panel.example/sub');
    expect(last.subscriptions.single.name, 'Panel');
    expect(last.subscriptions.single.serviceName, 'Goodwin VPN');
  });

  test('catalog fetch failure still imports nodes', () async {
    client.document = SubscriptionDocument(
      body: '$_linkA',
      headers: {
        ...client.document!.headers,
        'Goodwin-VPN': 'v1; base="https://panel.example"',
      },
    );
    serviceClient.error = Exception('down');
    await controller.importSubscription('https://panel.example/sub');
    expect(last.subscriptions.single.serviceBase, 'https://panel.example');
    expect(last.subscriptions.single.privacyUrl, isNull);
    expect(last.savedProfiles, hasLength(1));
  });

  test('refresh keeps node ids when the same link returns', () async {
    await controller.importSubscription('https://panel.example/sub');
    final subId = last.subscriptions.single.id;
    final keptId = last.savedProfiles.firstWhere((p) => p.link == _linkB).id;
    client.document = const SubscriptionDocument(body: '$_linkB\n$_linkC');

    await controller.refreshSubscription(subId);
    expect(client.fetchCount, 2);
    expect(last.savedProfiles.map((p) => p.link), [_linkB, _linkC]);
    expect(last.savedProfiles.firstWhere((p) => p.link == _linkB).id, keptId);
    expect(last.savedProfiles.every((p) => p.subscriptionId == subId), isTrue);
  });

  test('refresh of an empty body drops subscription nodes', () async {
    await controller.importSubscription('https://panel.example/sub');
    final subId = last.subscriptions.single.id;
    client.document = const SubscriptionDocument(
      body: '',
      headers: {'profile-title': 'Disabled'},
    );

    await controller.refreshSubscription(subId);
    expect(last.savedProfiles, isEmpty);
    expect(last.subscriptions.single.name, 'Disabled');
    expect(last.subscriptions.single.id, subId);
  });

  test('importInput still accepts a standalone share link', () async {
    await controller.importInput(_linkA, name: 'Solo');
    expect(client.fetchCount, 0);
    expect(last.subscriptions, isEmpty);
    expect(last.savedProfiles.single.link, _linkA);
    expect(last.savedProfiles.single.name, 'Solo');
    expect(last.savedProfiles.single.subscriptionId, isNull);
  });

  test('importInput routes https to the subscription client', () async {
    await controller.importInput('https://panel.example/sub');
    expect(client.fetchCount, 1);
    expect(last.savedProfiles, hasLength(2));
  });

  test('importInput rejects http subscription URLs', () async {
    expect(
      () => controller.importInput('http://panel.example/sub'),
      throwsA(
        isA<SubscriptionParseException>().having(
          (e) => e.message,
          'message',
          contains('HTTPS'),
        ),
      ),
    );
    expect(client.fetchCount, 0);
    expect(last.subscriptions, isEmpty);
  });

  test('importInput unwraps goodwin://import deeplink', () async {
    await controller.importInput(
      'goodwin://import?url=${Uri.encodeComponent(_linkA)}',
      name: 'FromLink',
    );
    expect(client.fetchCount, 0);
    expect(last.savedProfiles.single.link, _linkA);
    expect(last.savedProfiles.single.name, 'FromLink');
  });

  test('restoreBackup merges without duplicating links', () async {
    await controller.saveShareLinkToList(_linkA, name: 'Local');
    final result = await controller.restoreBackup(
      ProfileBackup(
        profiles: [
          SavedProfile.fromLink(_linkA, name: 'BackupA'),
          SavedProfile.fromLink(_linkC, name: 'BackupC'),
        ],
        subscriptions: const [
          VpnSubscription(
            id: 's-b',
            name: 'From file',
            url: 'https://other.example/sub',
          ),
        ],
      ),
    );
    expect(result.addedProfiles, 1);
    expect(result.addedSubscriptions, 1);
    expect(last.savedProfiles.map((p) => p.link), [_linkC, _linkA]);
    expect(
      last.savedProfiles.singleWhere((p) => p.link == _linkA).name,
      'Local',
    );
    expect(last.savedProfiles.first.name, 'BackupC');
    expect(last.subscriptions.single.url, 'https://other.example/sub');
  });

  test('removeSubscription drops nodes', () async {
    await controller.importSubscription('https://panel.example/sub');
    await controller.removeSubscription(last.subscriptions.single.id);
    expect(last.subscriptions, isEmpty);
    expect(last.savedProfiles, isEmpty);
  });

  test(
    'refreshDueSubscriptions skips a fresh sub and fetches a stale one',
    () async {
      await store.upsertSubscription(
        VpnSubscription(
          id: 'fresh',
          name: 'Fresh',
          url: 'https://fresh.example/sub',
          lastFetched: DateTime.now().toUtc(),
        ),
      );
      await store.upsertSubscription(
        VpnSubscription(
          id: 'stale',
          name: 'Stale',
          url: 'https://stale.example/sub',
          lastFetched: DateTime.now().toUtc().subtract(
            const Duration(hours: 48),
          ),
        ),
      );
      final body = client.document!;
      client.document = null;
      client.byUrl['https://stale.example/sub'] = body;

      await controller.refreshDueSubscriptions();
      expect(client.fetchedUrls.map((u) => u.toString()), [
        'https://stale.example/sub',
      ]);
      expect(
        last.subscriptions.where((s) => s.id == 'stale').single.lastFetched,
        isNotNull,
      );
    },
  );

  test('refresh 404 keeps nodes and marks the subscription revoked', () async {
    await controller.importSubscription(
      'https://panel.example/sub/secret-token',
    );
    final subId = last.subscriptions.single.id;
    expect(last.savedProfiles, hasLength(2));
    client.error = SubscriptionRevokedException();

    await expectLater(
      controller.refreshSubscription(subId),
      throwsA(isA<SubscriptionRevokedException>()),
    );
    expect(last.savedProfiles, hasLength(2));
    expect(last.subscriptions.single.id, subId);
    expect(last.subscriptions.single.revoked, isTrue);
    expect(last.logs.join('\n'), isNot(contains('secret-token')));
  });

  test('404 revoke keeps serviceBase from the last good fetch', () async {
    client.document = SubscriptionDocument(
      body: '$_linkA\n$_linkB',
      headers: {
        ...client.document!.headers,
        'Goodwin-VPN': 'v1; base="https://panel.example"',
      },
    );
    await controller.importSubscription(
      'https://panel.example/sub/secret-token',
    );
    expect(last.subscriptions.single.serviceBase, 'https://panel.example');
    client.error = SubscriptionRevokedException();

    await expectLater(
      controller.refreshSubscription(last.subscriptions.single.id),
      throwsA(isA<SubscriptionRevokedException>()),
    );
    expect(last.subscriptions.single.revoked, isTrue);
    expect(last.subscriptions.single.serviceBase, 'https://panel.example');
  });

  test('session logs redact subscription tokens', () async {
    await controller.importSubscription(
      'https://panel.example/sub/secret-token',
    );
    expect(last.logs.join('\n'), isNot(contains('secret-token')));
    expect(last.logs.join('\n'), contains('/sub/…'));
  });
}
