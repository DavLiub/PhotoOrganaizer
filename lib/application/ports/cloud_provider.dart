import '../../domain/entities/photo_asset.dart';
import '../../domain/value_objects/operation_result.dart';

class CloudUploadConfirmation {
  const CloudUploadConfirmation({
    required this.cloudObjectId,
    required this.confirmedAt,
  });

  final String cloudObjectId;
  final DateTime confirmedAt;
}

abstract interface class CloudProvider {
  Future<OperationResult<CloudUploadConfirmation>> uploadPhoto(
    PhotoAsset photo,
  );
}
