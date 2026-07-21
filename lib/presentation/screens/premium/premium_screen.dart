import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SectionPlaceholder(
          icon: Icons.workspace_premium_outlined,
          title: 'Premium',
          subtitle: 'Access level',
        ),
      ],
    );
  }
}
