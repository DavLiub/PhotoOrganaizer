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
    final filtered = category == null
        ? library.photos
        : library.photos
              .where((photo) => photo.category == category)
              .toList(growable: false);
    final sorted = filtered.toList(growable: false);

    sorted.sort((left, right) {
      return switch (sort) {
        LibrarySort.dateDesc => _compareDateDesc(left, right),
        LibrarySort.dateAsc => _compareDateAsc(left, right),
        LibrarySort.nameAsc => _compareNameAsc(left, right),
        LibrarySort.nameDesc => _compareNameDesc(left, right),
      };
    });

    return sorted;
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

int _compareDateDesc(LibraryPhoto left, LibraryPhoto right) {
  final dateComparison = right.createdAt.compareTo(left.createdAt);
  if (dateComparison != 0) {
    return dateComparison;
  }

  return _compareNameAsc(left, right);
}

int _compareDateAsc(LibraryPhoto left, LibraryPhoto right) {
  final dateComparison = left.createdAt.compareTo(right.createdAt);
  if (dateComparison != 0) {
    return dateComparison;
  }

  return _compareNameAsc(left, right);
}

int _compareNameAsc(LibraryPhoto left, LibraryPhoto right) {
  final nameComparison = left.displayName.toLowerCase().compareTo(
    right.displayName.toLowerCase(),
  );
  if (nameComparison != 0) {
    return nameComparison;
  }

  return left.id.compareTo(right.id);
}

int _compareNameDesc(LibraryPhoto left, LibraryPhoto right) {
  return _compareNameAsc(right, left);
}
