@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/photo_library.dart';
import 'package:photo_organizer/application/models/source_selection.dart';
import 'package:photo_organizer/domain/entities/media_source.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/presentation/localization/app_localizations.dart';
import 'package:photo_organizer/presentation/screens/albums/albums_screen.dart';
import 'package:photo_organizer/presentation/state/app_providers.dart';
import 'package:photo_organizer/presentation/state/source_selection_actions.dart';

void main() {
  testWidgets('shows sources grouped by enabled categories', (tester) async {
    await tester.pumpWidget(_buildScreen(_FakeSources()));
    await tester.pump();
    await tester.pump();

    expect(find.text('Album sources'), findsOneWidget);
    expect(find.textContaining('Choose which albums'), findsOneWidget);
    expect(find.text('Camera'), findsNWidgets(2));
    expect(find.text('Screenshots'), findsNWidgets(2));
    expect(find.text('Download'), findsNothing);
    expect(find.byIcon(Icons.folder_rounded), findsNWidgets(2));
    expect(find.text('10'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('DCIM/Camera'), findsOneWidget);
    expect(find.text('Pictures/Screenshots'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNWidgets(2));
  });

  testWidgets('updates source selection through switch', (tester) async {
    final actions = _FakeSources();

    await tester.pumpWidget(_buildScreen(actions));
    await tester.pump();
    await tester.pump();

    final cameraSwitch = find.byKey(const ValueKey('media_source_camera'));
    expect(cameraSwitch, findsOneWidget);
    expect(actions.settings.isSourceEnabled('camera'), isTrue);

    await tester.tap(cameraSwitch);
    await tester.pump();
    await tester.pump();

    expect(actions.settings.isSourceEnabled('camera'), isFalse);
  });

  testWidgets('hides sources from disabled global category', (tester) async {
    final actions = _FakeSources(
      settings: SourceSelectionSettings.defaults().withCategory(
        LibraryCategory.screenshots,
        enabled: false,
      ),
    );

    await tester.pumpWidget(_buildScreen(actions));
    await tester.pump();
    await tester.pump();

    expect(find.text('Camera'), findsNWidgets(2));
    expect(find.text('Screenshots'), findsNothing);
    expect(
      find.byKey(const ValueKey('media_source_screenshots')),
      findsNothing,
    );
  });
}

Widget _buildScreen(_FakeSources actions) {
  return ProviderScope(
    overrides: [
      sourceSelectionActionsProvider.overrideWithValue(actions.value),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AlbumsScreen(),
    ),
  );
}

class _FakeSources {
  _FakeSources({SourceSelectionSettings? settings})
    : settings =
          settings ??
          SourceSelectionSettings(
            enabledCategories: const {
              LibraryCategory.camera,
              LibraryCategory.screenshots,
            },
          );

  SourceSelectionSettings settings;

  SourceSelectionActions get value {
    return SourceSelectionActions(
      listSources: () async {
        return OperationSuccess(
          buildMediaSourceSelection(sources: _sources(), settings: settings),
        );
      },
      setCategory: (category, {required enabled}) async {
        settings = settings.withCategory(category, enabled: enabled);
        return OperationSuccess(settings);
      },
      setSource: (sourceId, {required enabled}) async {
        settings = settings.withSource(sourceId, enabled: enabled);
        return OperationSuccess(settings);
      },
    );
  }
}

List<MediaSource> _sources() {
  return [
    MediaSource(
      id: 'camera',
      provider: 'photo_manager',
      name: 'Camera',
      pathHint: 'DCIM/Camera',
      assetCount: 10,
      lastSeenAt: DateTime.utc(2026, 7, 28),
      availabilityStatus: MediaSourceStatus.available,
      cameraLike: true,
    ),
    MediaSource(
      id: 'screenshots',
      provider: 'photo_manager',
      name: 'Screenshots',
      pathHint: 'Pictures/Screenshots',
      assetCount: 2,
      lastSeenAt: DateTime.utc(2026, 7, 28),
      availabilityStatus: MediaSourceStatus.available,
    ),
    MediaSource(
      id: 'download',
      provider: 'photo_manager',
      name: 'Download',
      assetCount: 4,
      lastSeenAt: DateTime.utc(2026, 7, 28),
      availabilityStatus: MediaSourceStatus.available,
    ),
  ];
}
