import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class BackupProfileScreen extends StatelessWidget {
  const BackupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SectionPlaceholder(
            icon: Icons.tune_outlined,
            title: 'Backup profile',
            subtitle: 'Quality and network',
          ),
        ),
      ),
    );
  }
}
