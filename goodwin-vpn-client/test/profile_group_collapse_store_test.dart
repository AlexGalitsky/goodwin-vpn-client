import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_client/features/servers/data/profile_group_collapse_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ProfileGroupCollapseStore persists collapsed ids', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = ProfileGroupCollapseStore(prefs);

    expect(store.readCollapsed(), isEmpty);

    await store.setCollapsed('sub-a', true);
    await store.setCollapsed('manual', true);
    expect(store.readCollapsed(), {'sub-a', 'manual'});

    await store.setCollapsed('sub-a', false);
    expect(store.readCollapsed(), {'manual'});
  });
}
