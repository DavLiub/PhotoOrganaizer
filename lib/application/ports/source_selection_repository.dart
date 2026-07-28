import '../models/library_category.dart';
import '../models/source_selection.dart';

abstract interface class SourceSelectionRepository {
  Future<SourceSelectionSettings> read();

  Stream<SourceSelectionSettings> watch();

  Future<void> setCategory(LibraryCategory category, {required bool enabled});

  Future<void> setSource(String sourceId, {required bool enabled});
}
