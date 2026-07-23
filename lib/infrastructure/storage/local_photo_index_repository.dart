import '../../application/ports/photo_index_repository.dart';
import '../../domain/entities/photo_index_entry.dart';
import '../../domain/models/protection_summary.dart';
import '../../domain/value_objects/photo_identity.dart';

class LocalPhotoIndexRepository implements PhotoIndexRepository {
  @override
  Future<List<PhotoIndexEntry>> findByAssetIds(Set<String> assetIds) async {
    return const [];
  }

  @override
  Future<PhotoIndexEntry?> findByIdentity(PhotoIdentity identity) async {
    return null;
  }

  @override
  Future<void> upsertEntries(List<PhotoIndexEntry> entries) async {}

  @override
  Stream<ProtectionSummary> watchProtectionSummary() {
    return Stream.value(ProtectionSummary.empty());
  }
}
