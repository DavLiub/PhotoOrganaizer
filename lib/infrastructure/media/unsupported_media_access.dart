import '../../application/ports/media_permission_gateway.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';

class UnsupportedMediaAccess implements MediaPermissionGateway {
  const UnsupportedMediaAccess();

  static const _unavailable = MediaPermission(
    state: MediaPermissionState.unavailable,
    canAskAgain: false,
    detailCode: 'media.platform_unsupported',
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
