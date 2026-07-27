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

    state = state.copyWith(
      phase: PhotoLibraryPhase.refreshing,
      foundPhotos: 0,
      indexedPhotos: 0,
      sourceCount: 0,
      clearError: true,
    );

    final result = await _actions.refreshLibrary(
      pageSize: 100,
      signal: signal,
      onProgress: (progress) {
        _applyProgress(progress);
        onProgress?.call(progress);
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

  void _applyProgress(ScanProgress progress) {
    if (!_scanRunning) {
      return;
    }

    final previousWritten = state.indexedPhotos;
    state = state.copyWith(
      phase: PhotoLibraryPhase.refreshing,
      foundPhotos: progress.foundPhotos,
      indexedPhotos: progress.writtenPhotos,
      sourceCount: progress.sourceCount,
    );

    if (progress.writtenPhotos > previousWritten) {
      _queueReload();
    }
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
        final nextPhase = switch ((_scanRunning, phase)) {
          (true, PhotoLibraryPhase.loaded) => PhotoLibraryPhase.refreshing,
          (false, PhotoLibraryPhase.refreshing) => PhotoLibraryPhase.loaded,
          _ => phase,
        };
        state = state.copyWith(
          phase: nextPhase,
          library: value,
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
