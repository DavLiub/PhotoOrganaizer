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
import 'package:photo_organizer/presentation/state/app_settings_controller.dart';
import 'package:photo_organizer/presentation/state/source_selection_actions.dart';

void main() {
  testWidgets('uses supported system locale before manual selection', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('ru')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    final settings = _FakeSettings(const AppSettings());
    await tester.pumpWidget(_buildApp(settings));
    await tester.pump();
    await tester.pump();

    expect(find.text('Настройки'), findsOneWidget);
    expect(settings.savedLocaleCodes, isEmpty);
  });

  testWidgets('falls back to English for unsupported system locale', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('he')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(_buildApp(_FakeSettings(const AppSettings())));
    await tester.pump();
    await tester.pump();

    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('stored locale overrides supported system locale', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('ru')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      _buildApp(_FakeSettings(const AppSettings(selectedLocaleCode: 'en'))),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('language selection applies without app restart', (tester) async {
    final settings = _FakeSettings(const AppSettings());
    await tester.pumpWidget(_buildApp(settings));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('settings_category_language')));
    await tester.pump();

    await tester.tap(find.text('Russian'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Настройки'), findsOneWidget);
    expect(settings.savedLocaleCodes, ['ru']);
  });
}

Widget _buildApp(_FakeSettings settings) {
  return ProviderScope(
    overrides: [
      appSettingsActionsProvider.overrideWithValue(settings.value),
      sourceSelectionActionsProvider.overrideWithValue(_FakeSources().value),
    ],
    child: const _LocalizedSettingsApp(),
  );
}

class _LocalizedSettingsApp extends ConsumerWidget {
  const _LocalizedSettingsApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocaleCode = ref.watch(
      appSettingsProvider.select((state) => state.selectedLocaleCode),
    );

    return MaterialApp(
      locale: selectedLocaleCode == null ? null : Locale(selectedLocaleCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SettingsScreen(),
    );
  }
}

class _FakeSettings {
  _FakeSettings(this.settings);

  AppSettings settings;
  final savedLocaleCodes = <String>[];

  AppSettingsActions get value {
    return AppSettingsActions(
      readSettings: () async {
        return OperationSuccess(settings);
      },
      saveLocale: (localeCode) async {
        savedLocaleCodes.add(localeCode);
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
