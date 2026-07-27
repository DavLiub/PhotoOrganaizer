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
import 'package:photo_organizer/presentation/state/photo_library_actions.dart';

void main() {
  testWidgets('shows empty state before indexed photos exist', (tester) async {
    final actions = _FakeActions(library: const PhotoLibrary.empty());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('No indexed photos yet'), findsOneWidget);
    expect(find.text('Scan photos'), findsOneWidget);
  });

  testWidgets('shows indexed photo grid with backup status', (tester) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    expect(find.text('camera.jpg'), findsOneWidget);
    expect(find.text('screen.jpg'), findsOneWidget);
    expect(find.text('No backup'), findsNWidgets(2));
    expect(find.text('Catalogs'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Backup'), findsOneWidget);
  });

  testWidgets('filters photos by selected catalog category', (tester) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Catalogs'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Screenshots'));
    await tester.pumpAndSettle();

    expect(find.text('screen.jpg'), findsOneWidget);
    expect(find.text('camera.jpg'), findsNothing);
  });

  testWidgets('refresh dialog can run manual refresh', (tester) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byTooltip('Refresh'));
    await tester.pumpAndSettle();
    expect(find.text('Refresh library'), findsOneWidget);

    await tester.tap(find.text('Run now'));
    await tester.pumpAndSettle();

    expect(actions.refreshCalls, 1);
  });

  testWidgets('backup action warns when target is not configured', (
    tester,
  ) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Backup'));
    await tester.pumpAndSettle();

    expect(find.text('Backup target is not configured'), findsOneWidget);
    expect(find.text('Go to settings'), findsOneWidget);
  });

  testWidgets('renders Russian library labels', (tester) async {
    final actions = _FakeActions(library: _library());

    await tester.pumpWidget(_buildPhotos(actions, locale: const Locale('ru')));
    await tester.pump();
    await tester.pump();

    expect(find.text('Библиотека'), findsOneWidget);
    expect(find.text('Нет бэкапа'), findsNWidgets(2));
    expect(find.text('Каталоги'), findsOneWidget);
  });

  testWidgets('successful first scan opens library tab', (tester) async {
    final libraryActions = _FakeActions(library: _library());
    final scanActions = _FakeScanActions();

    await tester.pumpWidget(_buildShell(scanActions, libraryActions));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    expect(scanActions.scanCalls, 1);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('camera.jpg'), findsOneWidget);
  });
}

Widget _buildPhotos(
  _FakeActions actions, {
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: [photoLibraryActionsProvider.overrideWithValue(actions.value)],
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
  _FakeActions({required this.library});

  PhotoLibrary library;
  int refreshCalls = 0;

  PhotoLibraryActions get value {
    return PhotoLibraryActions(
      listPhotos: () async => OperationSuccess(library),
      loadThumbnail: (assetId, {int size = 200}) async => _transparentPng(),
      refreshLibrary: ({int pageSize = 100}) async {
        refreshCalls++;
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
      scanLibrary: ({int pageSize = 100}) async {
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

LibraryPhoto _photo({
  required String id,
  required String displayName,
  required LibraryCategory category,
}) {
  return LibraryPhoto(
    id: id,
    assetId: id,
    displayName: displayName,
    sourceName: category.name,
    category: category,
    backupStatus: LibraryBackupStatus.noBackup,
    createdAt: DateTime.utc(2026, 7, 27),
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
