import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bootstrap/app_composition_root.dart';
import '../localization/app_localizations.dart';
import '../navigation/main_scaffold.dart';
import '../state/app_providers.dart';
import '../theme/app_theme.dart';

class SmartPhotoArchiveApp extends StatelessWidget {
  const SmartPhotoArchiveApp({required this.compositionRoot, super.key});

  final AppCompositionRoot compositionRoot;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [appRootProvider.overrideWithValue(compositionRoot)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        home: const MainScaffold(),
      ),
    );
  }
}
