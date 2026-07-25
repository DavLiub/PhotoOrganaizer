import 'package:flutter/material.dart';

import '../../../application/use_cases/check_media_access.dart';
import '../../../application/use_cases/request_media_access.dart';
import '../../../domain/value_objects/media_permission.dart';
import '../../../domain/value_objects/operation_result.dart';
import '../../localization/app_localizations.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({
    required this.checkMediaAccess,
    required this.requestMediaAccess,
    super.key,
  });

  final CheckMediaAccess checkMediaAccess;
  final RequestMediaAccess requestMediaAccess;

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  late Future<OperationResult<MediaPermission>> _status;

  @override
  void initState() {
    super.initState();
    _status = widget.checkMediaAccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: FutureBuilder<OperationResult<MediaPermission>>(
            future: _status,
            builder: (context, snapshot) {
              final result = snapshot.data;

              return Card(
                child: ListTile(
                  leading: Icon(_icon(result)),
                  title: Text(AppLocalizations.of(context).photoAccess),
                  subtitle: Text(_subtitle(context, result)),
                  trailing: IconButton(
                    tooltip: AppLocalizations.of(context).grantAccess,
                    icon: const Icon(Icons.lock_open_outlined),
                    onPressed: _requestAccess,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _requestAccess() {
    setState(() {
      _status = widget.requestMediaAccess();
    });
  }

  IconData _icon(OperationResult<MediaPermission>? result) {
    return switch (result) {
      OperationSuccess<MediaPermission>(value: final value)
          when value.canReadPhotos =>
        Icons.photo_library,
      OperationSuccess<MediaPermission>() => Icons.photo_library_outlined,
      OperationFailure<MediaPermission>() => Icons.error_outline,
      null => Icons.hourglass_empty,
    };
  }

  String _subtitle(
    BuildContext context,
    OperationResult<MediaPermission>? result,
  ) {
    final l10n = AppLocalizations.of(context);

    return switch (result) {
      OperationSuccess<MediaPermission>(value: final value) => _statusText(
        l10n,
        value,
      ),
      OperationFailure<MediaPermission>(failure: final failure) =>
        failure.safeMessage ?? failure.code,
      null => l10n.checkingAccess,
    };
  }

  String _statusText(AppLocalizations l10n, MediaPermission permission) {
    return switch (permission.state) {
      MediaPermissionState.granted => l10n.permissionGranted,
      MediaPermissionState.limited => l10n.permissionLimited,
      MediaPermissionState.denied => l10n.permissionDenied,
      MediaPermissionState.permanentlyDenied => l10n.permissionBlocked,
      MediaPermissionState.unavailable => l10n.permissionUnavailable,
      MediaPermissionState.unknown => l10n.permissionUnknown,
    };
  }
}
