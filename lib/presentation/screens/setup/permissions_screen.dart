import 'package:flutter/material.dart';

import '../../../application/use_cases/check_media_access.dart';
import '../../../application/use_cases/request_media_access.dart';
import '../../../domain/value_objects/media_permission.dart';
import '../../../domain/value_objects/operation_result.dart';

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
                  title: const Text('Photo access'),
                  subtitle: Text(_subtitle(result)),
                  trailing: IconButton(
                    tooltip: 'Request photo access',
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

  String _subtitle(OperationResult<MediaPermission>? result) {
    return switch (result) {
      OperationSuccess<MediaPermission>(value: final value) => _statusText(
        value,
      ),
      OperationFailure<MediaPermission>(failure: final failure) =>
        failure.safeMessage ?? failure.code,
      null => 'Checking',
    };
  }

  String _statusText(MediaPermission permission) {
    return switch (permission.state) {
      MediaPermissionState.granted => 'Granted',
      MediaPermissionState.limited => 'Limited',
      MediaPermissionState.denied => 'Denied',
      MediaPermissionState.permanentlyDenied => 'Permanently denied',
      MediaPermissionState.unavailable => 'Unavailable',
      MediaPermissionState.unknown => 'Unknown',
    };
  }
}
