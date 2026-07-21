import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SectionPlaceholder(
            icon: Icons.photo_library_outlined,
            title: 'Photo access',
            subtitle: 'Android media permission',
          ),
        ),
      ),
    );
  }
}
