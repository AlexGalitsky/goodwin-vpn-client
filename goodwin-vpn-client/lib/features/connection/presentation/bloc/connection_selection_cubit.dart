import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../session/saved_profile.dart';
import '../../domain/node_endpoint.dart';
import '../../domain/ping_sample.dart';
import '../../domain/tcp_latency_probe.dart';

class ConnectionSelectionState extends Equatable {
  const ConnectionSelectionState({
    this.selectedProfileId,
    this.pingByProfileId = const {},
    this.pingingIds = const {},
    this.pinging = false,
  });

  final String? selectedProfileId;
  final Map<String, PingSample> pingByProfileId;
  final Set<String> pingingIds;
  final bool pinging;

  ConnectionSelectionState copyWith({
    String? selectedProfileId,
    Map<String, PingSample>? pingByProfileId,
    Set<String>? pingingIds,
    bool? pinging,
    bool clearSelected = false,
  }) {
    return ConnectionSelectionState(
      selectedProfileId:
          clearSelected ? null : (selectedProfileId ?? this.selectedProfileId),
      pingByProfileId: pingByProfileId ?? this.pingByProfileId,
      pingingIds: pingingIds ?? this.pingingIds,
      pinging: pinging ?? this.pinging,
    );
  }

  @override
  List<Object?> get props =>
      [selectedProfileId, pingByProfileId, pingingIds, pinging];
}

/// Selected saved profile + live TCP ping samples.
class ConnectionSelectionCubit extends Cubit<ConnectionSelectionState> {
  ConnectionSelectionCubit({LatencyProbe? probe})
      : _probe = probe ?? const TcpLatencyProbe(),
        super(const ConnectionSelectionState());

  final LatencyProbe _probe;
  static const _batchSize = 5;

  void selectProfile(String profileId) {
    emit(state.copyWith(selectedProfileId: profileId));
  }

  void selectMatchingLink(List<SavedProfile> profiles, String? shareLink) {
    final link = shareLink?.trim();
    if (link == null || link.isEmpty) return;
    final match = profiles.where((p) => p.link == link).firstOrNull;
    if (match != null) selectProfile(match.id);
  }

  void clearSelection() {
    emit(state.copyWith(clearSelected: true));
  }

  Future<void> pingProfiles(Iterable<SavedProfile> profiles) async {
    if (state.pinging) return;
    final list = profiles.toList(growable: false);
    if (list.isEmpty) return;
    emit(
      state.copyWith(
        pinging: true,
        pingingIds: {for (final p in list) p.id},
      ),
    );
    for (var i = 0; i < list.length && !isClosed; i += _batchSize) {
      final end = (i + _batchSize).clamp(0, list.length);
      await Future.wait([
        for (final profile in list.sublist(i, end)) _pingOne(profile),
      ]);
    }
    if (!isClosed) {
      emit(state.copyWith(pinging: false, pingingIds: const {}));
    }
  }

  Future<void> _pingOne(SavedProfile profile) async {
    final endpoint = endpointForShareLink(profile.link);
    final ms = endpoint == null ? null : await _probe.measure(endpoint);
    if (isClosed) return;
    final next = Map<String, PingSample>.from(state.pingByProfileId);
    next[profile.id] =
        ms == null ? const PingSample.fail() : PingSample.ok(ms);
    final remaining = Set<String>.from(state.pingingIds)..remove(profile.id);
    emit(state.copyWith(pingByProfileId: next, pingingIds: remaining));
  }

  void reset() => emit(const ConnectionSelectionState());
}
