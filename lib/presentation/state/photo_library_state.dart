import '../../application/models/photo_library.dart';

enum PhotoLibraryPhase { loading, loaded, refreshing, failure }

class PhotoLibraryState {
  const PhotoLibraryState({
    required this.phase,
    required this.library,
    this.selectedCategory,
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
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }
}
