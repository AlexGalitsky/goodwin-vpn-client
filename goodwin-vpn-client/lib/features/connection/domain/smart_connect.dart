import '../../../session/saved_profile.dart';
import 'ping_sample.dart';

/// Profile Home would connect before Smart connect rewrites the node.
SavedProfile? anchorProfileForConnect({
  required List<SavedProfile> savedProfiles,
  required String? selectedProfileId,
  required String? activeShareLink,
}) {
  final selected =
      savedProfiles.where((p) => p.id == selectedProfileId).firstOrNull;
  if (selected != null) return selected;
  final link = activeShareLink?.trim();
  if (link != null && link.isNotEmpty) {
    final byLink = savedProfiles.where((p) => p.link == link).firstOrNull;
    if (byLink != null) return byLink;
  }
  return savedProfiles.firstOrNull;
}

/// Other saved nodes that share [anchor]'s subscription.
List<SavedProfile> subscriptionPeers({
  required SavedProfile? anchor,
  required List<SavedProfile> savedProfiles,
}) {
  final subId = anchor?.subscriptionId;
  if (subId == null || subId.isEmpty) return const [];
  return [
    for (final profile in savedProfiles)
      if (profile.subscriptionId == subId) profile,
  ];
}

/// Lowest-ping peer in the anchor's subscription, or null to keep the default.
SavedProfile? resolveSmartConnectProfile({
  required List<SavedProfile> savedProfiles,
  required String? selectedProfileId,
  required String? activeShareLink,
  required Map<String, PingSample> pingById,
}) {
  final anchor = anchorProfileForConnect(
    savedProfiles: savedProfiles,
    selectedProfileId: selectedProfileId,
    activeShareLink: activeShareLink,
  );
  final peers = subscriptionPeers(
    anchor: anchor,
    savedProfiles: savedProfiles,
  );
  if (peers.length < 2) return null;
  return pickLowestPingProfile(peers, pingById);
}
