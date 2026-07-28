import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionPlaceholder(
          icon: Icons.folder_outlined,
          title: l10n.albums,
          subtitle: l10n.albumManagement,
        ),
      ],
    );
  }
}
