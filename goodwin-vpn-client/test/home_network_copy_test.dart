import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/home/presentation/home_network_copy.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('connected + system tunnel is not "Protected"', () {
    final copy = homeNetworkCopy(
      l10n: l10n,
      connected: true,
      busy: false,
      tunnelSupported: true,
    );
    expect(copy.title, 'System VPN');
    expect(copy.subtitle.toLowerCase(), isNot(contains('end-to-end')));
  });

  test('connected without tunnel tells the user SOCKS is local', () {
    final copy = homeNetworkCopy(
      l10n: l10n,
      connected: true,
      busy: false,
      tunnelSupported: false,
    );
    expect(copy.title, 'Local SOCKS');
    expect(copy.subtitle, contains('127.0.0.1:10808'));
    expect(copy.subtitle.toLowerCase(), contains('not hidden'));
  });

  test('idle without tunnel does not claim a system VPN', () {
    final copy = homeNetworkCopy(
      l10n: l10n,
      connected: false,
      busy: false,
      tunnelSupported: false,
    );
    expect(copy.title, 'Disconnected');
    expect(copy.subtitle.toLowerCase(), contains('no system vpn'));
  });
}
