import '../../domain/entities/photo_index_entry.dart';
import '../../domain/models/protection_summary.dart';
import '../../domain/value_objects/photo_identity.dart';

abstract interface class PhotoIndexRepository {
  Future<List<PhotoIndexEntry>> findByAssetIds(Set<String> assetIds);

  Future<PhotoIndexEntry?> findByIdentity(PhotoIdentity identity);

  Future<void> upsertEntries(List<PhotoIndexEntry> entries);

  Stream<ProtectionSummary> watchProtectionSummary();
}
