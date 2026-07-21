import 'package:flutter/material.dart';

import '../../widgets/section_placeholder.dart';

class GoogleLoginScreen extends StatelessWidget {
  const GoogleLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SectionPlaceholder(
            icon: Icons.account_circle_outlined,
            title: 'Google account',
            subtitle: 'Drive connection',
          ),
        ),
      ),
    );
  }
}
