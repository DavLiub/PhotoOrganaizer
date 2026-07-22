import '../../application/ports/cloud_provider.dart';
import '../../domain/entities/photo_asset.dart';
import '../../domain/value_objects/operation_result.dart';

class GoogleDriveCloudProvider implements CloudProvider {
  @override
  Future<OperationResult<CloudUploadConfirmation>> uploadPhoto(
    PhotoAsset photo,
  ) async {
    return OperationFailure(
      kind: FailureKind.cloudAuth,
      code: 'cloud.not_implemented',
      safeMessage: 'Cloud upload is not implemented yet.',
      userActionRequired: true,
    );
  }
}
