import '../../../session/saved_profile.dart';

class PingSample {
  const PingSample.ok(this.milliseconds) : failed = false;

  const PingSample.fail()
      : milliseconds = null,
        failed = true;

  final int? milliseconds;
  final bool failed;

  bool get isOk => !failed && milliseconds != null;

  @override
  bool operator ==(Object other) =>
      other is PingSample &&
      milliseconds == other.milliseconds &&
      failed == other.failed;

  @override
  int get hashCode => Object.hash(milliseconds, failed);
}

String pingLabel(PingSample? sample) {
  if (sample == null || !sample.isOk) return '—';
  return '${sample.milliseconds}ms';
}

/// Reachable first (fastest → slowest), then failed, then not pinged.
/// Ties keep the original list order.
List<SavedProfile> sortProfilesByPing(
  List<SavedProfile> profiles,
  Map<String, PingSample> pingById,
) {
  final indexed = [
    for (var i = 0; i < profiles.length; i++) (i, profiles[i]),
  ];
  int rank(SavedProfile profile) {
    final sample = pingById[profile.id];
    if (sample == null) return 2;
    if (!sample.isOk) return 1;
    return 0;
  }

  indexed.sort((a, b) {
    final ra = rank(a.$2);
    final rb = rank(b.$2);
    if (ra != rb) return ra.compareTo(rb);
    if (ra == 0) {
      return pingById[a.$2.id]!.milliseconds!.compareTo(
        pingById[b.$2.id]!.milliseconds!,
      );
    }
    return a.$1.compareTo(b.$1);
  });
  return [for (final item in indexed) item.$2];
}

/// Fastest reachable candidate, or null if nothing has a successful sample.
SavedProfile? pickLowestPingProfile(
  Iterable<SavedProfile> candidates,
  Map<String, PingSample> pingById,
) {
  SavedProfile? best;
  int? bestMs;
  for (final profile in candidates) {
    final sample = pingById[profile.id];
    if (sample == null || !sample.isOk) continue;
    final ms = sample.milliseconds!;
    if (bestMs == null || ms < bestMs) {
      best = profile;
      bestMs = ms;
    }
  }
  return best;
}

String formatUptime(Duration elapsed) {
  if (elapsed.isNegative) return '00:00';
  final hours = elapsed.inHours;
  final minutes = elapsed.inMinutes.remainder(60);
  final seconds = elapsed.inSeconds.remainder(60);
  if (hours > 0) {
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
