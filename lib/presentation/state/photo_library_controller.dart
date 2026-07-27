import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/models/photo_library.dart';
import '../../application/use_cases/scan_media_library.dart';
import '../../domain/value_objects/operation_result.dart';
import 'app_providers.dart';
import 'photo_library_actions.dart';
import 'photo_library_state.dart';

final photoLibraryProvider =
    NotifierProvider<PhotoLibraryController, PhotoLibraryState>(
      PhotoLibraryController.new,
    );

final photoThumbnailProvider = FutureProvider.autoDispose
    .family<Uint8List?, String>((ref, assetId) {
      final actions = ref.watch(photoLibraryActionsProvider);
      return actions.loadThumbnail(assetId, size: 220);
    });

class PhotoLibraryController extends Notifier<PhotoLibraryState> {
  late final PhotoLibraryActions _actions;

  @override
  PhotoLibraryState build() {
    _actions = ref.watch(photoLibraryActionsProvider);
    unawaited(Future<void>.microtask(load));
    return const PhotoLibraryState.initial();
  }

  Future<void> load() async {
    state = state.copyWith(phase: PhotoLibraryPhase.loading, clearError: true);
    await _loadIntoState(phase: PhotoLibraryPhase.loaded);
  }

  Future<void> refreshNow() async {
    if (state.isBusy) {
      return;
    }

    state = state.copyWith(
      phase: PhotoLibraryPhase.refreshing,
      foundPhotos: 0,
      indexedPhotos: 0,
      sourceCount: 0,
      clearError: true,
    );

    final result = await _actions.refreshLibrary(
      pageSize: 100,
      onProgress: _applyProgress,
    );
    switch (result) {
      case OperationSuccess<LibraryScanResult>():
        await _loadIntoState(phase: PhotoLibraryPhase.loaded);
      case OperationFailure<LibraryScanResult>(failure: final failure):
        state = state.copyWith(
          phase: PhotoLibraryPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }

  void _applyProgress(ScanProgress progress) {
    if (state.phase != PhotoLibraryPhase.refreshing) {
      return;
    }

    state = state.copyWith(
      foundPhotos: progress.foundPhotos,
      indexedPhotos: progress.writtenPhotos,
      sourceCount: progress.sourceCount,
    );
  }

  void selectCategory(LibraryCategory? category) {
    state = state.copyWith(
      selectedCategory: category,
      clearCategory: category == null,
    );
  }

  Future<void> _loadIntoState({required PhotoLibraryPhase phase}) async {
    final result = await _actions.listPhotos();
    switch (result) {
      case OperationSuccess<PhotoLibrary>(value: final value):
        state = state.copyWith(phase: phase, library: value, clearError: true);
      case OperationFailure<PhotoLibrary>(failure: final failure):
        state = state.copyWith(
          phase: PhotoLibraryPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }
}
