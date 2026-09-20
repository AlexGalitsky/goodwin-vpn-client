import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/subscription_client.dart';
import 'package:goodwin_vpn_client/session/subscription_parser.dart';

void main() {
  test('requireHttpsSubscriptionUri accepts https', () {
    requireHttpsSubscriptionUri(Uri.parse('https://panel.example/sub'));
  });

  test('requireHttpsSubscriptionUri rejects http and empty host', () {
    expect(
      () => requireHttpsSubscriptionUri(Uri.parse('http://panel.example/sub')),
      throwsA(
        isA<SubscriptionParseException>().having(
          (e) => e.message,
          'message',
          contains('HTTPS'),
        ),
      ),
    );
    expect(
      () => requireHttpsSubscriptionUri(Uri.parse('https://')),
      throwsA(isA<SubscriptionParseException>()),
    );
  });

  test('appendSubscriptionBytes enforces the cap', () {
    final acc = <int>[1, 2, 3];
    appendSubscriptionBytes(acc, [4, 5], 8);
    expect(acc, [1, 2, 3, 4, 5]);
    expect(
      () => appendSubscriptionBytes(acc, List<int>.filled(10, 0), 8),
      throwsA(
        isA<SubscriptionParseException>().having(
          (e) => e.message,
          'message',
          contains('exceeds'),
        ),
      ),
    );
  });

  test('throwForSubscriptionStatus maps 404 to revoked, other codes to HTTP', () {
    expect(
      () => throwForSubscriptionStatus(404),
      throwsA(isA<SubscriptionRevokedException>()),
    );
    expect(
      () => throwForSubscriptionStatus(500),
      throwsA(
        isA<SubscriptionParseException>().having(
          (e) => e.message,
          'message',
          contains('HTTP 500'),
        ),
      ),
    );
  });
}
