import '../../application/ports/photo_index_repository.dart';
import '../../domain/entities/photo_asset.dart';
import '../../domain/models/protection_summary.dart';

class LocalPhotoIndexRepository implements PhotoIndexRepository {
  @override
  Future<void> upsertPhotos(List<PhotoAsset> photos) async {}

  @override
  Stream<ProtectionSummary> watchProtectionSummary() {
    return Stream.value(ProtectionSummary.empty());
  }
}
