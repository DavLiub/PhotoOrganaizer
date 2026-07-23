import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';

abstract interface class MediaPermissionGateway {
  Future<OperationResult<MediaPermission>> currentStatus();

  Future<OperationResult<MediaPermission>> requestAccess();
}
