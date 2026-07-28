import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/models/library_category.dart';
import '../../application/models/source_selection.dart';
import '../../domain/value_objects/operation_result.dart';
import 'app_providers.dart';
import 'source_selection_actions.dart';
import 'source_selection_state.dart';

final sourceSelectionProvider =
    NotifierProvider<SourceSelectionController, SourceSelectionState>(
      SourceSelectionController.new,
    );

class SourceSelectionController extends Notifier<SourceSelectionState> {
  late final SourceSelectionActions _actions;

  @override
  SourceSelectionState build() {
    _actions = ref.watch(sourceSelectionActionsProvider);
    unawaited(Future<void>.microtask(load));
    return const SourceSelectionState.initial();
  }

  Future<void> load() async {
    state = state.copyWith(
      phase: SourceSelectionPhase.loading,
      clearError: true,
    );
    await _reload(phase: SourceSelectionPhase.loaded);
  }

  Future<void> setCategory(
    LibraryCategory category, {
    required bool enabled,
  }) async {
    final optimisticSettings = state.selection.settings.withCategory(
      category,
      enabled: enabled,
    );
    _applySettings(optimisticSettings);

    final result = await _actions.setCategory(category, enabled: enabled);
    await _applyResult(result);
  }

  Future<void> setSource(String sourceId, {required bool enabled}) async {
    final optimisticSettings = state.selection.settings.withSource(
      sourceId,
      enabled: enabled,
    );
    _applySettings(optimisticSettings);

    final result = await _actions.setSource(sourceId, enabled: enabled);
    await _applyResult(result);
  }

  Future<void> _applyResult(
    OperationResult<SourceSelectionSettings> result,
  ) async {
    switch (result) {
      case OperationSuccess<SourceSelectionSettings>():
        await _reload(phase: SourceSelectionPhase.loaded);
      case OperationFailure<SourceSelectionSettings>(failure: final failure):
        state = state.copyWith(
          phase: SourceSelectionPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }

  Future<void> _reload({required SourceSelectionPhase phase}) async {
    final result = await _actions.listSources();
    switch (result) {
      case OperationSuccess<MediaSourceSelection>(value: final value):
        state = state.copyWith(
          phase: phase,
          selection: value,
          clearError: true,
        );
      case OperationFailure<MediaSourceSelection>(failure: final failure):
        state = state.copyWith(
          phase: SourceSelectionPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }

  void _applySettings(SourceSelectionSettings settings) {
    state = state.copyWith(
      phase: SourceSelectionPhase.loaded,
      selection: buildMediaSourceSelection(
        sources: [
          for (final group in state.selection.groups)
            for (final source in group.sources) source.source,
        ],
        settings: settings,
      ),
      clearError: true,
    );
  }
}
