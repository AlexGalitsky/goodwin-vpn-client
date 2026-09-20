import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/backup_codec.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';
import 'package:goodwin_vpn_client/session/session_store.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';

void main() {
  const profile = SavedProfile(
    id: 'p1',
    name: 'Node',
    link: 'vless://abc@host:443?encryption=none&security=none#n',
    subscriptionId: 's1',
  );
  const sub = VpnSubscription(
    id: 's1',
    name: 'Panel',
    url: 'https://panel.example/sub',
  );

  test('plaintext round-trip and legacy clipboard JSON', () {
    final encoded = encodeBackup(
      const ProfileBackup(profiles: [profile], subscriptions: [sub]),
    );
    final decoded = decodeBackup(encoded);
    expect(decoded.profiles.single.link, profile.link);
    expect(decoded.subscriptions.single.url, sub.url);

    final legacy = decodeBackup(
      jsonEncode({
        'exportedAt': '2026-01-01T00:00:00Z',
        'profiles': [profile.toJson()],
        'subscriptions': [sub.toJson()],
      }),
    );
    expect(legacy.profiles, hasLength(1));
    expect(legacy.subscriptions, hasLength(1));
  });

  test('password encrypts and wrong password fails', () {
    final encoded = encodeBackup(
      const ProfileBackup(profiles: [profile], subscriptions: [sub]),
      password: 'secret-pass',
    );
    final json = jsonDecode(encoded) as Map;
    expect(json['encrypted'], isTrue);
    expect(encoded, isNot(contains('vless://')));
    expect(encoded, isNot(contains('panel.example')));

    final decoded = decodeBackup(encoded, password: 'secret-pass');
    expect(decoded.profiles.single.name, 'Node');

    expect(
      () => decodeBackup(encoded),
      throwsA(isA<BackupPasswordException>()),
    );
    expect(
      () => decodeBackup(encoded, password: 'nope'),
      throwsA(isA<BackupPasswordException>()),
    );
  });

  test('merge keeps local links and remaps subscription ids', () {
    const localSub = VpnSubscription(
      id: 'local-s',
      name: 'Mine',
      url: 'https://panel.example/sub',
    );
    const localNode = SavedProfile(
      id: 'local-p',
      name: 'Existing',
      link: 'vless://abc@host:443?encryption=none&security=none#n',
      subscriptionId: 'local-s',
    );
    const extra = SavedProfile(
      id: 'p2',
      name: 'Extra',
      link: 'hy2://token@other.example:443',
    );
    final merged = mergeProfileBackup(
      currentSubscriptions: const [localSub],
      currentProfiles: const [localNode],
      backup: const ProfileBackup(
        profiles: [profile, extra],
        subscriptions: [sub],
      ),
    );
    expect(merged.addedSubscriptions, 0);
    expect(merged.addedProfiles, 1);
    expect(merged.subscriptions.single.id, 'local-s');
    expect(merged.subscriptions.single.name, 'Panel');
    expect(merged.profiles.map((p) => p.link), [
      extra.link,
      profile.link,
    ]);
    expect(merged.profiles.first.subscriptionId, isNull);
  });

  test('merge updates existing subscription URL by id (rotation)', () {
    const local = VpnSubscription(
      id: 's1',
      name: 'Mine',
      url: 'https://panel.example/sub/old',
      revoked: true,
    );
    final merged = mergeProfileBackup(
      currentSubscriptions: const [local],
      currentProfiles: const [],
      backup: ProfileBackup(
        profiles: const [],
        subscriptions: [
          VpnSubscription(
            id: 's1',
            name: 'Panel',
            url: 'https://panel.example/sub/new',
            lastFetched: DateTime.utc(2026, 9, 1),
          ),
        ],
      ),
    );
    expect(merged.addedSubscriptions, 0);
    expect(merged.subscriptions.single.id, 's1');
    expect(merged.subscriptions.single.url, 'https://panel.example/sub/new');
    expect(merged.subscriptions.single.name, 'Panel');
    expect(merged.subscriptions.single.revoked, isFalse);
    expect(merged.subscriptions.single.lastFetched, DateTime.utc(2026, 9, 1));
  });

  test('backup round-trip and merge keep serviceBase', () {
    const withService = VpnSubscription(
      id: 's1',
      name: 'Saturn',
      url: 'https://saturn.goodwin.website/sub/t',
      serviceBase: 'https://saturn.goodwin.website',
      protocolVersion: 1,
      serviceName: 'Goodwin VPN',
      privacyUrl: 'https://saturn.goodwin.website/privacy',
      features: ['geo-packs'],
    );
    final encoded = encodeBackup(
      const ProfileBackup(profiles: [], subscriptions: [withService]),
    );
    final decoded = decodeBackup(encoded);
    expect(decoded.subscriptions.single.serviceBase, withService.serviceBase);
    expect(decoded.subscriptions.single.protocolVersion, 1);
    expect(decoded.subscriptions.single.privacyUrl, withService.privacyUrl);
    expect(decoded.subscriptions.single.features, ['geo-packs']);

    const local = VpnSubscription(
      id: 's1',
      name: 'Local',
      url: 'https://saturn.goodwin.website/sub/t',
      serviceBase: 'https://saturn.goodwin.website',
      protocolVersion: 1,
    );
    final merged = mergeProfileBackup(
      currentSubscriptions: const [local],
      currentProfiles: const [],
      backup: const ProfileBackup(
        profiles: [],
        subscriptions: [
          VpnSubscription(
            id: 's1',
            name: 'Panel',
            url: 'https://saturn.goodwin.website/sub/t',
          ),
        ],
      ),
    );
    expect(merged.subscriptions.single.serviceBase, local.serviceBase);
    expect(merged.subscriptions.single.protocolVersion, 1);
  });

  test('merge keeps restored profiles when the catalog is at cap', () {
    final current = [
      for (var i = 0; i < MemorySessionStore.maxSaved; i++)
        SavedProfile.fromLink(
          'vless://id$i@host.example:443?encryption=none&security=none#n$i',
          name: 'Old$i',
        ),
    ];
    const fresh = SavedProfile(
      id: 'fresh',
      name: 'From backup',
      link: 'hy2://token@other.example:443',
    );
    final merged = mergeProfileBackup(
      currentSubscriptions: const [],
      currentProfiles: current,
      backup: const ProfileBackup(profiles: [fresh], subscriptions: []),
    );
    expect(merged.addedProfiles, 1);
    expect(merged.profiles, hasLength(MemorySessionStore.maxSaved));
    expect(merged.profiles.first.link, fresh.link);
    expect(merged.profiles.map((p) => p.link), isNot(contains(current.last.link)));
  });
}
