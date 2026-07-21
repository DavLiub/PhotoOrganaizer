import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SectionPlaceholder(
          icon: Icons.history_outlined,
          title: 'History',
          subtitle: 'Backup operations',
        ),
      ],
    );
  }
}
