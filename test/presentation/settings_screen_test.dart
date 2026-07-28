@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/presentation/localization/app_localizations.dart';
import 'package:photo_organizer/presentation/screens/settings/settings_screen.dart';

void main() {
  testWidgets('renders two-level settings shell', (tester) async {
    await tester.pumpWidget(_buildScreen());

    expect(
      find.byKey(const ValueKey('settings_category_status')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('settings_category_storage')),
      findsOneWidget,
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

  testWidgets('shows storage subitems and opens complex item editor', (
    tester,
  ) async {
    await tester.pumpWidget(_buildScreen());

    await tester.tap(find.byKey(const ValueKey('settings_category_storage')));
    await tester.pump();

    expect(find.text('Provider'), findsOneWidget);
    expect(find.text('Connected account'), findsOneWidget);
    expect(find.text('Root folder'), findsOneWidget);
    expect(find.text('Photo path template'), findsOneWidget);

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

  testWidgets('direct settings toggle locally without detail screen', (
    tester,
  ) async {
    await tester.pumpWidget(_buildScreen());

    await tester.tap(find.byKey(const ValueKey('settings_category_about')));
    await tester.pump();

    SwitchListTile tile = tester.widget(find.byType(SwitchListTile));
    expect(tile.value, isFalse);

    await tester.tap(find.text('Allow sending debug data'));
    await tester.pump();

    tile = tester.widget(find.byType(SwitchListTile));
    expect(tile.value, isTrue);
  });

  testWidgets('renders Russian settings labels', (tester) async {
    await tester.pumpWidget(_buildScreen(locale: const Locale('ru')));

    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Статус'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('settings_category_storage')));
    await tester.pump();

    expect(find.text('Провайдер'), findsOneWidget);
    expect(find.text('Корневая папка'), findsOneWidget);
  });
}

Widget _buildScreen({Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const SettingsScreen(),
  );
}
