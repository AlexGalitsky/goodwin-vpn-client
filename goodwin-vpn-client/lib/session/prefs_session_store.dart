import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import 'at_rest_crypto.dart';
import 'saved_profile.dart';
import 'session_key_store.dart';
import 'session_store.dart';
import 'subscription.dart';

class PrefsSessionStore implements SessionStore {
  PrefsSessionStore({
    SharedPreferences? prefs,
    SessionKeyStore? keyStore,
  })  : _prefs = prefs,
        _keyStore = keyStore ?? FlutterSessionKeyStore();

  SharedPreferences? _prefs;
  final SessionKeyStore _keyStore;
  Uint8List? _cachedKey;
  var _keyFailed = false;

  static const _linkKey = 'last_share_link';
  static const _autoKey = 'auto_connect';
  static const _smartConnectKey = 'smart_connect';
  static const _savedKey = 'saved_share_links'; // legacy StringList
  static const _profilesKey = 'saved_profiles'; // JSON list of SavedProfile
  static const _subscriptionsKey = 'vpn_subscriptions';
  static const _pendingKey = 'pending_connect';
  static const _excludeKey = 'exclude_routes';
  static const _disallowedPackagesKey = 'vpn_disallowed_packages';
  static const _connectedAtKey = 'vpn_connected_at_ms';
  static const _maxSaved = MemorySessionStore.maxSaved;

