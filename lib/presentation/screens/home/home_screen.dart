import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/value_objects/media_permission.dart';
import '../../localization/app_localizations.dart';
import '../../state/first_scan_controller.dart';
import '../../state/first_scan_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(firstScanProvider);
    final controller = ref.read(firstScanProvider.notifier);

    if (!state.canReadPhotos) {
      return _WelcomeScreen(
        state: state,
        onGrantAccess: controller.requestAccess,
      );
    }

    return _FirstScanScreen(state: state, onScan: controller.scan);
  }
}

class _WelcomeScreen extends StatelessWidget {
  const _WelcomeScreen({required this.state, required this.onGrantAccess});

  final FirstScanState state;
  final VoidCallback onGrantAccess;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 24),
        Icon(
          Icons.photo_library_outlined,
          size: 56,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.welcomeTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.welcomeSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: Icon(_permissionIcon(state.permission)),
            title: Text(l10n.photoAccess),
            subtitle: Text(_permissionText(l10n, state.permission)),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: state.canRequestAccess ? onGrantAccess : null,
          icon: const Icon(Icons.lock_open_outlined),
          label: Text(l10n.grantAccess),
        ),
        if (state.isBusy) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
        ],
      ],
    );
  }

  IconData _permissionIcon(MediaPermission? permission) {
    return switch (permission?.state) {
      MediaPermissionState.denied => Icons.lock_outline,
      MediaPermissionState.permanentlyDenied => Icons.block,
      MediaPermissionState.unavailable => Icons.error_outline,
      _ => Icons.hourglass_empty,
    };
  }

  String _permissionText(AppLocalizations l10n, MediaPermission? permission) {
    if (permission == null) {
      return l10n.checkingAccess;
    }

    return switch (permission.state) {
      MediaPermissionState.granted => l10n.permissionGranted,
      MediaPermissionState.limited => l10n.permissionLimited,
      MediaPermissionState.denied => l10n.photoAccessRequired,
      MediaPermissionState.permanentlyDenied => l10n.permissionBlocked,
      MediaPermissionState.unavailable => l10n.permissionUnavailable,
      MediaPermissionState.unknown => l10n.permissionUnknown,
    };
  }
}

class _FirstScanScreen extends StatelessWidget {
  const _FirstScanScreen({required this.state, required this.onScan});

  final FirstScanState state;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.firstScanTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.firstScanSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        if (state.isBusy) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
        ],
        FilledButton.icon(
          onPressed: state.canScan ? onScan : null,
          icon: const Icon(Icons.search_outlined),
          label: Text(l10n.scan),
        ),
        const SizedBox(height: 16),
        _ScanStatus(state: state),
        const SizedBox(height: 12),
        _MetricGrid(state: state),
      ],
    );
  }
}

class _ScanStatus extends StatelessWidget {
  const _ScanStatus({required this.state});

  final FirstScanState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final failed = state.phase == FirstScanPhase.failure;

    return Card(
      color: failed ? colorScheme.errorContainer : null,
      child: ListTile(
        leading: Icon(
          _icon(state.phase),
          color: failed ? colorScheme.onErrorContainer : null,
        ),
        title: Text(
          _statusText(l10n, state.phase),
          style: TextStyle(color: failed ? colorScheme.onErrorContainer : null),
        ),
        subtitle: state.errorCode == null ? null : Text(state.errorCode!),
      ),
    );
  }

  IconData _icon(FirstScanPhase phase) {
    return switch (phase) {
      FirstScanPhase.checking => Icons.hourglass_empty,
      FirstScanPhase.permissionRequired => Icons.lock_outline,
      FirstScanPhase.ready => Icons.check_circle_outline,
      FirstScanPhase.scanning => Icons.sync_outlined,
      FirstScanPhase.complete => Icons.task_alt,
      FirstScanPhase.failure => Icons.error_outline,
    };
  }

  String _statusText(AppLocalizations l10n, FirstScanPhase phase) {
    return switch (phase) {
      FirstScanPhase.checking => l10n.checkingAccess,
      FirstScanPhase.permissionRequired => l10n.photoAccessRequired,
      FirstScanPhase.ready => l10n.readyToScan,
      FirstScanPhase.scanning => l10n.scanningLibrary,
      FirstScanPhase.complete => l10n.scanComplete,
      FirstScanPhase.failure => l10n.scanFailed,
    };
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.state});

  final FirstScanState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 3 : 1;

        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: columns == 1 ? 4.4 : 2.4,
          children: [
            _MetricTile(
              icon: Icons.image_search_outlined,
              label: l10n.foundPhotos,
              value: state.foundPhotos,
            ),
            _MetricTile(
              icon: Icons.inventory_2_outlined,
              label: l10n.indexedPhotos,
              value: state.indexedPhotos,
            ),
            _MetricTile(
              icon: Icons.folder_outlined,
              label: l10n.discoveredSources,
              value: state.sourceCount,
            ),
          ],
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
