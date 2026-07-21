import '../../domain/entities/photo_asset.dart';
import '../../domain/models/protection_summary.dart';

abstract interface class PhotoIndexRepository {
  Future<void> upsertPhotos(List<PhotoAsset> photos);

  Stream<ProtectionSummary> watchProtectionSummary();
}
