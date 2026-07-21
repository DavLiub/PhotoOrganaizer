import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SectionPlaceholder(
            icon: Icons.shield_outlined,
            title: 'Protect first',
            subtitle: 'Clean later',
          ),
        ),
      ),
    );
  }
}
