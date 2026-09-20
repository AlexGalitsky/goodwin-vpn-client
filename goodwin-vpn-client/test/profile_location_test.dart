import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_client/features/servers/presentation/profile_location.dart';

void main() {
  test('flag emoji + city', () {
    expect(profileLocationHint('🇩🇪 Frankfurt'), '🇩🇪 Frankfurt');
    expect(
      profileLocationHint('🇳🇱 Amsterdam | Premium'),
      '🇳🇱 Amsterdam',
    );
  });

  test('ISO code brackets', () {
    expect(profileLocationHint('[NL] Node 1'), 'NL · Node 1');
    expect(profileLocationHint('(de) Berlin'), 'DE · Berlin');
    expect(profileLocationHint('[US]'), 'US');
  });

  test('returns null without location signal', () {
    expect(profileLocationHint(''), isNull);
    expect(profileLocationHint('Premium-1'), isNull);
    expect(profileLocationHint('node.example.com:443'), isNull);
  });
}
