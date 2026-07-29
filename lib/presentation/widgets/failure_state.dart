import 'package:flutter/material.dart';

import '../theme/app_status_palette.dart';
import 'status_banner.dart';

class FailureState extends StatelessWidget {
  const FailureState({required this.message, this.title, super.key});

  final String message;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StatusBanner(
          title: title ?? message,
          message: title == null ? null : message,
          tone: AppStatusTone.failed,
          icon: Icons.error_outline,
        ),
      ),
    );
  }
}
