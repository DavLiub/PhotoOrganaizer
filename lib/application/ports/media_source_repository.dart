import '../../domain/entities/media_source.dart';

abstract interface class MediaSourceRepository {
  Future<List<MediaSource>> findAll();

  Future<MediaSource?> findById(String id);

  Future<void> upsertSources(List<MediaSource> sources);

  Stream<List<MediaSource>> watchSources();
}
