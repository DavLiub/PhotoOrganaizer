import '../../application/ports/media_permission_gateway.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';

class AndroidMediaAccess implements MediaPermissionGateway {
  const AndroidMediaAccess();

  static const _unavailable = MediaPermission(
    state: MediaPermissionState.unavailable,
    canAskAgain: false,
    detailCode: 'media.permission_adapter_deferred',
  );

  @override
  Future<OperationResult<MediaPermission>> currentStatus() async {
    return const OperationSuccess(_unavailable);
  }

  @override
  Future<OperationResult<MediaPermission>> requestAccess() async {
    return const OperationSuccess(_unavailable);
  }
}
