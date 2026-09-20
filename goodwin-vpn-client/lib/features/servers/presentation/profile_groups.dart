import '../../../session/saved_profile.dart';
import '../../../session/subscription.dart';
import '../../connection/domain/ping_sample.dart';

class ProfileGroup {
  const ProfileGroup({this.subscription, required this.nodes});

  final VpnSubscription? subscription;
  final List<SavedProfile> nodes;

  bool get isManual => subscription == null;

  /// Stable id for collapse prefs (`manual` or subscription id).
  String get collapseId =>
      subscription?.id ?? 'manual';
}

List<ProfileGroup> groupProfiles({
  required List<SavedProfile> profiles,
  required List<VpnSubscription> subscriptions,
  String query = '',
  Map<String, PingSample> pingById = const {},
}) {
  final q = query.trim().toLowerCase();
  bool matches(SavedProfile p) {
    if (q.isEmpty) return true;
    return p.name.toLowerCase().contains(q) ||
        p.link.toLowerCase().contains(q);
  }

  final bySub = <String, List<SavedProfile>>{};
  final manual = <SavedProfile>[];
  for (final profile in profiles) {
    if (!matches(profile)) continue;
    final subId = profile.subscriptionId;
    if (subId == null || subId.isEmpty) {
      manual.add(profile);
    } else {
      bySub.putIfAbsent(subId, () => []).add(profile);
    }
  }

  final groups = <ProfileGroup>[];
  if (manual.isNotEmpty) {
    groups.add(
      ProfileGroup(nodes: sortProfilesByPing(manual, pingById)),
    );
  }
  for (final sub in subscriptions) {
    final nodes = bySub.remove(sub.id);
    if (nodes == null || nodes.isEmpty) continue;
    groups.add(
      ProfileGroup(
        subscription: sub,
        nodes: sortProfilesByPing(nodes, pingById),
      ),
    );
  }
  for (final leftover in bySub.values) {
    if (leftover.isEmpty) continue;
    groups.add(
      ProfileGroup(nodes: sortProfilesByPing(leftover, pingById)),
    );
  }
  return groups;
}
