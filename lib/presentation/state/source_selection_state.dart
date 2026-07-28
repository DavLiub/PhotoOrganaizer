import '../../application/models/source_selection.dart';

enum SourceSelectionPhase { loading, loaded, failure }

class SourceSelectionState {
  const SourceSelectionState({
    required this.phase,
    required this.selection,
    this.errorCode,
  });

  const SourceSelectionState.initial()
    : this(
        phase: SourceSelectionPhase.loading,
        selection: const MediaSourceSelection.empty(),
      );

  final SourceSelectionPhase phase;
  final MediaSourceSelection selection;
  final String? errorCode;

  bool get isLoading {
    return phase == SourceSelectionPhase.loading;
  }

  SourceSelectionState copyWith({
    SourceSelectionPhase? phase,
    MediaSourceSelection? selection,
    String? errorCode,
    bool clearError = false,
  }) {
    return SourceSelectionState(
      phase: phase ?? this.phase,
      selection: selection ?? this.selection,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }
}
