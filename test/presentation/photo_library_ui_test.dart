import 'dart:async';
import 'dart:typed_data';

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
import 'package:photo_organizer/presentation/navigation/main_scaffold.dart';
import 'package:photo_organizer/presentation/screens/photos/photos_screen.dart';
import 'package:photo_organizer/presentation/state/app_providers.dart';
import 'package:photo_organizer/presentation/state/first_scan_actions.dart';
import 'package:photo_organizer/presentation/state/photo_library_state.dart';
import 'package:photo_organizer/presentation/state/photo_library_actions.dart';

void main() {
  test('sorts visible photos after category filtering', () {
    final library = _sortLibrary();
    final defaultState = PhotoLibraryState(
      phase: PhotoLibraryPhase.loaded,
      library: library,
    );

    expect(_names(defaultState.visiblePhotos), [
      'alpha.jpg',
      'middle.jpg',
      'zeta.jpg',
    ]);

    expect(
      _names(defaultState.copyWith(sort: LibrarySort.dateAsc).visiblePhotos),
      ['zeta.jpg', 'middle.jpg', 'alpha.jpg'],
    );

    expect(
      _names(defaultState.copyWith(sort: LibrarySort.nameAsc).visiblePhotos),
      ['alpha.jpg', 'middle.jpg', 'zeta.jpg'],
    );

    expect(
      _names(defaultState.copyWith(sort: LibrarySort.nameDesc).visiblePhotos),
      ['zeta.jpg', 'middle.jpg', 'alpha.jpg'],
    );

    expect(
      _names(
        defaultState
            .copyWith(filter: LibraryFilter.camera, sort: LibrarySort.nameAsc)
            .visiblePhotos,
      ),
      ['alpha.jpg', 'zeta.jpg'],
    );
  });

  testWidgets('shows empty state before indexed photos exist', (tester) async {
    final actions = _FakeActions(library: const PhotoLibrary.empty());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    expect(find.byTooltip('All'), findsOneWidget);
    expect(find.byTooltip('Camera'), findsOneWidget);
    expect(find.byTooltip('Social'), findsOneWidget);
    expect(find.byTooltip('Downloads'), findsOneWidget);
    expect(find.byTooltip('Screenshots'), findsOneWidget);
    expect(find.text('Date ↓'), findsOneWidget);
    expect(find.text('0 photos'), findsOneWidget);
    expect(find.byKey(const ValueKey('library_scan_indicator')), findsNothing);
    expect(find.text('No indexed photos yet'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Backup (0%)'), findsOneWidget);
    expect(find.text('Indexed photos'), findsNothing);
    expect(find.text('Sources'), findsNothing);
  });

  testWidgets('centers category filter when it fits screen width', (
    tester,
  ) async {
    final actions = _FakeActions(library: const PhotoLibrary.empty());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    final screenCenter = tester.getCenter(find.byType(PhotosScreen)).dx;
    final filterCenter = tester
        .getCenter(find.byType(SegmentedButton<LibraryFilter>))
        .dx;

    expect(filterCenter, closeTo(screenCenter, 1));
  });

  testWidgets('shows indexed photo grid with backup status', (tester) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    expect(find.text('camera.jpg'), findsOneWidget);
    expect(find.text('screen.jpg'), findsOneWidget);
    expect(find.text('No backup'), findsNWidgets(2));
    expect(find.text('2 photos'), findsOneWidget);
    expect(find.byKey(const ValueKey('library_scan_indicator')), findsNothing);
    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
    expect(scrollbar.thumbVisibility, isTrue);
    expect(scrollbar.interactive, isTrue);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Backup (0%)'), findsOneWidget);
    expect(find.text('Catalogs'), findsNothing);
  });

  testWidgets('filters photos by selected catalog category', (tester) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byTooltip('Screenshots'));
    await tester.pumpAndSettle();

    expect(find.text('screen.jpg'), findsOneWidget);
    expect(find.text('camera.jpg'), findsNothing);
    expect(find.text('1 photos'), findsOneWidget);
  });

  testWidgets('sort control stores selected value', (tester) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Date ↓'));
    await tester.pumpAndSettle();
    expect(find.text('Name A-Z'), findsOneWidget);

    await tester.tap(find.text('Name A-Z'));
    await tester.pumpAndSettle();

    expect(find.text('Name A-Z'), findsOneWidget);
  });

  testWidgets('shows stop action while library scan is running', (
    tester,
  ) async {
    final refreshResult = Completer<OperationResult<LibraryScanResult>>();
    final actions = _FakeActions(
      library: _library(),
      refreshResult: refreshResult,
    );

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Scan'));
    await tester.pump();

    expect(find.text('Stop'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('library_scan_indicator')),
      findsOneWidget,
    );
    expect(find.text('Indexed photos'), findsNothing);
    expect(find.text('Sources'), findsNothing);

    refreshResult.complete(
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

  testWidgets('backup action warns when target is not configured', (
    tester,
  ) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Backup (0%)'));
    await tester.pumpAndSettle();

    expect(find.text('Backup target is not configured'), findsOneWidget);
    expect(find.text('Go to settings'), findsOneWidget);
  });

  testWidgets('renders Russian library labels', (tester) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions, locale: const Locale('ru')));
    await tester.pump();
    await tester.pump();

    expect(find.byTooltip('Все'), findsOneWidget);
    expect(find.text('Дата ↓'), findsOneWidget);
    expect(find.text('Нет бэкапа'), findsNWidgets(2));
    expect(find.text('Бэкап (0%)'), findsOneWidget);
  });

  testWidgets('successful first scan opens library tab', (tester) async {
    final libraryActions = _FakeActions(library: _library());
    final scanActions = _FakeScanActions();

    await tester.pumpWidget(_buildShell(scanActions, libraryActions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    expect(libraryActions.refreshCalls, 1);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('camera.jpg'), findsOneWidget);
  });
}

