import 'package:photo_manager/photo_manager.dart' as pm;

import '../../application/ports/media_permission_gateway.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';

typedef PermissionRead = Future<pm.PermissionState> Function();

class AndroidMediaAccess implements MediaPermissionGateway {
  const AndroidMediaAccess({
    PermissionRead readPermission = _readPermission,
    PermissionRead requestPermission = _requestPermission,
  }) : _readPermissionState = readPermission,
       _requestPermissionState = requestPermission;

  static const _requestOption = pm.PermissionRequestOption(
    androidPermission: pm.AndroidPermission(
      type: pm.RequestType.image,
      mediaLocation: false,
    ),
  );

  final PermissionRead _readPermissionState;
  final PermissionRead _requestPermissionState;

  @override
  Future<OperationResult<MediaPermission>> currentStatus() async {
    try {
      final state = await _readPermissionState();
      return OperationSuccess(_mapState(state));
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.media,
        code: 'media.permission_check_failed',
        safeMessage: 'Photo permission status could not be read.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }
  }

  @override
  Future<OperationResult<MediaPermission>> requestAccess() async {
    try {
      final state = await _requestPermissionState();
      return OperationSuccess(_mapState(state));
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.userAction,
        code: 'media.permission_request_failed',
        safeMessage: 'Photo permission request could not be completed.',
        retryable: true,
        userActionRequired: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }
  }

  static Future<pm.PermissionState> _readPermission() {
    return pm.PhotoManager.getPermissionState(requestOption: _requestOption);
  }

  static Future<pm.PermissionState> _requestPermission() {
    return pm.PhotoManager.requestPermissionExtend(
      requestOption: _requestOption,
    );
  }
}

MediaPermission _mapState(pm.PermissionState state) {
  return switch (state) {
    pm.PermissionState.authorized => MediaPermission(
      state: MediaPermissionState.granted,
      canAskAgain: false,
      detailCode: 'photo_manager.${state.name}',
    ),
    pm.PermissionState.limited => MediaPermission(
      state: MediaPermissionState.limited,
      detailCode: 'photo_manager.${state.name}',
    ),
    pm.PermissionState.denied => MediaPermission(
      state: MediaPermissionState.denied,
      detailCode: 'photo_manager.${state.name}',
    ),
    pm.PermissionState.restricted => MediaPermission(
      state: MediaPermissionState.permanentlyDenied,
      canAskAgain: false,
      detailCode: 'photo_manager.${state.name}',
    ),
    pm.PermissionState.notDetermined => MediaPermission(
      state: MediaPermissionState.unknown,
      detailCode: 'photo_manager.${state.name}',
    ),
  };
}
