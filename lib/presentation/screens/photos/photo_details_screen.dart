import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class PhotoDetailsScreen extends StatelessWidget {
  const PhotoDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo details')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SectionPlaceholder(
          icon: Icons.image_outlined,
          title: 'Photo details',
          subtitle: 'Backup status and cloud location',
        ),
      ),
    );
  }
}
