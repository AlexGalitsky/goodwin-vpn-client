import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/import_uri.dart';

void main() {
  test('unwraps goodwin://import query', () {
    expect(
      unwrapImportText(
        'goodwin://import?url=${Uri.encodeComponent('https://panel.example/sub')}',
      ),
      'https://panel.example/sub',
    );
    expect(
      unwrapImportText('goodwin://import?link=vless://abc@host:443'),
      'vless://abc@host:443',
    );
    expect(unwrapImportText('vless://abc@host:443'), 'vless://abc@host:443');
    expect(
      unwrapImportText('https://panel.example/sub'),
      'https://panel.example/sub',
    );
  });

  test('missing url throws', () {
    expect(
      () => unwrapImportText('goodwin://import'),
      throwsA(isA<ImportUriException>()),
    );
  });

  test('isGoodwinImportUri', () {
    expect(isGoodwinImportUri(Uri.parse('goodwin://import?url=x')), isTrue);
    expect(isGoodwinImportUri(Uri.parse('https://panel.example/sub')), isFalse);
  });
}
