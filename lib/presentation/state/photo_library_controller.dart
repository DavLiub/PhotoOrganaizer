import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/models/photo_library.dart';
import '../../application/models/scan_signal.dart';
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
  ScanSignal? _scanSignal;
  bool _scanRunning = false;
  bool _reloadRunning = false;
  bool _reloadPending = false;
  int _baseFound = 0;
  int _baseIndexed = 0;
  int _baseSources = 0;
  int _newIndexed = 0;

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
    await scanNow();
  }

  Future<OperationResult<LibraryScanResult>> scanNow({
    ScanProgressCallback? onProgress,
  }) async {
    if (_scanRunning) {
      return OperationFailure(
        kind: FailureKind.validation,
        code: 'media_scan.already_running',
        safeMessage: 'Photo scan is already running.',
      );
    }

    final signal = ScanSignal();
    _scanSignal = signal;
    _scanRunning = true;
    _baseFound = state.library.photos.length;
    _baseIndexed = state.library.photos.length;
    _baseSources = state.sourceCount;
    _newIndexed = 0;

    state = state.copyWith(
      phase: PhotoLibraryPhase.refreshing,
      foundPhotos: _baseFound,
      indexedPhotos: _baseIndexed,
      sourceCount: _baseSources,
      clearError: true,
    );

    final result = await _actions.refreshLibrary(
      pageSize: 100,
      signal: signal,
      onProgress: (progress) {
        final displayProgress = _applyProgress(progress);
        onProgress?.call(displayProgress);
      },
    );
    _scanSignal = null;
    _scanRunning = false;

    switch (result) {
      case OperationSuccess<LibraryScanResult>():
        await _loadIntoState(phase: PhotoLibraryPhase.loaded);
      case OperationFailure<LibraryScanResult>(failure: final failure):
        if (failure.kind == FailureKind.cancelled) {
          await _loadIntoState(phase: PhotoLibraryPhase.loaded);
        } else {
          state = state.copyWith(
            phase: PhotoLibraryPhase.failure,
            errorCode: failure.safeMessage ?? failure.code,
          );
        }
    }

    return result;
  }

  void stopScan() {
    _scanSignal?.stop();
  }

  ScanProgress _applyProgress(ScanProgress progress) {
    if (!_scanRunning) {
      return progress;
    }

    final nextProgress = _displayProgress(progress);
    final previousWritten = state.indexedPhotos;
    final hasNewIndex = progress.indexedPhotos > _newIndexed;
    _newIndexed = progress.indexedPhotos;
    state = state.copyWith(
      phase: PhotoLibraryPhase.refreshing,
      foundPhotos: nextProgress.foundPhotos,
      indexedPhotos: nextProgress.writtenPhotos,
      sourceCount: nextProgress.sourceCount,
    );

    if (hasNewIndex || nextProgress.writtenPhotos > previousWritten) {
      _queueReload();
    }

    return nextProgress;
  }

  ScanProgress _displayProgress(ScanProgress progress) {
    final foundPhotos = progress.foundPhotos > _baseFound
        ? progress.foundPhotos
        : _baseFound;
    final writtenPhotos = progress.writtenPhotos > _baseIndexed
        ? progress.writtenPhotos
        : _baseIndexed;
    final indexedPhotos = progress.indexedPhotos > writtenPhotos
        ? progress.indexedPhotos
        : writtenPhotos;
    final sourceCount = progress.sourceCount > _baseSources
        ? progress.sourceCount
        : _baseSources;

    return progress.copyWith(
      foundPhotos: foundPhotos,
      indexedPhotos: indexedPhotos,
      updatedPhotos: 0,
      sourceCount: sourceCount,
    );
  }

  void selectCategory(LibraryCategory? category) {
    state = state.copyWith(filter: _filterForCategory(category));
  }

  void selectFilter(LibraryFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void selectSort(LibrarySort sort) {
    state = state.copyWith(sort: sort);
  }

  Future<void> _loadIntoState({required PhotoLibraryPhase phase}) async {
    final result = await _actions.listPhotos();
    switch (result) {
      case OperationSuccess<PhotoLibrary>(value: final value):
        final loadedCount = value.photos.length;
        final foundPhotos = loadedCount > state.foundPhotos
            ? loadedCount
            : state.foundPhotos;
        final indexedPhotos = loadedCount > state.indexedPhotos
            ? loadedCount
            : state.indexedPhotos;
        final nextPhase = switch ((_scanRunning, phase)) {
          (true, PhotoLibraryPhase.loaded) => PhotoLibraryPhase.refreshing,
          (false, PhotoLibraryPhase.refreshing) => PhotoLibraryPhase.loaded,
          _ => phase,
        };
        state = state.copyWith(
          phase: nextPhase,
          library: value,
          foundPhotos: foundPhotos,
          indexedPhotos: indexedPhotos,
          clearError: true,
        );
      case OperationFailure<PhotoLibrary>(failure: final failure):
        state = state.copyWith(
          phase: PhotoLibraryPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }

  void _queueReload() {
    if (_reloadRunning) {
      _reloadPending = true;
      return;
    }

    unawaited(_reloadLoop());
  }

  Future<void> _reloadLoop() async {
    _reloadRunning = true;

    do {
      _reloadPending = false;
      await _loadIntoState(phase: PhotoLibraryPhase.refreshing);
    } while (_reloadPending);

    _reloadRunning = false;
  }
}

LibraryFilter _filterForCategory(LibraryCategory? category) {
  return switch (category) {
    null => LibraryFilter.all,
    LibraryCategory.camera => LibraryFilter.camera,
    LibraryCategory.social => LibraryFilter.social,
    LibraryCategory.downloads => LibraryFilter.downloads,
    LibraryCategory.screenshots => LibraryFilter.screenshots,
  };
}
