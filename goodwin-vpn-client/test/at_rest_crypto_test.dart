import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/at_rest_crypto.dart';

void main() {
  test('seal/open round-trips UTF-8', () {
    final key = newAtRestKey();
    const plain = 'vless://uuid@host:443?security=tls#node';
    final envelope = sealAtRest(key, plain);
    expect(looksLikeAtRestEnvelope(envelope), isTrue);
    expect(envelope, isNot(contains('vless://')));
    expect(openAtRest(key, envelope), plain);
  });

  test('plaintext is not treated as an envelope', () {
    expect(looksLikeAtRestEnvelope('vless://a'), isFalse);
    expect(looksLikeAtRestEnvelope('[{"link":"vless://a"}]'), isFalse);
  });

  test('wrong key fails closed', () {
    final envelope = sealAtRest(newAtRestKey(), 'secret');
    expect(() => openAtRest(newAtRestKey(), envelope), throwsA(anything));
  });
}
