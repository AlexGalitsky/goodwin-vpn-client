import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_client/l10n/quota_copy.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';

void main() {
  test('subscriptionHostDisplay strips path and query', () {
    expect(
      subscriptionHostDisplay('https://panel.example/sub/secret-token?x=1'),
      'https://panel.example',
    );
    expect(
      subscriptionHostDisplay('https://panel.example:8443/path'),
      'https://panel.example:8443',
    );
  });

  test('shouldWarnExpire for expired and under 3 days', () {
    final expired = SubscriptionUserinfo(
      expire: DateTime.now().toUtc().subtract(const Duration(days: 1)),
    );
    final soon = SubscriptionUserinfo(
      expire: DateTime.now().toUtc().add(const Duration(days: 2)),
    );
    final ok = SubscriptionUserinfo(
      expire: DateTime.now().toUtc().add(const Duration(days: 10)),
    );
    expect(shouldWarnExpire(expired), isTrue);
    expect(shouldWarnExpire(soon), isTrue);
    expect(shouldWarnExpire(ok), isFalse);
    expect(shouldWarnExpire(null), isFalse);
    expect(shouldWarnExpire(const SubscriptionUserinfo()), isFalse);
  });
}
