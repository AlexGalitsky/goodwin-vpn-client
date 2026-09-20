import 'saved_profile.dart';
import 'subscription.dart';

enum ConnectionPhase { idle, connecting, connected, disconnecting, error }

class VpnConnectionState {
  const VpnConnectionState({
    required this.phase,
    this.message = '',
    this.logs = const [],
    this.coreVersion,
    this.autoConnect = false,
    this.smartConnect = false,
    this.savedProfiles = const [],
    this.excludeRoutes = const [],
    this.disallowedPackages = const [],
    this.elevationRequired = false,
    this.activeShareLink,
    this.connectedAt,
    this.subscriptions = const [],
  });

  final ConnectionPhase phase;
  final String message;
  final List<String> logs;
  final String? coreVersion;
  final bool autoConnect;

  /// Home Connect picks the lowest-ping node in the current subscription.
  final bool smartConnect;
  final List<SavedProfile> savedProfiles;
  final List<String> excludeRoutes;
  final List<String> disallowedPackages;

  /// Windows: user must approve UAC / relaunch as admin for system TUN.
  final bool elevationRequired;

  /// Last connected / restored share link (for routing capability UI).
  final String? activeShareLink;

  /// When the current session entered [ConnectionPhase.connected].
  final DateTime? connectedAt;

  final List<VpnSubscription> subscriptions;

  /// Legacy convenience for tests / call sites that only need URLs.
  List<String> get savedLinks =>
      savedProfiles.map((p) => p.link).toList(growable: false);

  VpnConnectionState copyWith({
    ConnectionPhase? phase,
    String? message,
    List<String>? logs,
    String? coreVersion,
    bool? autoConnect,
    bool? smartConnect,
    List<SavedProfile>? savedProfiles,
    List<String>? excludeRoutes,
    List<String>? disallowedPackages,
    bool? elevationRequired,
    String? activeShareLink,
    DateTime? connectedAt,
    List<VpnSubscription>? subscriptions,
    bool clearActiveShareLink = false,
    bool clearConnectedAt = false,
  }) {
    return VpnConnectionState(
      phase: phase ?? this.phase,
      message: message ?? this.message,
      logs: logs ?? this.logs,
      coreVersion: coreVersion ?? this.coreVersion,
      autoConnect: autoConnect ?? this.autoConnect,
      smartConnect: smartConnect ?? this.smartConnect,
      savedProfiles: savedProfiles ?? this.savedProfiles,
      excludeRoutes: excludeRoutes ?? this.excludeRoutes,
      disallowedPackages: disallowedPackages ?? this.disallowedPackages,
      elevationRequired: elevationRequired ?? this.elevationRequired,
      activeShareLink: clearActiveShareLink
          ? null
          : (activeShareLink ?? this.activeShareLink),
      connectedAt:
          clearConnectedAt ? null : (connectedAt ?? this.connectedAt),
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }
}
