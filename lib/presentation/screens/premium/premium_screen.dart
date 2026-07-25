import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionPlaceholder(
          icon: Icons.workspace_premium_outlined,
          title: l10n.premium,
          subtitle: l10n.accessLevel,
        ),
      ],
    );
  }
}
