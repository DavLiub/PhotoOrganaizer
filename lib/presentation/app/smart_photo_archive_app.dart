import 'package:flutter/material.dart';

import '../../bootstrap/app_composition_root.dart';
import '../navigation/main_scaffold.dart';
import '../theme/app_theme.dart';

class SmartPhotoArchiveApp extends StatelessWidget {
  const SmartPhotoArchiveApp({required this.compositionRoot, super.key});

  final AppCompositionRoot compositionRoot;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Photo Archive',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      home: MainScaffold(compositionRoot: compositionRoot),
    );
  }
}
