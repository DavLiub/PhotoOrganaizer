import '../../domain/entities/access_profile.dart';
import '../../domain/value_objects/access_decision.dart';
import '../../domain/value_objects/capability.dart';
import '../ports/entitlement_gateway.dart';
import 'access_override.dart';

class AccessPolicy {
  const AccessPolicy({
    required this.entitlementGateway,
    this.override = AccessOverride.none,
  });

  final EntitlementGateway entitlementGateway;
  final AccessOverride override;

  Future<AccessDecision> check(Capability capability) async {
    final overrideDecision = override.decisionFor(capability);
    if (overrideDecision != null) {
      return overrideDecision;
    }

    final profile = await entitlementGateway.currentProfile();

    if (profile.isDisabled(capability)) {
      return AccessDecision.unavailable(
        capability,
        message: 'This capability is not available.',
      );
    }

    if (_premiumCapabilities.contains(capability)) {
      return _checkPremium(capability, profile);
    }

    final limit = profile.limitFor(capability);
    if (limit != null && !profile.hasPremiumAccess) {
      return AccessDecision.limited(
        capability,
        reason: AccessReason.freeTierLimit,
        message: 'This capability is limited on the Free tier.',
        limit: limit,
      );
    }

    return AccessDecision.allowed(capability);
  }

  AccessDecision _checkPremium(Capability capability, AccessProfile profile) {
    if (profile.hasPremiumAccess) {
      return AccessDecision.allowed(capability);
    }

    final reason = profile.entitlementState == EntitlementState.expired
        ? AccessReason.entitlementExpired
        : AccessReason.premiumRequired;

    return AccessDecision.denied(
      capability,
      reason: reason,
      message: 'Premium access is required.',
    );
  }

  static const Set<Capability> _premiumCapabilities = {
    Capability.premiumFeatures,
  };
}
