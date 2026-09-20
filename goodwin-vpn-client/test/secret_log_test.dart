import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/secret_log.dart';

void main() {
  test('redactForLog strips share URIs, sub tokens, and UUIDs', () {
    const uuid = '11111111-2222-3333-4444-555555555555';
    final line = redactForLog(
      'fetch https://saturn.example/sub/tokensecret '
      'vless://$uuid@node.example:443#n '
      'hy2://hunter2@hy.example:443/',
    );
    expect(line, isNot(contains('tokensecret')));
    expect(line, isNot(contains(uuid)));
    expect(line, isNot(contains('hunter2')));
    expect(line, contains('https://saturn.example/sub/…'));
    expect(line, contains('vless://…'));
    expect(line, contains('hy2://…'));
  });
}
