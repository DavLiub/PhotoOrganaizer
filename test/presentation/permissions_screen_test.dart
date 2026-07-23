import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/ports/media_permission_gateway.dart';
import 'package:photo_organizer/application/use_cases/check_media_access.dart';
import 'package:photo_organizer/application/use_cases/request_media_access.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/presentation/screens/setup/permissions_screen.dart';

void main() {
  testWidgets('shows current permission status', (tester) async {
    final gateway = _FakeGateway(
      current: const MediaPermission(state: MediaPermissionState.limited),
    );

    await tester.pumpWidget(_buildScreen(gateway));
    await tester.pump();

    expect(find.text('Photo access'), findsOneWidget);
    expect(find.text('Limited'), findsOneWidget);
  });

  testWidgets('requests permission through application use case', (
    tester,
  ) async {
    final gateway = _FakeGateway(
      current: const MediaPermission(state: MediaPermissionState.denied),
      requested: const MediaPermission(state: MediaPermissionState.granted),
    );

    await tester.pumpWidget(_buildScreen(gateway));
    await tester.pump();
    await tester.tap(find.byTooltip('Request photo access'));
    await tester.pumpAndSettle();

    expect(gateway.requestCalls, 1);
    expect(find.text('Granted'), findsOneWidget);
  });
}

Widget _buildScreen(_FakeGateway gateway) {
  return MaterialApp(
    home: PermissionsScreen(
      checkMediaAccess: CheckMediaAccess(gateway),
      requestMediaAccess: RequestMediaAccess(gateway),
    ),
  );
}

class _FakeGateway implements MediaPermissionGateway {
  _FakeGateway({required MediaPermission current, MediaPermission? requested})
    : _current = current,
      _requested = requested ?? current;

  final MediaPermission _current;
  final MediaPermission _requested;
  int requestCalls = 0;

  @override
  Future<OperationResult<MediaPermission>> currentStatus() async {
    return OperationSuccess(_current);
  }

  @override
  Future<OperationResult<MediaPermission>> requestAccess() async {
    requestCalls++;
    return OperationSuccess(_requested);
  }
}