  Future<SharedPreferences> _ready() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<String?> lastShareLink() async {
    final value = (await _readProtected(_linkKey))?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  @override
  Future<bool> autoConnect() async {
    return (await _ready()).getBool(_autoKey) ?? false;
  }

  @override
  Future<List<SavedProfile>> savedProfiles() async {
    final prefs = await _ready();
    final raw = await _readProtected(_profilesKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        return List<SavedProfile>.unmodifiable(SavedProfile.decodeList(raw));
      } catch (_) {
        return const [];
      }
    }

    // One-time migration from legacy URL string list.
    final legacy = prefs.getStringList(_savedKey) ?? const <String>[];
    if (legacy.isEmpty) return const [];
    final migrated = legacy
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => SavedProfile.fromLink(e))
        .toList();
    await _writeProfiles(migrated);
    await prefs.remove(_savedKey);
    return List<SavedProfile>.unmodifiable(migrated);
  }

  @override
  Future<bool> pendingConnect() async {
    return (await _ready()).getBool(_pendingKey) ?? false;
  }

  @override
  Future<List<String>> excludeRoutes() async {
    final raw = (await _ready()).getStringList(_excludeKey) ?? const [];
    return List<String>.unmodifiable(
      MemorySessionStore.normalizeRoutes(raw),
    );
  }

  @override
  Future<void> saveLastShareLink(String link) async {
    await _writeProtected(_linkKey, link.trim());
  }

  @override
  Future<void> setAutoConnect(bool enabled) async {
    await (await _ready()).setBool(_autoKey, enabled);
  }

  @override
  Future<bool> smartConnect() async {
    return (await _ready()).getBool(_smartConnectKey) ?? false;
  }

  @override
  Future<void> setSmartConnect(bool enabled) async {
    await (await _ready()).setBool(_smartConnectKey, enabled);
  }

  @override
  Future<void> setPendingConnect(bool enabled) async {
    await (await _ready()).setBool(_pendingKey, enabled);
  }

  @override
  Future<void> setExcludeRoutes(List<String> routes) async {
    final next = MemorySessionStore.normalizeRoutes(routes);
    await (await _ready()).setStringList(_excludeKey, next);
  }

  @override
  Future<List<String>> disallowedPackages() async {
    final raw = (await _ready()).getStringList(_disallowedPackagesKey) ?? const [];
    return List<String>.unmodifiable(
      MemorySessionStore.normalizeRoutes(raw),
    );
  }

  @override
  Future<void> setDisallowedPackages(List<String> packages) async {
    final next = MemorySessionStore.normalizeRoutes(packages);
    await (await _ready()).setStringList(_disallowedPackagesKey, next);
  }

  @override
  Future<DateTime?> connectedAt() async {
    final ms = (await _ready()).getInt(_connectedAtKey);
    if (ms == null || ms <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }

  @override
  Future<void> setConnectedAt(DateTime? at) async {
    final prefs = await _ready();
    if (at == null) {
      await prefs.remove(_connectedAtKey);
      return;
    }
    await prefs.setInt(_connectedAtKey, at.toUtc().millisecondsSinceEpoch);
  }

  @override
  Future<List<SavedProfile>> addSavedProfile(String link, {String? name}) async {
    final trimmed = link.trim();
    if (trimmed.isEmpty) return savedProfiles();
    final existing = await savedProfiles();
    final existingMatch = existing.where((p) => p.link == trimmed).firstOrNull;
    final customName = name?.trim();
    final keptName = customName != null && customName.isNotEmpty
        ? customName
        : existingMatch?.name;
    final next = [
      existingMatch?.copyWith(name: keptName) ??
          SavedProfile.fromLink(trimmed, name: keptName),
      ...existing.where((p) => p.link != trimmed),
    ];
    final capped = next.length > _maxSaved ? next.sublist(0, _maxSaved) : next;
    await _writeProfiles(capped);
    return List<SavedProfile>.unmodifiable(capped);
  }

  @override
  Future<List<SavedProfile>> removeSavedProfile(String id) async {
    final next = (await savedProfiles()).where((p) => p.id != id).toList();
    await _writeProfiles(next);
    return List<SavedProfile>.unmodifiable(next);
  }

  @override
  Future<List<SavedProfile>> renameSavedProfile(String id, String name) async {
    return updateSavedProfile(id: id, name: name);
  }

  @override
  Future<List<SavedProfile>> updateSavedProfile({
    required String id,
    String? name,
    String? link,
  }) async {
    final profiles = [...await savedProfiles()];
    final i = profiles.indexWhere((p) => p.id == id);
    if (i < 0) return List<SavedProfile>.unmodifiable(profiles);
    final nextLink = link?.trim();
    profiles[i] = profiles[i].copyWith(
      name: name?.trim(),
      link: (nextLink == null || nextLink.isEmpty) ? null : nextLink,
    );
    await _writeProfiles(profiles);
    return List<SavedProfile>.unmodifiable(profiles);
  }

  @override
  Future<List<VpnSubscription>> subscriptions() async {
    final raw = await _readProtected(_subscriptionsKey);
    return List<VpnSubscription>.unmodifiable(VpnSubscription.decodeList(raw));
  }

  @override
  Future<List<VpnSubscription>> upsertSubscription(
    VpnSubscription subscription,
  ) async {
    final items = [...await subscriptions()];
    final byId = items.indexWhere((s) => s.id == subscription.id);
    if (byId >= 0) {
      items[byId] = subscription;
    } else {
      final byUrl = items.indexWhere((s) => s.url == subscription.url);
      if (byUrl >= 0) {
        items[byUrl] = subscription.withId(items[byUrl].id);
      } else {
        items.insert(0, subscription);
      }
    }
    await _writeSubscriptions(items);
    return List<VpnSubscription>.unmodifiable(items);
  }

  @override
  Future<({List<VpnSubscription> subscriptions, List<SavedProfile> profiles})>
      removeSubscription(String id) async {
    final items = (await subscriptions()).where((s) => s.id != id).toList();
    await _writeSubscriptions(items);
    final profiles =
        (await savedProfiles()).where((p) => p.subscriptionId != id).toList();
    await _writeProfiles(profiles);
    return (
      subscriptions: List<VpnSubscription>.unmodifiable(items),
      profiles: List<SavedProfile>.unmodifiable(profiles),
    );
  }

  @override
  Future<List<SavedProfile>> replaceSubscriptionNodes({
    required String subscriptionId,
    required List<SavedProfile> nodes,
  }) async {
    final capped = nodes.length > MemorySessionStore.maxPerSubscription
        ? nodes.sublist(0, MemorySessionStore.maxPerSubscription)
        : nodes;
    final kept = (await savedProfiles())
        .where((p) => p.subscriptionId != subscriptionId)
        .toList();
    var next = [...kept, ...capped];
    if (next.length > _maxSaved) next = next.sublist(0, _maxSaved);
    await _writeProfiles(next);
    return List<SavedProfile>.unmodifiable(next);
  }

  @override
  Future<({List<VpnSubscription> subscriptions, List<SavedProfile> profiles})>
      replaceCatalog({
    required List<VpnSubscription> subscriptions,
    required List<SavedProfile> profiles,
  }) async {
    final capped = profiles.length > _maxSaved
        ? profiles.sublist(0, _maxSaved)
        : profiles;
    await _writeSubscriptions(subscriptions);
    await _writeProfiles(capped);
    return (
      subscriptions: List<VpnSubscription>.unmodifiable(subscriptions),
      profiles: List<SavedProfile>.unmodifiable(capped),
    );
  }

  Future<void> _writeProfiles(List<SavedProfile> profiles) async {
    await _writeProtected(_profilesKey, SavedProfile.encodeList(profiles));
  }

  Future<void> _writeSubscriptions(List<VpnSubscription> items) async {
    await _writeProtected(_subscriptionsKey, VpnSubscription.encodeList(items));
  }

  Future<Uint8List?> _aesKey() async {
    if (_keyFailed) return null;
    if (_cachedKey != null) return _cachedKey;
    try {
      _cachedKey = await _keyStore.loadOrCreate();
      return _cachedKey;
    } catch (_) {
      _keyFailed = true;
      return null;
    }
  }

  Future<String?> _readProtected(String key) async {
    final raw = (await _ready()).getString(key);
    if (raw == null || raw.isEmpty) return null;
    final aes = await _aesKey();
    if (looksLikeAtRestEnvelope(raw)) {
      if (aes == null) return null;
      try {
        return openAtRest(aes, raw);
      } catch (_) {
        return null;
      }
    }
    if (aes != null) {
      await _writeProtected(key, raw);
    }
    return raw;
  }

  Future<void> _writeProtected(String key, String value) async {
    final aes = await _aesKey();
    if (aes == null) return;
    await (await _ready()).setString(key, sealAtRest(aes, value));
  }
}
