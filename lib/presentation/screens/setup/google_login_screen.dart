import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class GoogleLoginScreen extends StatelessWidget {
  const GoogleLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SectionPlaceholder(
            icon: Icons.account_circle_outlined,
            title: l10n.googleDrive,
            subtitle: l10n.driveConnection,
          ),
        ),
      ),
    );
  }
}
