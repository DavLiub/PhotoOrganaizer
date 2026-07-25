import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class BackupProgressScreen extends StatelessWidget {
  const BackupProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupProgress)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SectionPlaceholder(
          icon: Icons.cloud_upload_outlined,
          title: l10n.backupProgress,
          subtitle: l10n.currentBackupJob,
        ),
      ),
    );
  }
}
