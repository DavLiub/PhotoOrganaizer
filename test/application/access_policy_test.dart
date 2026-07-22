import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/policies/access_override.dart';
import 'package:photo_organizer/application/policies/access_policy.dart';
import 'package:photo_organizer/application/ports/entitlement_gateway.dart';
import 'package:photo_organizer/domain/entities/access_profile.dart';
import 'package:photo_organizer/domain/value_objects/access_decision.dart';
import 'package:photo_organizer/domain/value_objects/access_tier.dart';
import 'package:photo_organizer/domain/value_objects/capability.dart';

void main() {
  group('AccessPolicy', () {
    test('limits backup on free tier', () async {
      final policy = AccessPolicy(
        entitlementGateway: _FakeEntitlementGateway(AccessProfile.free),
      );

      final decision = await policy.check(Capability.startBackup);

      expect(decision.status, AccessStatus.limited);
      expect(decision.reason, AccessReason.freeTierLimit);
      expect(decision.limit, 500);
      expect(decision.canProceed, isTrue);
    });

    test('denies premium capabilities on free tier', () async {
      final policy = AccessPolicy(
        entitlementGateway: _FakeEntitlementGateway(AccessProfile.free),
      );

      final decision = await policy.check(Capability.premiumFeatures);

      expect(decision.status, AccessStatus.denied);
      expect(decision.reason, AccessReason.premiumRequired);
      expect(decision.canProceed, isFalse);
    });

    test('denies premium capabilities when entitlement expired', () async {
      final policy = AccessPolicy(
        entitlementGateway: _FakeEntitlementGateway(
          AccessProfile.expiredPremium,
        ),
      );

      final decision = await policy.check(Capability.premiumFeatures);

      expect(decision.status, AccessStatus.denied);
      expect(decision.reason, AccessReason.entitlementExpired);
    });

    test('marks disabled capability as unavailable', () async {
      final policy = AccessPolicy(
        entitlementGateway: _FakeEntitlementGateway(
          const AccessProfile(
            tier: AccessTier.premium,
            entitlementState: EntitlementState.active,
            disabledCapabilities: {Capability.connectCloud},
          ),
        ),
      );

      final decision = await policy.check(Capability.connectCloud);

      expect(decision.status, AccessStatus.unavailable);
      expect(decision.reason, AccessReason.capabilityUnavailable);
      expect(decision.canProceed, isFalse);
    });

    test('uses test override before entitlement facts', () async {
      final policy = AccessPolicy(
        entitlementGateway: _FakeEntitlementGateway(AccessProfile.premium),
        override: AccessOverride.deny(Capability.startBackup),
      );

      final decision = await policy.check(Capability.startBackup);

      expect(decision.status, AccessStatus.denied);
      expect(decision.reason, AccessReason.forcedDeny);
      expect(decision.canProceed, isFalse);
    });
  });
}

class _FakeEntitlementGateway implements EntitlementGateway {
  const _FakeEntitlementGateway(this.profile);

  final AccessProfile profile;

  @override
  bool get isProductionSafe => true;

  @override
  Future<AccessProfile> currentProfile() async {
    return profile;
  }
}
