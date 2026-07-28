@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/presentation/localization/app_localizations.dart';
import 'package:photo_organizer/presentation/screens/settings/settings_screen.dart';

void main() {
  testWidgets('renders grouped settings shell', (tester) async {
    await tester.pumpWidget(_buildScreen());

    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Free plan'), findsOneWidget);
    expect(find.text('Storage is not connected'), findsOneWidget);
    expect(find.text('Storage'), findsNWidgets(2));
    expect(find.text('Provider'), findsOneWidget);
    expect(find.text('Root folder'), findsOneWidget);
    expect(find.text('Photo path template'), findsOneWidget);
    expect(find.text('Media Library'), findsOneWidget);
    expect(find.text('Backup Configuration'), findsOneWidget);
    expect(find.text('Background Work'), findsOneWidget);
    expect(find.text('Language'), findsNWidgets(2));
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Allow sending debug data'), findsOneWidget);
  });

  testWidgets('opens placeholder detail screen from setting row', (
    tester,
  ) async {
    await tester.pumpWidget(_buildScreen());

    await tester.tap(find.text('Provider'));
    await tester.pumpAndSettle();

    expect(find.text('Provider'), findsWidgets);
    expect(
      find.text('Configuration persistence will be added in a later PR.'),
      findsOneWidget,
    );
  });

  testWidgets('diagnostics consent checkbox toggles locally', (tester) async {
    await tester.pumpWidget(_buildScreen());

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
    expect(find.text('Статус'), findsOneWidget);
    expect(find.text('Хранилище'), findsNWidgets(2));
    expect(find.text('Настройки бэкапа'), findsOneWidget);
    expect(find.text('Фоновая работа'), findsOneWidget);
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
