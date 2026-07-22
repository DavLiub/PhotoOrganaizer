import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/policies/access_override.dart';
import 'package:photo_organizer/bootstrap/app_composition_root.dart';
import 'package:photo_organizer/bootstrap/app_mode.dart';
import 'package:photo_organizer/domain/entities/access_profile.dart';
import 'package:photo_organizer/domain/value_objects/capability.dart';
import 'package:photo_organizer/infrastructure/entitlements/test_entitlement_gateway.dart';

void main() {
  group('AppCompositionRoot', () {
    test('uses production mode by default', () {
      final root = AppCompositionRoot.configure();

      expect(root.mode, AppMode.production);
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
}