Widget _buildPhotos(
  _FakeActions actions, {
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: [
      firstScanActionsProvider.overrideWithValue(_FakeScanActions().value),
      photoLibraryActionsProvider.overrideWithValue(actions.value),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: PhotosScreen()),
    ),
  );
}

Widget _buildShell(_FakeScanActions scanActions, _FakeActions libraryActions) {
  return ProviderScope(
    overrides: [
      firstScanActionsProvider.overrideWithValue(scanActions.value),
      photoLibraryActionsProvider.overrideWithValue(libraryActions.value),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScaffold(),
    ),
  );
}

class _FakeActions {
  _FakeActions({required this.library, this.refreshResult});

  PhotoLibrary library;
  final Completer<OperationResult<LibraryScanResult>>? refreshResult;
  int refreshCalls = 0;

  PhotoLibraryActions get value {
    return PhotoLibraryActions(
      listPhotos: () async => OperationSuccess(library),
      loadThumbnail: (assetId, {int size = 200}) async => _transparentPng(),
      refreshLibrary: ({int pageSize = 100, onProgress, signal}) async {
        signal?.throwIfStopped();
        refreshCalls++;
        onProgress?.call(
          const ScanProgress(
            foundPhotos: 3,
            indexedPhotos: 1,
            updatedPhotos: 0,
            sourceCount: 1,
          ),
        );
        final pendingRefresh = refreshResult;
        if (pendingRefresh != null) {
          return pendingRefresh.future;
        }

        return const OperationSuccess(
          LibraryScanResult(
            scan: LibraryScan.empty(),
            index: IndexResult(
              seenPhotos: 0,
              indexedPhotos: 0,
              updatedPhotos: 0,
              ignoredPhotos: 0,
            ),
          ),
        );
      },
    );
  }
}

class _FakeScanActions {
  int scanCalls = 0;

  FirstScanActions get value {
    return FirstScanActions(
      checkAccess: () async {
        return const OperationSuccess(
          MediaPermission(state: MediaPermissionState.granted),
        );
      },
      requestAccess: () async {
        return const OperationSuccess(
          MediaPermission(state: MediaPermissionState.granted),
        );
      },
      scanLibrary: ({int pageSize = 100, onProgress, signal}) async {
        signal?.throwIfStopped();
        scanCalls++;
        return OperationSuccess(
          LibraryScanResult(
            scan: LibraryScan(sources: [_source()], photos: [_asset()]),
            index: const IndexResult(
              seenPhotos: 1,
              indexedPhotos: 1,
              updatedPhotos: 0,
              ignoredPhotos: 0,
            ),
          ),
        );
      },
    );
  }
}

