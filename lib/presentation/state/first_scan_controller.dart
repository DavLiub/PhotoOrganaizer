import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/use_cases/scan_media_library.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';
import 'app_providers.dart';
import 'first_scan_actions.dart';
import 'first_scan_state.dart';
import 'main_destination_controller.dart';
import 'photo_library_controller.dart';
import '../navigation/main_destination.dart';

final firstScanProvider = NotifierProvider<FirstScanController, FirstScanState>(
  FirstScanController.new,
);

class FirstScanController extends Notifier<FirstScanState> {
  late final FirstScanActions _actions;

  @override
  FirstScanState build() {
    _actions = ref.watch(firstScanActionsProvider);
    unawaited(
      Future<void>.microtask(() => checkAccess(autoRequestUnknown: true)),
    );
    return const FirstScanState.initial();
  }

  Future<void> checkAccess({bool autoRequestUnknown = false}) async {
    state = state.copyWith(phase: FirstScanPhase.checking, clearError: true);
    final result = await _actions.checkAccess();
    await _applyPermission(result, autoRequestUnknown: autoRequestUnknown);
  }

  Future<void> requestAccess() async {
    state = state.copyWith(phase: FirstScanPhase.checking, clearError: true);
    final result = await _actions.requestAccess();
    await _applyPermission(result);
  }

  Future<void> scan() async {
    if (!state.canScan) {
      return;
    }

    state = state.copyWith(
      phase: FirstScanPhase.scanning,
      foundPhotos: 0,
      indexedPhotos: 0,
      sourceCount: 0,
      clearError: true,
    );

    final result = await _actions.scanLibrary(
      pageSize: 100,
      onProgress: _applyProgress,
    );

    switch (result) {
      case OperationSuccess<LibraryScanResult>(value: final value):
        final phase = value.scan.photos.isEmpty
            ? FirstScanPhase.ready
            : FirstScanPhase.complete;
        state = state.copyWith(
          phase: phase,
          foundPhotos: value.scan.photos.length,
          indexedPhotos: value.index.writtenPhotos,
          sourceCount: value.scan.sources.length,
          clearError: true,
        );
        ref.invalidate(photoLibraryProvider);
        ref
            .read(mainDestinationProvider.notifier)
            .select(MainDestination.photos);
      case OperationFailure<LibraryScanResult>(failure: final failure):
        state = state.copyWith(
          phase: FirstScanPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }

  void _applyProgress(ScanProgress progress) {
    if (state.phase != FirstScanPhase.scanning) {
      return;
    }

    state = state.copyWith(
      foundPhotos: progress.foundPhotos,
      indexedPhotos: progress.writtenPhotos,
      sourceCount: progress.sourceCount,
    );
  }

  Future<void> _applyPermission(
    OperationResult<MediaPermission> result, {
    bool autoRequestUnknown = false,
  }) async {
    switch (result) {
      case OperationSuccess<MediaPermission>(value: final value):
        if (autoRequestUnknown && value.state == MediaPermissionState.unknown) {
          await requestAccess();
          return;
        }

        state = state.copyWith(
          permission: value,
          phase: value.canReadPhotos
              ? FirstScanPhase.ready
              : FirstScanPhase.permissionRequired,
          clearError: true,
        );
      case OperationFailure<MediaPermission>(failure: final failure):
        state = state.copyWith(
          phase: FirstScanPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }
}
