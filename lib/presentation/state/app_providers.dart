import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bootstrap/app_composition_root.dart';
import 'first_scan_actions.dart';
import 'photo_library_actions.dart';
import 'source_selection_actions.dart';

final appRootProvider = Provider<AppCompositionRoot>((ref) {
  throw UnimplementedError('AppCompositionRoot was not provided.');
});

final firstScanActionsProvider = Provider<FirstScanActions>((ref) {
  final root = ref.watch(appRootProvider);

  return FirstScanActions(
    checkAccess: root.checkMediaAccess.call,
    requestAccess: root.requestMediaAccess.call,
    scanLibrary: ({int pageSize = 100, onProgress, signal}) {
      return root.scanMediaLibrary(
        pageSize: pageSize,
        onProgress: onProgress,
        signal: signal,
      );
    },
  );
});

final photoLibraryActionsProvider = Provider<PhotoLibraryActions>((ref) {
  final root = ref.watch(appRootProvider);

  return PhotoLibraryActions(
    listPhotos: root.listLibraryPhotos.call,
    loadThumbnail: root.photoThumbnailGateway.loadThumbnail,
    refreshLibrary: ({int pageSize = 100, onProgress, signal}) {
      return root.scanMediaLibrary(
        pageSize: pageSize,
        onProgress: onProgress,
        signal: signal,
      );
    },
  );
});

final sourceSelectionActionsProvider = Provider<SourceSelectionActions>((ref) {
  final root = ref.watch(appRootProvider);

  return SourceSelectionActions(
    listSources: root.listMediaSources.call,
    setCategory: root.updateSourceSelection.setCategory,
    setSource: root.updateSourceSelection.setSource,
  );
});
