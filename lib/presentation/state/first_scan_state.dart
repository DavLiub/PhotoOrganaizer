import '../../domain/value_objects/media_permission.dart';

enum FirstScanPhase {
  checking,
  permissionRequired,
  ready,
  scanning,
  complete,
  failure,
}

class FirstScanState {
  const FirstScanState({
    required this.phase,
    this.permission,
    this.foundPhotos = 0,
    this.indexedPhotos = 0,
    this.sourceCount = 0,
    this.errorCode,
  });

  const FirstScanState.initial() : this(phase: FirstScanPhase.checking);

  final FirstScanPhase phase;
  final MediaPermission? permission;
  final int foundPhotos;
  final int indexedPhotos;
  final int sourceCount;
  final String? errorCode;

  bool get isBusy {
    return phase == FirstScanPhase.checking || phase == FirstScanPhase.scanning;
  }

  bool get canReadPhotos {
    return permission?.canReadPhotos ?? false;
  }

  bool get canRequestAccess {
    return !isBusy;
  }

  bool get canScan {
    return canReadPhotos && !isBusy;
  }

  FirstScanState copyWith({
    FirstScanPhase? phase,
    MediaPermission? permission,
    int? foundPhotos,
    int? indexedPhotos,
    int? sourceCount,
    String? errorCode,
    bool clearError = false,
  }) {
    return FirstScanState(
      phase: phase ?? this.phase,
      permission: permission ?? this.permission,
      foundPhotos: foundPhotos ?? this.foundPhotos,
      indexedPhotos: indexedPhotos ?? this.indexedPhotos,
      sourceCount: sourceCount ?? this.sourceCount,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }
}
