import '../../application/models/library_category.dart';
import '../../application/models/source_selection.dart';
import '../../domain/value_objects/operation_result.dart';

typedef ListSources = Future<OperationResult<MediaSourceSelection>> Function();

typedef SetCategory =
    Future<OperationResult<SourceSelectionSettings>> Function(
      LibraryCategory category, {
      required bool enabled,
    });

typedef SetSource =
    Future<OperationResult<SourceSelectionSettings>> Function(
      String sourceId, {
      required bool enabled,
    });

class SourceSelectionActions {
  const SourceSelectionActions({
    required this.listSources,
    required this.setCategory,
    required this.setSource,
  });

  final ListSources listSources;
  final SetCategory setCategory;
  final SetSource setSource;
}
