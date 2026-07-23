import '../../application/ports/media_permission_gateway.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';

class IosMediaAccess implements MediaPermissionGateway {
  const IosMediaAccess();

  static const _unavailable = MediaPermission(
    state: MediaPermissionState.unavailable,
    canAskAgain: false,
    detailCode: 'media.ios_not_implemented',
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
