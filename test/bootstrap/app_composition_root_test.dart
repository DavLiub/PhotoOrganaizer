import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/policies/access_override.dart';
import 'package:photo_organizer/bootstrap/app_composition_root.dart';
import 'package:photo_organizer/bootstrap/app_mode.dart';
import 'package:photo_organizer/bootstrap/app_platform.dart';
import 'package:photo_organizer/domain/entities/access_profile.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/domain/value_objects/capability.dart';
import 'package:photo_organizer/infrastructure/media/android_media_access.dart';
import 'package:photo_organizer/infrastructure/media/android_media_library_gateway.dart';
import 'package:photo_organizer/infrastructure/media/ios_media_access.dart';
import 'package:photo_organizer/infrastructure/media/ios_media_library_gateway.dart';
import 'package:photo_organizer/infrastructure/media/unsupported_media_access.dart';
import 'package:photo_organizer/infrastructure/media/unsupported_media_library_gateway.dart';
import 'package:photo_organizer/infrastructure/entitlements/test_entitlement_gateway.dart';
import 'package:photo_organizer/infrastructure/storage/media_source_store.dart';

void main() {
  group('AppCompositionRoot', () {
    test('uses production mode by default', () {
      final root = AppCompositionRoot.configure();

      expect(root.mode, AppMode.production);
      expect(root.platform, AppPlatform.android);
    });

    test('selects Android media adapters by default', () {
      final root = AppCompositionRoot.configure();

      expect(root.mediaPermissionGateway, isA<AndroidMediaAccess>());
      expect(root.mediaLibraryGateway, isA<AndroidMediaLibraryGateway>());
      expect(root.mediaSourceRepository, isA<MediaSourceStore>());
    });

    test('selects iOS placeholder media adapters when requested', () async {
      final root = AppCompositionRoot.configure(platform: AppPlatform.ios);

      expect(root.platform, AppPlatform.ios);
      expect(root.mediaPermissionGateway, isA<IosMediaAccess>());
      expect(root.mediaLibraryGateway, isA<IosMediaLibrary>());

      final status = await root.mediaPermissionGateway.currentStatus();

      expect(status, isA<OperationSuccess<MediaPermission>>());
      expect(
        (status as OperationSuccess<MediaPermission>).value.detailCode,
        'media.ios_not_implemented',
      );
    });

    test('selects unsupported placeholder media adapters', () {
      final root = AppCompositionRoot.configure(
        platform: AppPlatform.unsupported,
      );

      expect(root.platform, AppPlatform.unsupported);
      expect(root.mediaPermissionGateway, isA<UnsupportedMediaAccess>());
      expect(root.mediaLibraryGateway, isA<UnsupportedMediaLibrary>());
    });

    test('rejects access override in production mode', () {
      expect(
        () => AppCompositionRoot.configure(
          accessOverride: AccessOverride.deny(Capability.startBackup),
        ),
        throwsStateError,
      );
    });

    test('rejects test entitlement gateway in production mode', () {
      expect(
        () => AppCompositionRoot.configure(
          entitlementGateway: TestEntitlementGateway(AccessProfile.free),
        ),
        throwsStateError,
      );
    });

    test('allows access override in debug mode', () {
      final root = AppCompositionRoot.configure(
        mode: AppMode.debug,
        accessOverride: AccessOverride.allow(Capability.startBackup),
      );

      expect(root.mode, AppMode.debug);
    });

    test('allows test entitlement gateway in test mode', () {
      final root = AppCompositionRoot.configure(
        mode: AppMode.test,
        entitlementGateway: TestEntitlementGateway(AccessProfile.premium),
      );

      expect(root.mode, AppMode.test);
    });
  });

  group('AppMode', () {
    test('parses supported names', () {
      expect(AppMode.fromName('production'), AppMode.production);
      expect(AppMode.fromName('prod'), AppMode.production);
      expect(AppMode.fromName('debug'), AppMode.debug);
      expect(AppMode.fromName('dev'), AppMode.debug);
      expect(AppMode.fromName('test'), AppMode.test);
    });

    test('rejects unsupported names', () {
      expect(() => AppMode.fromName('staging'), throwsArgumentError);
    });
  });

  group('AppPlatform', () {
    test('parses supported names', () {
      expect(appPlatformFromName('android'), AppPlatform.android);
      expect(appPlatformFromName('ios'), AppPlatform.ios);
    });

    test('uses unsupported for unknown names', () {
      expect(appPlatformFromName('windows'), AppPlatform.unsupported);
      expect(appPlatformFromName(null), AppPlatform.unsupported);
    });
  });
}
