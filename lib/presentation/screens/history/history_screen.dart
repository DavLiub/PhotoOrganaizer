import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionPlaceholder(
          icon: Icons.history_outlined,
          title: l10n.history,
          subtitle: l10n.backupOperations,
        ),
      ],
    );
  }
}
