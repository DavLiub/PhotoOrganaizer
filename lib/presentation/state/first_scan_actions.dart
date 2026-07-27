import '../../application/use_cases/scan_media_library.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';

typedef CheckAccess = Future<OperationResult<MediaPermission>> Function();
typedef RequestAccess = Future<OperationResult<MediaPermission>> Function();
typedef ScanLibrary =
    Future<OperationResult<LibraryScanResult>> Function({
      int pageSize,
      ScanProgressCallback? onProgress,
    });

class FirstScanActions {
  const FirstScanActions({
    required this.checkAccess,
    required this.requestAccess,
    required this.scanLibrary,
  });

  final CheckAccess checkAccess;
  final RequestAccess requestAccess;
  final ScanLibrary scanLibrary;
}
