import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class BackupProgressScreen extends StatelessWidget {
  const BackupProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup progress')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SectionPlaceholder(
          icon: Icons.cloud_upload_outlined,
          title: 'Backup progress',
          subtitle: 'Current backup job',
        ),
      ),
    );
  }
}
