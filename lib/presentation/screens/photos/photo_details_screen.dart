import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class PhotoDetailsScreen extends StatelessWidget {
  const PhotoDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.photoDetails)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SectionPlaceholder(
          icon: Icons.image_outlined,
          title: l10n.photoDetails,
          subtitle: l10n.photoDetailsSubtitle,
        ),
      ),
    );
  }
}
