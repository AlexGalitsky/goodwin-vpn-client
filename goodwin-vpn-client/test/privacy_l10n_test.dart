import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/core/config/privacy_policy.dart';
import 'package:goodwin_vpn_client/core/config/support_url.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations_en.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations_ru.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';

void main() {
  test('public privacy URL is HTTPS on vpnclient site', () {
    final uri = Uri.parse(kPrivacyPolicyUrl);
    expect(uri.scheme, 'https');
    expect(uri.host, 'vpnclient.goodwin.website');
    expect(uri.path, '/privacy');
  });

  test('privacyPolicyUrlFor prefers a Goodwin catalog URL', () {
    expect(privacyPolicyUrlFor(const []), kPrivacyPolicyUrl);
    expect(
      privacyPolicyUrlFor(const [
        VpnSubscription(
          id: 's1',
          name: 'Panel',
          url: 'https://panel.example/sub',
          serviceBase: 'https://panel.example',
          protocolVersion: 1,
          privacyUrl: 'https://panel.example/privacy',
        ),
      ]),
      'https://panel.example/privacy',
    );
    expect(
      privacyPolicyUrlFor(const [
        VpnSubscription(
          id: 's1',
          name: 'Panel',
          url: 'https://panel.example/sub',
          privacyUrl: 'http://panel.example/privacy',
        ),
      ]),
      kPrivacyPolicyUrl,
    );
  });

  test('RU and EN both ship privacy and backup strings', () {
    final en = AppLocalizationsEn();
    final ru = AppLocalizationsRu();
    expect(en.privacyOpenWeb, isNotEmpty);
    expect(ru.privacyOpenWeb, isNot(en.privacyOpenWeb));
    expect(en.importBackupSubtitle, contains('Merges'));
    expect(ru.importBackupSubtitle, contains('каталог'));
  });

  test('public support URL is HTTPS on vpnclient site', () {
    final uri = Uri.parse(kSupportUrl);
    expect(uri.scheme, 'https');
    expect(uri.host, 'vpnclient.goodwin.website');
    expect(uri.path, '/support');
  });

  test('supportUrlFor prefers a Goodwin catalog URL', () {
    expect(supportUrlFor(const []), kSupportUrl);
    expect(
      supportUrlFor(const [
        VpnSubscription(
          id: 's1',
          name: 'Panel',
          url: 'https://panel.example/sub',
          serviceBase: 'https://panel.example',
          protocolVersion: 1,
          supportUrl: 'https://panel.example/help',
        ),
      ]),
      'https://panel.example/help',
    );
    expect(
      supportUrlFor(const [
        VpnSubscription(
          id: 's1',
          name: 'Panel',
          url: 'https://panel.example/sub',
          supportUrl: 'http://panel.example/help',
        ),
      ]),
      kSupportUrl,
    );
  });
}
