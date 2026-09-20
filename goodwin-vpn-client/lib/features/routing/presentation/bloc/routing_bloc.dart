import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/routing_models.dart';
import '../../domain/usecases/routing_use_cases.dart';

sealed class RoutingEvent {
  const RoutingEvent();
}

final class RoutingLoadRequested extends RoutingEvent {
  const RoutingLoadRequested();
}

final class RoutingModeChanged extends RoutingEvent {
  const RoutingModeChanged(this.mode);
  final RoutingMode mode;
}

final class RoutingPresetToggled extends RoutingEvent {
  const RoutingPresetToggled({required this.id, required this.enabled});
  final RoutingPresetId id;
  final bool enabled;
}

final class RoutingRuleAdded extends RoutingEvent {
  const RoutingRuleAdded({
    required this.matcher,
    this.action = RoutingAction.proxy,
  });
  final String matcher;
  final RoutingAction action;
}

final class RoutingRuleRemoved extends RoutingEvent {
  const RoutingRuleRemoved(this.id);
  final String id;
}

final class RoutingResetRequested extends RoutingEvent {
  const RoutingResetRequested();
}

final class RoutingClearActionError extends RoutingEvent {
  const RoutingClearActionError();
}

class RoutingState extends Equatable {
  const RoutingState({
    this.snapshot = const RoutingSnapshot(),
    this.loading = false,
    this.actionError,
  });

  final RoutingSnapshot snapshot;
  final bool loading;
  final Object? actionError;

  RoutingState copyWith({
    RoutingSnapshot? snapshot,
    bool? loading,
    Object? actionError,
    bool clearActionError = false,
  }) {
    return RoutingState(
      snapshot: snapshot ?? this.snapshot,
      loading: loading ?? this.loading,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props => [snapshot, loading, actionError];
}

class RoutingBloc extends Bloc<RoutingEvent, RoutingState> {
  RoutingBloc({
    required LoadRoutingSnapshotUseCase loadRouting,
    required SetRoutingModeUseCase setMode,
    required SetRoutingPresetUseCase setPreset,
    required AddRoutingRuleUseCase addRule,
    required RemoveRoutingRuleUseCase removeRule,
    required ResetRoutingUseCase resetRouting,
  })  : _loadRouting = loadRouting,
        _setMode = setMode,
        _setPreset = setPreset,
        _addRule = addRule,
        _removeRule = removeRule,
        _resetRouting = resetRouting,
        super(const RoutingState()) {
    on<RoutingLoadRequested>(_onLoad, transformer: droppable());
    on<RoutingModeChanged>(_onMode, transformer: sequential());
    on<RoutingPresetToggled>(_onPreset, transformer: sequential());
    on<RoutingRuleAdded>(_onAddRule, transformer: sequential());
    on<RoutingRuleRemoved>(_onRemoveRule, transformer: sequential());
    on<RoutingResetRequested>(_onReset, transformer: sequential());
    on<RoutingClearActionError>((event, emit) {
      emit(state.copyWith(clearActionError: true));
    });
  }

  final LoadRoutingSnapshotUseCase _loadRouting;
  final SetRoutingModeUseCase _setMode;
  final SetRoutingPresetUseCase _setPreset;
  final AddRoutingRuleUseCase _addRule;
  final RemoveRoutingRuleUseCase _removeRule;
  final ResetRoutingUseCase _resetRouting;

  Future<void> _onLoad(
    RoutingLoadRequested event,
    Emitter<RoutingState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearActionError: true));
    try {
      final snapshot = await _loadRouting();
      emit(state.copyWith(loading: false, snapshot: snapshot));
    } catch (error) {
      emit(state.copyWith(loading: false, actionError: error));
    }
  }

  Future<void> _onMode(
    RoutingModeChanged event,
    Emitter<RoutingState> emit,
  ) async {
    try {
      final snapshot = await _setMode(event.mode);
      emit(state.copyWith(snapshot: snapshot, clearActionError: true));
    } catch (error) {
      emit(state.copyWith(actionError: error));
    }
  }

  Future<void> _onPreset(
    RoutingPresetToggled event,
    Emitter<RoutingState> emit,
  ) async {
    try {
      final snapshot = await _setPreset(id: event.id, enabled: event.enabled);
      emit(state.copyWith(snapshot: snapshot, clearActionError: true));
    } catch (error) {
      emit(state.copyWith(actionError: error));
    }
  }

  Future<void> _onAddRule(
    RoutingRuleAdded event,
    Emitter<RoutingState> emit,
  ) async {
    try {
      final snapshot = await _addRule(
        matcher: event.matcher,
        action: event.action,
      );
      emit(state.copyWith(snapshot: snapshot, clearActionError: true));
    } catch (error) {
      emit(state.copyWith(actionError: error));
    }
  }

  Future<void> _onRemoveRule(
    RoutingRuleRemoved event,
    Emitter<RoutingState> emit,
  ) async {
    try {
      final snapshot = await _removeRule(event.id);
      emit(state.copyWith(snapshot: snapshot, clearActionError: true));
    } catch (error) {
      emit(state.copyWith(actionError: error));
    }
  }

  Future<void> _onReset(
    RoutingResetRequested event,
    Emitter<RoutingState> emit,
  ) async {
    await _resetRouting();
    emit(const RoutingState());
  }
}
