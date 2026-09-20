import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/saved_profile.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';
import 'package:goodwin_vpn_client/session/subscription_parser.dart';

const _linkA =
    'vless://11111111-2222-3333-4444-555555555555@a.example.com:443'
    '?encryption=none&security=none#NodeA';
const _linkB =
    'vless://11111111-2222-3333-4444-555555555555@b.example.com:443'
    '?encryption=none&security=none#NodeB';

void main() {
  test('parses device-limit and device-count from userinfo', () {
    final info = SubscriptionUserinfo.parseHeader(
      'upload=0; download=0; total=0; expire=0; device-limit=3; device-count=1',
    );
    expect(info?.deviceLimit, 3);
    expect(info?.deviceCount, 1);
    expect(info?.hasDeviceInfo, isTrue);
  });

  test('ignores zero device-limit', () {
    final info = SubscriptionUserinfo.parseHeader(
      'upload=0; download=0; total=1; expire=0; device-limit=0',
    );
    expect(info?.deviceLimit, isNull);
  });

  test('parses newline share links and HTTP headers', () {
    final parsed = parseSubscriptionDocument(
      SubscriptionDocument(
        body: '$_linkA\n$_linkB\nss://skip-me\nnot-a-link',
        headers: {
          'profile-title': 'base64:${base64.encode(utf8.encode('Panel'))}',
          'profile-update-interval': '12',
          'subscription-userinfo':
              'upload=0; download=1048576; total=1073741824; expire=1893456000',
        },
      ),
    );
    expect(parsed.links, [_linkA, _linkB]);
    expect(parsed.title, 'Panel');
    expect(parsed.intervalHours, 12);
    expect(parsed.userinfo?.download, 1048576);
    expect(parsed.userinfo?.total, 1073741824);
    expect(parsed.userinfo?.displayLine, contains('GB'));
    expect(parsed.userinfo?.displayLine, contains('VLESS'));
    expect(parsed.userinfo?.displayLine, contains('d left'));
    expect(SubscriptionUserinfo.quotaScopeNote, contains('Hy2'));
  });

  test('decodes a base64 body', () {
    final parsed = parseSubscriptionDocument(
      SubscriptionDocument(
        body: base64.encode(utf8.encode('$_linkA\n$_linkB')),
      ),
    );
    expect(parsed.links, [_linkA, _linkB]);
  });

  test('reads metadata from comment lines', () {
    final parsed = parseSubscriptionDocument(
      const SubscriptionDocument(
        body: '#profile-title: From comments\n'
            '#profile-update-interval: 6\n'
            '#subscription-userinfo: upload=1; download=2; total=3; expire=0\n'
            '$_linkA',
      ),
    );
    expect(parsed.title, 'From comments');
    expect(parsed.intervalHours, 6);
    expect(parsed.userinfo?.used, 3);
    expect(parsed.userinfo?.expire, isNull);
  });

  test('rejects Clash YAML', () {
    expect(
      () => parseSubscriptionDocument(
        const SubscriptionDocument(
          body: 'proxies:\n  - name: ss\n    type: ss\n    server: 1.2.3.4\n',
        ),
      ),
      throwsA(
        isA<SubscriptionParseException>().having(
          (e) => e.message,
          'message',
          contains('Clash'),
        ),
      ),
    );
  });

  test('empty body keeps header title (disabled user)', () {
    final parsed = parseSubscriptionDocument(
      const SubscriptionDocument(
        body: '',
        headers: {'profile-title': 'Panel'},
      ),
    );
    expect(parsed.links, isEmpty);
    expect(parsed.title, 'Panel');
  });

  test('throws when the body has no supported share links', () {
    expect(
      () => parseSubscriptionDocument(
        const SubscriptionDocument(body: 'ss://only-shadowsocks\n'),
      ),
      throwsA(isA<SubscriptionParseException>()),
    );
  });

  test('looksLikeSubscriptionUrl', () {
    expect(looksLikeSubscriptionUrl('https://panel.example/sub'), isTrue);
    expect(looksLikeSubscriptionUrl('http://panel.example/sub'), isTrue);
    expect(looksLikeSubscriptionUrl(_linkA), isFalse);
    expect(looksLikeSubscriptionUrl('not a url'), isFalse);
  });

  test('decodeProfileTitle unwraps base64 prefix', () {
    expect(
      decodeProfileTitle('base64:${base64.encode(utf8.encode('My Panel'))}'),
      'My Panel',
    );
    expect(decodeProfileTitle('Plain'), 'Plain');
  });

  test('quotaSubscriptionFor prefers the selected profile subscription', () {
    const a = VpnSubscription(id: 'a', name: 'A', url: 'https://a.example/sub');
    const b = VpnSubscription(id: 'b', name: 'B', url: 'https://b.example/sub');
    final profile = SavedProfile.fromLink(_linkA, subscriptionId: 'b');
    expect(
      quotaSubscriptionFor(subscriptions: const [a, b], profile: profile)?.id,
      'b',
    );
    expect(
      quotaSubscriptionFor(subscriptions: const [a], profile: null)?.id,
      'a',
    );
  });
}
