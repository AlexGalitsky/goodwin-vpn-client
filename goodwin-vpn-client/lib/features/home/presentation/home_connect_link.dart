import '../../../session/saved_profile.dart';

/// Share link Home will connect, without a URL editor on the page.
String? resolveHomeConnectLink({
  required List<SavedProfile> savedProfiles,
  required String? selectedProfileId,
  required String? activeShareLink,
}) {
  final selected = savedProfiles
      .where((p) => p.id == selectedProfileId)
      .firstOrNull;
  if (selected != null) return selected.link;
  final active = activeShareLink?.trim();
  if (active != null && active.isNotEmpty) return active;
  if (savedProfiles.isNotEmpty) return savedProfiles.first.link;
  return null;
}
