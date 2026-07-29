@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/presentation/theme/app_status_palette.dart';
import 'package:photo_organizer/presentation/theme/app_theme.dart';
import 'package:photo_organizer/presentation/widgets/failure_state.dart';
import 'package:photo_organizer/presentation/widgets/status_badge.dart';
import 'package:photo_organizer/presentation/widgets/status_banner.dart';

void main() {
  testWidgets('status badge uses semantic palette tone', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: const Scaffold(
          body: Center(
            child: StatusBadge(
              label: 'Protected',
              tone: AppStatusTone.protected,
              icon: Icons.verified_outlined,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Protected'), findsOneWidget);
    expect(find.byIcon(Icons.verified_outlined), findsOneWidget);

    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(StatusBadge),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = box.decoration as BoxDecoration;
    final border = decoration.border! as Border;

    expect(decoration.color, AppStatusPalette.light.protectedTone.background);
    expect(border.top.color, AppStatusPalette.light.protectedTone.border);
  });

  testWidgets('failure state renders semantic failure banner', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: const Scaffold(
          body: FailureState(title: 'Scan failed', message: 'media_access'),
        ),
      ),
    );

    expect(find.text('Scan failed'), findsOneWidget);
    expect(find.text('media_access'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);

    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(StatusBanner),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = box.decoration as BoxDecoration;

    expect(decoration.color, AppStatusPalette.light.failedTone.background);
  });
}
