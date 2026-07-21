import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SectionPlaceholder(
          icon: Icons.photo_library_outlined,
          title: 'Photos',
          subtitle: 'Indexed photo list',
        ),
      ],
    );
  }
}
