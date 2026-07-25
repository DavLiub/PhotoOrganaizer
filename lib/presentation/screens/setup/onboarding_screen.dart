import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SectionPlaceholder(
            icon: Icons.shield_outlined,
            title: l10n.protectFirst,
            subtitle: l10n.cleanLater,
          ),
        ),
      ),
    );
  }
}
