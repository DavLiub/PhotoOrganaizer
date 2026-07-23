enum MediaPermissionState {
  granted,
  limited,
  denied,
  permanentlyDenied,
  unavailable,
  unknown,
}

class MediaPermission {
  const MediaPermission({
    required this.state,
    this.canAskAgain = true,
    this.detailCode,
  });

  const MediaPermission.unknown()
    : state = MediaPermissionState.unknown,
      canAskAgain = true,
      detailCode = null;

  final MediaPermissionState state;
  final bool canAskAgain;
  final String? detailCode;

  bool get canReadPhotos =>
      state == MediaPermissionState.granted ||
      state == MediaPermissionState.limited;

  bool get needsUserAction =>
      state == MediaPermissionState.denied ||
      state == MediaPermissionState.permanentlyDenied ||
      state == MediaPermissionState.unavailable;
}
