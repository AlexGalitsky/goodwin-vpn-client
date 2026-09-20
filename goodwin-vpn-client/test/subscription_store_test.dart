import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goodwin_vpn_client/session/at_rest_crypto.dart';
import 'package:goodwin_vpn_client/session/prefs_session_store.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';
import 'package:goodwin_vpn_client/session/session_key_store.dart';
import 'package:goodwin_vpn_client/session/session_store.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';

void main() {
  const sub = VpnSubscription(
    id: 's1',
    name: 'Panel',
    url: 'https://panel.example/sub',
  );

  test('SavedProfile JSON round-trips subscriptionId', () {
    final profile = SavedProfile.fromLink(
      'vless://a',
      name: 'A',
      subscriptionId: 's1',
    );
    final decoded = SavedProfile.fromJson(profile.toJson());
    expect(decoded.subscriptionId, 's1');
    expect(decoded.id, profile.id);
    expect(decoded.link, 'vless://a');
  });

  test('VpnSubscription JSON drops a non-https serviceBase', () {
    final decoded = VpnSubscription.fromJson({
      'id': 's1',
      'name': 'X',
      'url': 'https://panel.example/sub',
      'serviceBase': 'http://panel.example',
      'protocolVersion': 1,
    });
    expect(decoded.serviceBase, isNull);
    expect(decoded.protocolVersion, isNull);

    final ok = VpnSubscription.fromJson({
      'id': 's1',
      'name': 'X',
      'url': 'https://panel.example/sub',
      'serviceBase': 'https://panel.example',
      'protocolVersion': 1,
    });
    expect(ok.serviceBase, 'https://panel.example');
    expect(ok.isGoodwinService, isTrue);
  });

  test('upsert by URL keeps the existing subscription id', () async {
    final store = MemorySessionStore(subscriptionsValue: [sub]);
    await store.upsertSubscription(
      const VpnSubscription(
        id: 's-new',
        name: 'Renamed',
        url: 'https://panel.example/sub',
        intervalHours: 12,
      ),
    );
    final items = await store.subscriptions();
    expect(items, hasLength(1));
    expect(items.single.id, 's1');
    expect(items.single.name, 'Renamed');
    expect(items.single.intervalHours, 12);
  });

  test('upsert by URL copies serviceBase from the incoming row', () async {
    final store = MemorySessionStore(subscriptionsValue: [sub]);
    await store.upsertSubscription(
      const VpnSubscription(
        id: 's-new',
        name: 'Panel',
        url: 'https://panel.example/sub',
        serviceBase: 'https://panel.example',
        protocolVersion: 1,
      ),
    );
    final items = await store.subscriptions();
    expect(items.single.id, 's1');
    expect(items.single.serviceBase, 'https://panel.example');
    expect(items.single.protocolVersion, 1);
  });

  test('replaceSubscriptionNodes swaps only that sub and reuses caller ids',
      () async {
    final store = MemorySessionStore(
      savedProfilesValue: [
        const SavedProfile(
          id: 'manual',
          name: 'Solo',
          link: 'vless://solo',
        ),
        const SavedProfile(
          id: 'n1',
          name: 'Old',
          link: 'vless://a',
          subscriptionId: 's1',
        ),
      ],
    );
    await store.replaceSubscriptionNodes(
      subscriptionId: 's1',
      nodes: const [
        SavedProfile(
          id: 'n1',
          name: 'Kept',
          link: 'vless://a',
          subscriptionId: 's1',
        ),
        SavedProfile(
          id: 'n2',
          name: 'New',
          link: 'vless://b',
          subscriptionId: 's1',
        ),
      ],
    );
    final profiles = await store.savedProfiles();
    expect(profiles.map((p) => p.id), ['manual', 'n1', 'n2']);
    expect(profiles.firstWhere((p) => p.id == 'n1').name, 'Kept');
  });

  test('removeSubscription cascades to nodes', () async {
    final store = MemorySessionStore(
      subscriptionsValue: [sub],
      savedProfilesValue: [
        const SavedProfile(
          id: 'n1',
          name: 'A',
          link: 'vless://a',
          subscriptionId: 's1',
        ),
        const SavedProfile(id: 'manual', name: 'Solo', link: 'vless://solo'),
      ],
    );
    final result = await store.removeSubscription('s1');
    expect(result.subscriptions, isEmpty);
    expect(result.profiles.map((p) => p.id), ['manual']);
  });

  test('addSavedProfile keeps id and subscriptionId on the same link',
      () async {
    final store = MemorySessionStore(
      savedProfilesValue: [
        const SavedProfile(
          id: 'n1',
          name: 'A',
          link: 'vless://a',
          subscriptionId: 's1',
        ),
      ],
    );
    final next = await store.addSavedProfile('vless://a');
    expect(next.single.id, 'n1');
    expect(next.single.subscriptionId, 's1');
    expect(next.single.name, 'A');
  });

  test('PrefsSessionStore persists subscriptions', () async {
    SharedPreferences.setMockInitialValues({});
    final keys = MemorySessionKeyStore();
    final store = PrefsSessionStore(keyStore: keys);
    await store.upsertSubscription(sub);
    await store.replaceSubscriptionNodes(
      subscriptionId: sub.id,
      nodes: [
        SavedProfile.fromLink('vless://a', name: 'A', subscriptionId: sub.id),
      ],
    );
    final again = PrefsSessionStore(
      prefs: await SharedPreferences.getInstance(),
      keyStore: keys,
    );
    expect((await again.subscriptions()).single.id, 's1');
    expect((await again.savedProfiles()).single.subscriptionId, 's1');
  });

  test('PrefsSessionStore encrypts share links at rest and migrates plaintext',
      () async {
    SharedPreferences.setMockInitialValues({
      'last_share_link': 'vless://uuid@host:443?security=tls#n',
    });
    final keys = MemorySessionKeyStore();
    final prefs = await SharedPreferences.getInstance();
    final store = PrefsSessionStore(prefs: prefs, keyStore: keys);
    expect(await store.lastShareLink(), 'vless://uuid@host:443?security=tls#n');
    final raw = prefs.getString('last_share_link')!;
    expect(looksLikeAtRestEnvelope(raw), isTrue);
    expect(raw, isNot(contains('vless://')));
    final again = PrefsSessionStore(prefs: prefs, keyStore: keys);
    expect(await again.lastShareLink(), 'vless://uuid@host:443?security=tls#n');
  });
}
