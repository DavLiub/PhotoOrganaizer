import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/photo_library.dart';
import 'package:photo_organizer/application/ports/media_library_gateway.dart';
import 'package:photo_organizer/application/use_cases/index_photos.dart';
import 'package:photo_organizer/application/use_cases/scan_media_library.dart';
import 'package:photo_organizer/domain/entities/media_source.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/presentation/localization/app_localizations.dart';
import 'package:photo_organizer/presentation/screens/home/home_screen.dart';
import 'package:photo_organizer/presentation/state/app_providers.dart';
import 'package:photo_organizer/presentation/state/first_scan_actions.dart';
import 'package:photo_organizer/presentation/state/photo_library_actions.dart';

void main() {
  testWidgets('shows welcome screen while media access is denied', (
    tester,
  ) async {
    final actions = _FakeActions(
      currentPermission: const MediaPermission(
        state: MediaPermissionState.denied,
      ),
    );

    await tester.pumpWidget(_buildHome(actions));
    await tester.pump();
    await tester.pump();

    expect(find.text('Welcome to Photo Organizer'), findsOneWidget);
    expect(find.text('Photo access'), findsOneWidget);
    expect(
      find.textContaining('cannot work without media access'),
      findsWidgets,
    );
    expect(find.text('Grant access'), findsOneWidget);
    expect(find.text('Scan'), findsNothing);
  });

  testWidgets('auto-requests permission when initial status is unknown', (
    tester,
  ) async {
    final actions = _FakeActions(
      currentPermission: const MediaPermission(
        state: MediaPermissionState.unknown,
      ),
      requestedPermission: const MediaPermission(
        state: MediaPermissionState.granted,
      ),
    );

    await tester.pumpWidget(_buildHome(actions));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(actions.requestCalls, 1);
    expect(find.text('First photo scan'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
  });

  testWidgets('runs scan and displays photo/source counts', (tester) async {
    final source = _source();
    final photos = [
      _photo(id: 'asset-1', sourceId: source.id),
      _photo(id: 'asset-2', sourceId: source.id),
    ];
    final actions = _FakeActions(
      currentPermission: const MediaPermission(
        state: MediaPermissionState.granted,
      ),
      scanResult: LibraryScanResult(
        scan: LibraryScan(sources: [source], photos: photos),
        index: const IndexResult(
          seenPhotos: 2,
          indexedPhotos: 2,
          updatedPhotos: 0,
          ignoredPhotos: 0,
        ),
      ),
    );

    await tester.pumpWidget(_buildHome(actions));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Scan'));
    await tester.pump();
    await tester.pump();

    expect(actions.scanCalls, 1);
    expect(find.text('Scan complete'), findsOneWidget);
    expect(find.text('Found photos'), findsOneWidget);
    expect(find.text('Indexed photos'), findsOneWidget);
    expect(find.text('Sources'), findsOneWidget);
    expect(find.text('2'), findsNWidgets(2));
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('updates scan counters before scan completes', (tester) async {
    final scanResult = Completer<OperationResult<LibraryScanResult>>();
    final actions = _FakeActions(
      currentPermission: const MediaPermission(
        state: MediaPermissionState.granted,
      ),
      scanResult: scanResult,
    );

    await tester.pumpWidget(_buildHome(actions));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Scan'));
    await tester.pump();

    expect(find.text('Scanning library'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    scanResult.complete(
      const OperationSuccess(
        LibraryScanResult(
          scan: LibraryScan.empty(),
          index: IndexResult(
            seenPhotos: 0,
            indexedPhotos: 0,
            updatedPhotos: 0,
            ignoredPhotos: 0,
          ),
        ),
      ),
    );
    await tester.pump();
  });

  testWidgets('renders Russian labels when locale is Russian', (tester) async {
    final actions = _FakeActions(
      currentPermission: const MediaPermission(
        state: MediaPermissionState.denied,
      ),
    );

    await tester.pumpWidget(_buildHome(actions, locale: const Locale('ru')));
    await tester.pump();
    await tester.pump();

    expect(find.text('Добро пожаловать в Photo Organizer'), findsOneWidget);
    expect(find.text('Дать доступ'), findsOneWidget);
  });
}

Widget _buildHome(_FakeActions actions, {Locale locale = const Locale('en')}) {
  return ProviderScope(
    overrides: [
      firstScanActionsProvider.overrideWithValue(actions.value),
      photoLibraryActionsProvider.overrideWithValue(actions.libraryValue),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: HomeScreen()),
    ),
  );
}

class _FakeActions {
  _FakeActions({
    required this.currentPermission,
    MediaPermission? requestedPermission,
    Object? scanResult,
  }) : requestedPermission = requestedPermission ?? currentPermission,
       scanResult =
           scanResult ??
           const LibraryScanResult(
             scan: LibraryScan.empty(),
             index: IndexResult(
               seenPhotos: 0,
               indexedPhotos: 0,
               updatedPhotos: 0,
               ignoredPhotos: 0,
             ),
           );

  final MediaPermission currentPermission;
  final MediaPermission requestedPermission;
  final Object scanResult;
  int requestCalls = 0;
  int scanCalls = 0;

  FirstScanActions get value {
    return FirstScanActions(
      checkAccess: () async => OperationSuccess(currentPermission),
      requestAccess: () async {
        requestCalls++;
        return OperationSuccess(requestedPermission);
      },
      scanLibrary: ({int pageSize = 100, onProgress, signal}) async {
        signal?.throwIfStopped();
        return _runScan(onProgress);
      },
    );
  }

  PhotoLibraryActions get libraryValue {
    return PhotoLibraryActions(
      listPhotos: () async {
        return const OperationSuccess(PhotoLibrary.empty());
      },
      loadThumbnail: (assetId, {int size = 200}) async {
        return null;
      },
      refreshLibrary: ({int pageSize = 100, onProgress, signal}) async {
        signal?.throwIfStopped();
        return _runScan(onProgress);
      },
    );
  }

  Future<OperationResult<LibraryScanResult>> _runScan(
    ScanProgressCallback? onProgress,
  ) async {
    scanCalls++;
    onProgress?.call(
      const ScanProgress(
        foundPhotos: 5,
        indexedPhotos: 2,
        updatedPhotos: 0,
        sourceCount: 1,
      ),
    );

    final nextResult = scanResult;
    if (nextResult is Completer<OperationResult<LibraryScanResult>>) {
      return nextResult.future;
    }

    return OperationSuccess(nextResult as LibraryScanResult);
  }
}

MediaSource _source() {
  return MediaSource(
    id: 'photo_manager:camera',
    provider: 'photo_manager',
    name: 'Camera',
    assetCount: 2,
    lastSeenAt: DateTime.utc(2026, 7, 24),
    availabilityStatus: MediaSourceStatus.available,
    cameraLike: true,
  );
}

PhotoAsset _photo({required String id, required String sourceId}) {
  final now = DateTime.utc(2026, 7, 24);

  return PhotoAsset(
    id: id,
    sourceUri: 'photo-manager://asset/$id',
    sourceProvider: 'photo_manager',
    sourceId: sourceId,
    albumId: 'camera',
    sourceName: 'Camera',
    filename: '$id.jpg',
    mimeType: 'image/jpeg',
    fileSize: 100,
    createdAt: now,
    modifiedAt: now,
    discoveredAt: now,
    lastSeenAt: now,
    availabilityStatus: PhotoAvailabilityStatus.available,
  );
}
