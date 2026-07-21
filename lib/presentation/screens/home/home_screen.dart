import 'package:flutter/material.dart';

import '../../../application/use_cases/observe_protection_summary_use_case.dart';
import '../../../application/use_cases/start_backup_use_case.dart';
import '../../../domain/models/protection_summary.dart';
import '../../widgets/section_placeholder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.observeProtectionSummary,
    required this.startBackup,
    super.key,
  });

  final ObserveProtectionSummaryUseCase observeProtectionSummary;
  final StartBackupUseCase startBackup;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProtectionSummary>(
      stream: observeProtectionSummary(),
      builder: (context, snapshot) {
        final summary = snapshot.data ?? ProtectionSummary.empty();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Protection',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${summary.protectedPhotos} of ${summary.totalPhotos}',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Protected photos',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => startBackup(),
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Start backup'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionPlaceholder(
              icon: Icons.sync_outlined,
              title: 'Backup queue',
              subtitle: '${summary.pendingPhotos} pending',
            ),
            const SizedBox(height: 12),
            SectionPlaceholder(
              icon: Icons.error_outline,
              title: 'Attention',
              subtitle: '${summary.failedPhotos} failed',
            ),
          ],
        );
      },
    );
  }
}
