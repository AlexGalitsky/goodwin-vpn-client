import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goodwin_vpn_client/session/prefs_session_store.dart';
import 'package:goodwin_vpn_client/session/session_key_store.dart';

class _FailingKeyStore implements SessionKeyStore {
  @override
  Future<Uint8List> loadOrCreate() async => throw StateError('no key');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('key failure does not persist plaintext secrets', () async {
    SharedPreferences.setMockInitialValues({});
    final store = PrefsSessionStore(keyStore: _FailingKeyStore());
    await store.saveLastShareLink('vless://secret@host:443');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('last_share_link'), isNull);
    expect(await store.lastShareLink(), isNull);
  });

  test('corrupt envelope does not crash reads', () async {
    SharedPreferences.setMockInitialValues({
      'last_share_link': '{"v":1,"n":"AAAA","c":"AAAA"}',
    });
    final store = PrefsSessionStore(keyStore: MemorySessionKeyStore());
    expect(await store.lastShareLink(), isNull);
  });
}
