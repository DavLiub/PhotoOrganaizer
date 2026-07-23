import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';
import '../ports/media_permission_gateway.dart';

class CheckMediaAccess {
  const CheckMediaAccess(this._gateway);

  final MediaPermissionGateway _gateway;

  Future<OperationResult<MediaPermission>> call() {
    return _gateway.currentStatus();
  }
}
