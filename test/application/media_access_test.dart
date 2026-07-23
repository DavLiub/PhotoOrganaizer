import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/ports/media_permission_gateway.dart';
import 'package:photo_organizer/application/use_cases/check_media_access.dart';
import 'package:photo_organizer/application/use_cases/request_media_access.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';

void main() {
  group('Media access use cases', () {
    test('checks current status through gateway', () async {
      final gateway = _FakeGateway(
        current: const MediaPermission(state: MediaPermissionState.limited),
      );
      final useCase = CheckMediaAccess(gateway);

      final result = await useCase();

      expect(gateway.checkCalls, 1);
      expect(result, isA<OperationSuccess<MediaPermission>>());
      expect(
        (result as OperationSuccess<MediaPermission>).value.state,
        MediaPermissionState.limited,
      );
    });

    test('requests access through gateway', () async {
      final gateway = _FakeGateway(
        requested: const MediaPermission(state: MediaPermissionState.granted),
      );
      final useCase = RequestMediaAccess(gateway);

      final result = await useCase();

      expect(gateway.requestCalls, 1);
      expect(result, isA<OperationSuccess<MediaPermission>>());
      expect(
        (result as OperationSuccess<MediaPermission>).value.state,
        MediaPermissionState.granted,
      );
    });
  });
}

class _FakeGateway implements MediaPermissionGateway {
  _FakeGateway({MediaPermission? current, MediaPermission? requested})
    : _current = current ?? const MediaPermission.unknown(),
      _requested = requested ?? const MediaPermission.unknown();

  final MediaPermission _current;
  final MediaPermission _requested;
  int checkCalls = 0;
  int requestCalls = 0;

  @override
  Future<OperationResult<MediaPermission>> currentStatus() async {
    checkCalls++;
    return OperationSuccess(_current);
  }

  @override
  Future<OperationResult<MediaPermission>> requestAccess() async {
    requestCalls++;
    return OperationSuccess(_requested);
  }
}
