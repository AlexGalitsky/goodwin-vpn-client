import 'saved_profile.dart';
import 'subscription.dart';

/// Last share link, opt-in auto-connect, named saved profiles, exclude routes.
/// Does not store OS VPN liveness.
abstract interface class SessionStore {
  Future<String?> lastShareLink();

  Future<bool> autoConnect();

  Future<List<SavedProfile>> savedProfiles();

  /// After a forced process restart to switch Go SOCKS cores.
  Future<bool> pendingConnect();

  /// CIDR/IP list for Windows TUN / TT exclusions (P-U2).
  Future<List<String>> excludeRoutes();

  Future<void> saveLastShareLink(String link);

  Future<void> setAutoConnect(bool enabled);

  Future<bool> smartConnect();

  Future<void> setSmartConnect(bool enabled);

  Future<void> setPendingConnect(bool enabled);

  Future<void> setExcludeRoutes(List<String> routes);

  /// Android package names that skip the TUN (per-app split).
  Future<List<String>> disallowedPackages();

  Future<void> setDisallowedPackages(List<String> packages);

  /// Wall-clock start of the current connected session (survives process death).
  Future<DateTime?> connectedAt();

  Future<void> setConnectedAt(DateTime? at);

  /// Inserts at the front; dedupes by link; keeps a bounded list.
  Future<List<SavedProfile>> addSavedProfile(String link, {String? name});

  Future<List<SavedProfile>> removeSavedProfile(String id);

  Future<List<SavedProfile>> renameSavedProfile(String id, String name);

  Future<List<SavedProfile>> updateSavedProfile({
    required String id,
    String? name,
    String? link,
  });

  Future<List<VpnSubscription>> subscriptions();

  Future<List<VpnSubscription>> upsertSubscription(VpnSubscription subscription);

  /// Removes the subscription and every node that belongs to it.
  Future<({List<VpnSubscription> subscriptions, List<SavedProfile> profiles})>
      removeSubscription(String id);

  Future<List<SavedProfile>> replaceSubscriptionNodes({
    required String subscriptionId,
    required List<SavedProfile> nodes,
  });

  /// Replaces the whole catalog (backup restore). Caps profiles at [maxSaved].
  Future<({List<VpnSubscription> subscriptions, List<SavedProfile> profiles})>
      replaceCatalog({
    required List<VpnSubscription> subscriptions,
    required List<SavedProfile> profiles,
  });
}

extension SessionStoreLinks on SessionStore {
  Future<List<String>> savedShareLinks() async =>
      (await savedProfiles()).map((p) => p.link).toList(growable: false);

  Future<List<String>> addSavedShareLink(String link) async =>
      (await addSavedProfile(link)).map((p) => p.link).toList(growable: false);

  Future<List<String>> removeSavedShareLink(String link) async {
    final profiles = await savedProfiles();
    final match = profiles.where((p) => p.link == link.trim()).toList();
    if (match.isEmpty) {
      return profiles.map((p) => p.link).toList(growable: false);
    }
    return (await removeSavedProfile(match.first.id))
        .map((p) => p.link)
        .toList(growable: false);
  }
}

class MemorySessionStore implements SessionStore {
  MemorySessionStore({
    this.lastShareLinkValue,
    this.autoConnectValue = false,
    this.smartConnectValue = false,
    this.pendingConnectValue = false,
    List<SavedProfile>? savedProfilesValue,
    List<String>? excludeRoutesValue,
    List<String>? disallowedPackagesValue,
    List<VpnSubscription>? subscriptionsValue,
    this.connectedAtValue,
  })  : savedProfilesValue =
            List<SavedProfile>.from(savedProfilesValue ?? const []),
        excludeRoutesValue =
            List<String>.from(excludeRoutesValue ?? const []),
        disallowedPackagesValue =
            List<String>.from(disallowedPackagesValue ?? const []),
        subscriptionsValue =
            List<VpnSubscription>.from(subscriptionsValue ?? const []);

  String? lastShareLinkValue;
  bool autoConnectValue;
  bool smartConnectValue;
  bool pendingConnectValue;
  DateTime? connectedAtValue;
  List<SavedProfile> savedProfilesValue;
  List<String> excludeRoutesValue;
  List<String> disallowedPackagesValue;
  List<VpnSubscription> subscriptionsValue;

  static const maxSaved = 128;
  static const maxPerSubscription = 64;

  @override
  Future<String?> lastShareLink() async => lastShareLinkValue;

  @override
  Future<bool> autoConnect() async => autoConnectValue;

  @override
  Future<List<SavedProfile>> savedProfiles() async =>
      List<SavedProfile>.unmodifiable(savedProfilesValue);

  @override
  Future<bool> pendingConnect() async => pendingConnectValue;

  @override
  Future<List<String>> excludeRoutes() async =>
      List<String>.unmodifiable(excludeRoutesValue);

  @override
  Future<void> saveLastShareLink(String link) async {
    lastShareLinkValue = link.trim();
  }

  @override
  Future<void> setAutoConnect(bool enabled) async {
    autoConnectValue = enabled;
  }

  @override
  Future<bool> smartConnect() async => smartConnectValue;

  @override
  Future<void> setSmartConnect(bool enabled) async {
    smartConnectValue = enabled;
  }

