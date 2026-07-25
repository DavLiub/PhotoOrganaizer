import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../widgets/section_placeholder.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionPlaceholder(
          icon: Icons.photo_library_outlined,
          title: l10n.photos,
          subtitle: l10n.indexedPhotoList,
        ),
      ],
    );
  }
}