PhotoLibrary _library() {
  final photos = [
    _photo(
      id: 'camera',
      displayName: 'camera.jpg',
      category: LibraryCategory.camera,
    ),
    _photo(
      id: 'screen',
      displayName: 'screen.jpg',
      category: LibraryCategory.screenshots,
    ),
  ];

  return PhotoLibrary(
    photos: photos,
    categories: const [
      LibraryCategorySummary(category: LibraryCategory.camera, count: 1),
      LibraryCategorySummary(category: LibraryCategory.social, count: 0),
      LibraryCategorySummary(category: LibraryCategory.downloads, count: 0),
      LibraryCategorySummary(category: LibraryCategory.screenshots, count: 1),
    ],
  );
}

PhotoLibrary _sortLibrary() {
  final photos = [
    _photo(
      id: 'zeta',
      displayName: 'zeta.jpg',
      category: LibraryCategory.camera,
      createdAt: DateTime.utc(2026, 7, 25),
    ),
    _photo(
      id: 'alpha',
      displayName: 'alpha.jpg',
      category: LibraryCategory.camera,
      createdAt: DateTime.utc(2026, 7, 27),
    ),
    _photo(
      id: 'middle',
      displayName: 'middle.jpg',
      category: LibraryCategory.screenshots,
      createdAt: DateTime.utc(2026, 7, 26),
    ),
  ];

  return PhotoLibrary(
    photos: photos,
    categories: const [
      LibraryCategorySummary(category: LibraryCategory.camera, count: 2),
      LibraryCategorySummary(category: LibraryCategory.social, count: 0),
      LibraryCategorySummary(category: LibraryCategory.downloads, count: 0),
      LibraryCategorySummary(category: LibraryCategory.screenshots, count: 1),
    ],
  );
}

List<String> _names(List<LibraryPhoto> photos) {
  return photos.map((photo) => photo.displayName).toList(growable: false);
}

LibraryPhoto _photo({
  required String id,
  required String displayName,
  required LibraryCategory category,
  DateTime? createdAt,
}) {
  return LibraryPhoto(
    id: id,
    assetId: id,
    displayName: displayName,
    sourceName: category.name,
    category: category,
    backupStatus: LibraryBackupStatus.noBackup,
    createdAt: createdAt ?? DateTime.utc(2026, 7, 27),
    fileSize: 100,
    width: 100,
    height: 100,
  );
}

MediaSource _source() {
  return MediaSource(
    id: 'photo_manager:camera',
    provider: 'photo_manager',
    name: 'Camera',
    assetCount: 1,
    lastSeenAt: DateTime.utc(2026, 7, 27),
    availabilityStatus: MediaSourceStatus.available,
    cameraLike: true,
  );
}

PhotoAsset _asset() {
  final now = DateTime.utc(2026, 7, 27);

  return PhotoAsset(
    id: 'camera',
    sourceUri: 'photo-manager://asset/camera',
    sourceProvider: 'photo_manager',
    sourceId: 'photo_manager:camera',
    sourceName: 'Camera',
    albumId: 'camera',
    filename: 'camera.jpg',
    mimeType: 'image/jpeg',
    fileSize: 100,
    createdAt: now,
    modifiedAt: now,
    discoveredAt: now,
    lastSeenAt: now,
    availabilityStatus: PhotoAvailabilityStatus.available,
    width: 100,
    height: 100,
  );
}

Uint8List _transparentPng() {
  return Uint8List.fromList(const [
    137,
    80,
    78,
    71,
    13,
    10,
    26,
    10,
    0,
    0,
    0,
    13,
    73,
    72,
    68,
    82,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    1,
    8,
    6,
    0,
    0,
    0,
    31,
    21,
    196,
    137,
    0,
    0,
    0,
    13,
    73,
    68,
    65,
    84,
    120,
    156,
    99,
    248,
    15,
    4,
    0,
    9,
    251,
    3,
    253,
    167,
    173,
    166,
    227,
    0,
    0,
    0,
    0,
    73,
    69,
    78,
    68,
    174,
    66,
    96,
    130,
  ]);
}