  @override
  Future<void> setPendingConnect(bool enabled) async {
    pendingConnectValue = enabled;
  }

  @override
  Future<void> setExcludeRoutes(List<String> routes) async {
    excludeRoutesValue = normalizeRoutes(routes);
  }

  @override
  Future<List<String>> disallowedPackages() async =>
      List<String>.unmodifiable(disallowedPackagesValue);

  @override
  Future<void> setDisallowedPackages(List<String> packages) async {
    disallowedPackagesValue = normalizeRoutes(packages);
  }

  @override
  Future<DateTime?> connectedAt() async => connectedAtValue;

  @override
  Future<void> setConnectedAt(DateTime? at) async {
    connectedAtValue = at?.toUtc();
  }

  @override
  Future<List<SavedProfile>> addSavedProfile(String link, {String? name}) async {
    final trimmed = link.trim();
    if (trimmed.isEmpty) return savedProfiles();
    final existingMatch =
        savedProfilesValue.where((p) => p.link == trimmed).firstOrNull;
    savedProfilesValue.removeWhere((p) => p.link == trimmed);
    final customName = name?.trim();
    savedProfilesValue.insert(
      0,
      existingMatch?.copyWith(
            name: (customName != null && customName.isNotEmpty)
                ? customName
                : existingMatch.name,
          ) ??
          SavedProfile.fromLink(trimmed, name: name),
    );
    if (savedProfilesValue.length > maxSaved) {
      savedProfilesValue = savedProfilesValue.sublist(0, maxSaved);
    }
    return savedProfiles();
  }

  @override
  Future<List<SavedProfile>> removeSavedProfile(String id) async {
    savedProfilesValue.removeWhere((p) => p.id == id);
    return savedProfiles();
  }

  @override
  Future<List<SavedProfile>> renameSavedProfile(String id, String name) async {
    final i = savedProfilesValue.indexWhere((p) => p.id == id);
    if (i < 0) return savedProfiles();
    savedProfilesValue[i] = savedProfilesValue[i].copyWith(name: name.trim());
    return savedProfiles();
  }

  @override
  Future<List<SavedProfile>> updateSavedProfile({
    required String id,
    String? name,
    String? link,
  }) async {
    final i = savedProfilesValue.indexWhere((p) => p.id == id);
    if (i < 0) return savedProfiles();
    final nextLink = link?.trim();
    savedProfilesValue[i] = savedProfilesValue[i].copyWith(
      name: name?.trim(),
      link: (nextLink == null || nextLink.isEmpty) ? null : nextLink,
    );
    return savedProfiles();
  }

  @override
  Future<List<VpnSubscription>> subscriptions() async =>
      List<VpnSubscription>.unmodifiable(subscriptionsValue);

  @override
  Future<List<VpnSubscription>> upsertSubscription(
    VpnSubscription subscription,
  ) async {
    final i = subscriptionsValue.indexWhere((s) => s.id == subscription.id);
    if (i >= 0) {
      subscriptionsValue[i] = subscription;
    } else {
      final byUrl =
          subscriptionsValue.indexWhere((s) => s.url == subscription.url);
      if (byUrl >= 0) {
        subscriptionsValue[byUrl] =
            subscription.withId(subscriptionsValue[byUrl].id);
      } else {
        subscriptionsValue = [subscription, ...subscriptionsValue];
      }
    }
    return subscriptions();
  }

  @override
  Future<({List<VpnSubscription> subscriptions, List<SavedProfile> profiles})>
      removeSubscription(String id) async {
    subscriptionsValue.removeWhere((s) => s.id == id);
    savedProfilesValue.removeWhere((p) => p.subscriptionId == id);
    return (subscriptions: await subscriptions(), profiles: await savedProfiles());
  }

  @override
  Future<List<SavedProfile>> replaceSubscriptionNodes({
    required String subscriptionId,
    required List<SavedProfile> nodes,
  }) async {
    final capped = nodes.length > maxPerSubscription
        ? nodes.sublist(0, maxPerSubscription)
        : nodes;
    final kept =
        savedProfilesValue.where((p) => p.subscriptionId != subscriptionId);
    savedProfilesValue = [...kept, ...capped];
    if (savedProfilesValue.length > maxSaved) {
      savedProfilesValue = savedProfilesValue.sublist(0, maxSaved);
    }
    return savedProfiles();
  }

  @override
  Future<({List<VpnSubscription> subscriptions, List<SavedProfile> profiles})>
      replaceCatalog({
    required List<VpnSubscription> subscriptions,
    required List<SavedProfile> profiles,
  }) async {
    subscriptionsValue = List<VpnSubscription>.from(subscriptions);
    savedProfilesValue = profiles.length > maxSaved
        ? List<SavedProfile>.from(profiles.take(maxSaved))
        : List<SavedProfile>.from(profiles);
    return (
      subscriptions: await this.subscriptions(),
      profiles: await savedProfiles(),
    );
  }

  static List<String> normalizeRoutes(List<String> routes) {
    final seen = <String>{};
    final out = <String>[];
    for (final raw in routes) {
      final value = raw.trim();
      if (value.isEmpty || !seen.add(value)) continue;
      out.add(value);
    }
    return out;
  }
}

List<String> normalizeExcludeRoutes(List<String> routes) =>
    MemorySessionStore.normalizeRoutes(routes);
