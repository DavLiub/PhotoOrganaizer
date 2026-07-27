import '../../application/models/photo_library.dart';

enum LibraryFilter { all, camera, social, downloads, screenshots }

enum LibrarySort { dateDesc, dateAsc, nameAsc, nameDesc }

enum PhotoLibraryPhase { loading, loaded, refreshing, failure }

class PhotoLibraryState {
  const PhotoLibraryState({
    required this.phase,
    required this.library,
    this.filter = LibraryFilter.all,
    this.sort = LibrarySort.dateDesc,
    this.foundPhotos = 0,
    this.indexedPhotos = 0,
    this.sourceCount = 0,
    this.errorCode,
  });

  const PhotoLibraryState.initial()
    : this(
        phase: PhotoLibraryPhase.loading,
        library: const PhotoLibrary.empty(),
      );

  final PhotoLibraryPhase phase;
  final PhotoLibrary library;
  final LibraryFilter filter;
  final LibrarySort sort;
  final int foundPhotos;
  final int indexedPhotos;
  final int sourceCount;
  final String? errorCode;

  bool get isBusy {
    return phase == PhotoLibraryPhase.loading ||
        phase == PhotoLibraryPhase.refreshing;
  }

  bool get hasPhotos => library.photos.isNotEmpty;

  LibraryCategory? get selectedCategory {
    return switch (filter) {
      LibraryFilter.all => null,
      LibraryFilter.camera => LibraryCategory.camera,
      LibraryFilter.social => LibraryCategory.social,
      LibraryFilter.downloads => LibraryCategory.downloads,
      LibraryFilter.screenshots => LibraryCategory.screenshots,
    };
  }

  List<LibraryPhoto> get visiblePhotos {
    final category = selectedCategory;
    if (category == null) {
      return library.photos;
    }

    return library.photos
        .where((photo) => photo.category == category)
        .toList(growable: false);
  }

  PhotoLibraryState copyWith({
    PhotoLibraryPhase? phase,
    PhotoLibrary? library,
    LibraryFilter? filter,
    LibrarySort? sort,
    int? foundPhotos,
    int? indexedPhotos,
    int? sourceCount,
    String? errorCode,
    bool clearError = false,
  }) {
    return PhotoLibraryState(
      phase: phase ?? this.phase,
      library: library ?? this.library,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      foundPhotos: foundPhotos ?? this.foundPhotos,
      indexedPhotos: indexedPhotos ?? this.indexedPhotos,
      sourceCount: sourceCount ?? this.sourceCount,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }
}
