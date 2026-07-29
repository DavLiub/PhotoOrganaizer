@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/app_settings.dart';
import 'package:photo_organizer/application/models/source_selection.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/presentation/localization/app_localizations.dart';
import 'package:photo_organizer/presentation/screens/settings/settings_screen.dart';
import 'package:photo_organizer/presentation/state/app_providers.dart';
import 'package:photo_organizer/presentation/state/app_settings_actions.dart';
import 'package:photo_organizer/presentation/state/source_selection_actions.dart';

void main() {
  testWidgets('renders two-level settings shell', (tester) async {
    await _pumpSettings(tester);

    expect(
      find.byKey(const ValueKey('settings_category_status')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('settings_category_storage')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('settings_category_general')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('settings_category_backup')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('settings_detail_pane')), findsOneWidget);
    expect(find.text('Free plan'), findsOneWidget);
    expect(find.text('Storage is not connected'), findsOneWidget);
    expect(find.text('Provider'), findsNothing);
  });

  testWidgets('shows storage layout controls and opens complex editor', (
    tester,
  ) async {
    await _pumpSettings(tester);

    await tester.tap(find.byKey(const ValueKey('settings_category_storage')));
    await tester.pump();

    expect(find.text('Provider'), findsOneWidget);
    expect(find.text('Connected account'), findsOneWidget);
    expect(find.text('Root folder'), findsOneWidget);
    expect(find.text('Cloud folder layout'), findsOneWidget);
    expect(find.text('All in root folder'), findsOneWidget);
    expect(find.text('Keep album structure'), findsOneWidget);
    expect(find.text('Group by year/month'), findsOneWidget);
    expect(find.text('Photo path template'), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextField, 'Root folder'),
      '/Photos',
    );
    expect(find.text('/Photos'), findsOneWidget);

    await tester.tap(find.text('Provider'));
    await tester.pumpAndSettle();

    expect(find.text('Provider'), findsWidgets);
    expect(
      find.text('Configuration persistence will be added in a later PR.'),
      findsOneWidget,
    );
  });

  testWidgets('media library exposes category exclusions only', (tester) async {
    await _pumpSettings(tester);

    await tester.tap(find.byKey(const ValueKey('settings_category_library')));
    await tester.pump();

    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Social'), findsOneWidget);
    expect(find.text('Downloads'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('Included folders'), findsOneWidget);
    expect(find.text('Categories'), findsNothing);
    expect(find.text('Refresh behavior'), findsNothing);
  });

  testWidgets('backup original mode disables quality and size controls', (
    tester,
  ) async {
    await _pumpSettings(tester);

    await tester.tap(find.byKey(const ValueKey('settings_category_backup')));
    await tester.pump();

    expect(find.text('Optimized copies'), findsOneWidget);
    expect(find.text('Original photos'), findsOneWidget);
    expect(find.text('Image quality'), findsOneWidget);
    expect(find.text('Maximum photo size'), findsOneWidget);

    await tester.tap(find.text('Original photos'));
    await tester.pump();

    expect(
      find.text('Disabled when backing up original photos.'),
      findsNWidgets(2),
    );
  });

  testWidgets('background uses battery threshold instead of charging only', (
    tester,
  ) async {
    await _pumpSettings(tester);

    await tester.tap(
      find.byKey(const ValueKey('settings_category_background')),
    );
    await tester.pump();

    expect(find.text('Run when battery is above'), findsOneWidget);
    expect(find.text('Battery optimization'), findsNothing);
    expect(find.text('Run while charging'), findsNothing);
  });

  testWidgets('language is selected through flag cards', (tester) async {
    await _pumpSettings(tester);

    await tester.tap(find.byKey(const ValueKey('settings_category_language')));
    await tester.pump();

    expect(find.text('🇺🇸'), findsOneWidget);
    expect(find.text('🇷🇺'), findsOneWidget);
    expect(find.text('English'), findsNWidgets(2));
    expect(find.text('Russian'), findsOneWidget);
    expect(find.text('🇮🇱'), findsNothing);
    expect(find.text('Hebrew'), findsNothing);

    await tester.tap(find.text('Russian'));
    await tester.pump();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('renders Russian settings labels', (tester) async {
    await _pumpSettings(tester, locale: const Locale('ru'));

    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Статус'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('settings_category_storage')));
    await tester.pump();

    expect(find.text('Провайдер'), findsOneWidget);
    expect(find.text('Корневая папка'), findsOneWidget);
  });
}

Future<void> _pumpSettings(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(_buildScreen(locale: locale));
  await tester.pump();
}

Widget _buildScreen({Locale locale = const Locale('en')}) {
  return ProviderScope(
    overrides: [
      appSettingsActionsProvider.overrideWithValue(_FakeAppSettings().value),
      sourceSelectionActionsProvider.overrideWithValue(_FakeSources().value),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SettingsScreen(),
    ),
  );
}

class _FakeAppSettings {
  AppSettings settings = const AppSettings();

  AppSettingsActions get value {
    return AppSettingsActions(
      readSettings: () async {
        return OperationSuccess(settings);
      },
      saveLocale: (localeCode) async {
        settings = AppSettings(selectedLocaleCode: localeCode);
        return OperationSuccess(settings);
      },
    );
  }
}

class _FakeSources {
  SourceSelectionSettings settings = SourceSelectionSettings.defaults();

  SourceSelectionActions get value {
    return SourceSelectionActions(
      listSources: () async {
        return OperationSuccess(
          buildMediaSourceSelection(sources: const [], settings: settings),
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
