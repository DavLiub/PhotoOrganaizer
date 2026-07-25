import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class BackupProfileScreen extends StatelessWidget {
  const BackupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SectionPlaceholder(
            icon: Icons.tune_outlined,
            title: l10n.backupProfile,
            subtitle: l10n.qualityAndNetwork,
          ),
        ),
      ),
    );
  }
}
