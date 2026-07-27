import '../../application/models/photo_library.dart';

enum PhotoLibraryPhase { loading, loaded, refreshing, failure }

class PhotoLibraryState {
  const PhotoLibraryState({
    required this.phase,
    required this.library,
    this.selectedCategory,
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
  final LibraryCategory? selectedCategory;
  final int foundPhotos;
  final int indexedPhotos;
  final int sourceCount;
  final String? errorCode;

  bool get isBusy {
    return phase == PhotoLibraryPhase.loading ||
        phase == PhotoLibraryPhase.refreshing;
  }

  bool get hasPhotos => library.photos.isNotEmpty;

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
    LibraryCategory? selectedCategory,
    int? foundPhotos,
    int? indexedPhotos,
    int? sourceCount,
    bool clearCategory = false,
    String? errorCode,
    bool clearError = false,
  }) {
    return PhotoLibraryState(
      phase: phase ?? this.phase,
      library: library ?? this.library,
      selectedCategory: clearCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      foundPhotos: foundPhotos ?? this.foundPhotos,
      indexedPhotos: indexedPhotos ?? this.indexedPhotos,
      sourceCount: sourceCount ?? this.sourceCount,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }
}
