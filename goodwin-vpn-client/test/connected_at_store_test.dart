import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_client/session/session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goodwin_vpn_client/session/prefs_session_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('MemorySessionStore persists connectedAt', () async {
    final store = MemorySessionStore();
    expect(await store.connectedAt(), isNull);

    final started = DateTime.utc(2026, 9, 19, 7, 0);
    await store.setConnectedAt(started);
    expect(await store.connectedAt(), started);

    await store.setConnectedAt(null);
    expect(await store.connectedAt(), isNull);
  });

  test('PrefsSessionStore persists connectedAt across instances', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = PrefsSessionStore(prefs: prefs);
    final started = DateTime.utc(2026, 9, 19, 8, 30);
    await store.setConnectedAt(started);

    final again = PrefsSessionStore(prefs: prefs);
    final loaded = await again.connectedAt();
    expect(loaded?.millisecondsSinceEpoch, started.millisecondsSinceEpoch);
  });
}
