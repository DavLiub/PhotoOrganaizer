@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/photo_library.dart';
import 'package:photo_organizer/application/models/source_selection.dart';
import 'package:photo_organizer/application/ports/media_source_repository.dart';
import 'package:photo_organizer/application/ports/source_selection_repository.dart';
import 'package:photo_organizer/application/use_cases/list_media_sources.dart';
import 'package:photo_organizer/domain/entities/media_source.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';

void main() {
  group('ListMediaSources', () {
    test('groups sources by enabled categories', () async {
      final useCase = ListMediaSources(
        mediaSourceRepository: _FakeSources([
          _source(id: 'camera', name: 'Camera', cameraLike: true),
          _source(id: 'screens', name: 'Screenshots'),
        ]),
        sourceSelectionRepository: _FakeSelection(
          SourceSelectionSettings(
            enabledCategories: const {
              LibraryCategory.camera,
              LibraryCategory.social,
              LibraryCategory.downloads,
            },
          ),
        ),
      );

      final result = await useCase();

      expect(result, isA<OperationSuccess<MediaSourceSelection>>());
      final selection =
          (result as OperationSuccess<MediaSourceSelection>).value;
      expect(selection.groups.map((group) => group.category), [
        LibraryCategory.camera,
        LibraryCategory.social,
        LibraryCategory.downloads,
      ]);
      expect(selection.groups.first.sources.single.source.id, 'camera');
    });

    test('marks disabled source as not selected', () async {
      final useCase = ListMediaSources(
        mediaSourceRepository: _FakeSources([
          _source(id: 'camera', name: 'Camera', cameraLike: true),
        ]),
        sourceSelectionRepository: _FakeSelection(
          SourceSelectionSettings.defaults().withSource(
            'camera',
            enabled: false,
          ),
        ),
      );

      final result = await useCase();

      expect(result, isA<OperationSuccess<MediaSourceSelection>>());
      final selection =
          (result as OperationSuccess<MediaSourceSelection>).value;
      expect(selection.groups.first.sources.single.enabled, isFalse);
    });
  });
}

class _FakeSources implements MediaSourceRepository {
  const _FakeSources(this.sources);

  final List<MediaSource> sources;

  @override
  Future<List<MediaSource>> findAll() async {
    return sources;
  }

  @override
  Future<MediaSource?> findById(String id) async {
    for (final source in sources) {
      if (source.id == id) {
        return source;
      }
    }

    return null;
  }

  @override
  Future<void> upsertSources(List<MediaSource> sources) async {}

  @override
  Stream<List<MediaSource>> watchSources() {
    return Stream.value(sources);
  }
}

class _FakeSelection implements SourceSelectionRepository {
  const _FakeSelection(this.settings);

  final SourceSelectionSettings settings;

  @override
  Future<SourceSelectionSettings> read() async {
    return settings;
  }

  @override
  Future<void> setCategory(
    LibraryCategory category, {
    required bool enabled,
  }) async {}

  @override
  Future<void> setSource(String sourceId, {required bool enabled}) async {}

  @override
  Stream<SourceSelectionSettings> watch() {
    return Stream.value(settings);
  }
}

MediaSource _source({
  required String id,
  required String name,
  bool cameraLike = false,
}) {
  return MediaSource(
    id: id,
    provider: 'photo_manager',
    name: name,
    assetCount: 1,
    lastSeenAt: DateTime.utc(2026, 7, 28),
    availabilityStatus: MediaSourceStatus.available,
    cameraLike: cameraLike,
  );
}
