import '../session/saved_profile.dart';
import '../session/subscription.dart';

/// Store-safe demo catalog (no live tokens / emails).
abstract final class StoreDemoCatalog {
  static const subId = 's_store_demo';

  static const frankfurtLink =
      'vless://00000000-0000-4000-8000-000000000001@203.0.113.10:443'
      '?encryption=none&security=none#%F0%9F%87%A9%F0%9F%87%AA%20Frankfurt';

  static const amsterdamLink =
      'vless://00000000-0000-4000-8000-000000000002@203.0.113.20:443'
      '?encryption=none&security=none#%F0%9F%87%B3%F0%9F%87%B1%20Amsterdam';

  static List<SavedProfile> profiles() => [
        SavedProfile(
          id: 'p_frankfurt',
          name: '🇩🇪 Frankfurt',
          link: frankfurtLink,
          subscriptionId: subId,
        ),
        SavedProfile(
          id: 'p_amsterdam',
          name: '🇳🇱 Amsterdam',
          link: amsterdamLink,
          subscriptionId: subId,
        ),
      ];

  static List<VpnSubscription> subscriptions() => [
        VpnSubscription(
          id: subId,
          name: 'Goodwin',
          url: 'https://panel.example/sub/demo',
          accountLabel: 'demo-account',
          lastFetched: DateTime.now().toUtc().subtract(const Duration(hours: 2)),
          intervalHours: 24,
          userinfo: SubscriptionUserinfo(
            upload: 0,
            download: 12 * 1024 * 1024 * 1024,
            total: 100 * 1024 * 1024 * 1024,
            expire: DateTime.now().toUtc().add(const Duration(days: 28)),
            deviceLimit: 3,
            deviceCount: 1,
          ),
          serviceName: 'Goodwin',
        ),
      ];
}
