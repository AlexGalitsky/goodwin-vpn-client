import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists which profile groups are collapsed on Profiles.
class ProfileGroupCollapseStore {
  ProfileGroupCollapseStore(this._prefs);

  static const key = 'profile_group_collapsed_v1';
  static const manualGroupId = 'manual';

  final SharedPreferences _prefs;

  Set<String> readCollapsed() {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return {};
    try {
      final list = jsonDecode(raw);
      if (list is! List) return {};
      return {for (final e in list) e.toString()};
    } catch (_) {
      return {};
    }
  }

  Future<void> writeCollapsed(Set<String> ids) async {
    await _prefs.setString(key, jsonEncode(ids.toList()..sort()));
  }

  Future<void> setCollapsed(String groupId, bool collapsed) async {
    final next = readCollapsed();
    if (collapsed) {
      next.add(groupId);
    } else {
      next.remove(groupId);
    }
    await writeCollapsed(next);
  }
}
