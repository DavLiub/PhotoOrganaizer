@Tags(<String>['smoke', 'ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/photo_library.dart';
import 'package:photo_organizer/application/ports/media_library_gateway.dart';
import 'package:photo_organizer/application/use_cases/index_photos.dart';
import 'package:photo_organizer/application/use_cases/scan_media_library.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/presentation/localization/app_localizations.dart';
import 'package:photo_organizer/presentation/navigation/main_scaffold.dart';
import 'package:photo_organizer/presentation/state/app_providers.dart';
import 'package:photo_organizer/presentation/state/first_scan_actions.dart';
import 'package:photo_organizer/presentation/state/photo_library_actions.dart';
import 'package:photo_organizer/presentation/theme/app_theme.dart';

void main() {
  testWidgets('renders application shell', (tester) async {
    await tester.pumpWidget(const _SmokeApp());
    await tester.pump();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}

class _SmokeApp extends StatelessWidget {
  const _SmokeApp();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        firstScanActionsProvider.overrideWithValue(_scanActions()),
        photoLibraryActionsProvider.overrideWithValue(_libraryActions()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MainScaffold(),
      ),
    );
  }
}

FirstScanActions _scanActions() {
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

PhotoLibraryActions _libraryActions() {
  return PhotoLibraryActions(
    listPhotos: () async {
      return const OperationSuccess(PhotoLibrary.empty());
    },
    loadThumbnail: (assetId, {int size = 200}) async {
      return null;
    },
    refreshLibrary: ({int pageSize = 100, onProgress, signal}) async {
      signal?.throwIfStopped();
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
