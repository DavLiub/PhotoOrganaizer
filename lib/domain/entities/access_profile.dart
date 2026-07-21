import '../value_objects/access_tier.dart';
import '../value_objects/capability.dart';

enum EntitlementState { free, active, expired, unavailable }

class AccessProfile {
  const AccessProfile({
    required this.tier,
    required this.entitlementState,
    this.limits = const {},
    this.disabledCapabilities = const {},
  });

  static const free = AccessProfile(
    tier: AccessTier.free,
    entitlementState: EntitlementState.free,
    limits: {Capability.startBackup: 500},
  );

  static const premium = AccessProfile(
    tier: AccessTier.premium,
    entitlementState: EntitlementState.active,
  );

  static const expiredPremium = AccessProfile(
    tier: AccessTier.premium,
    entitlementState: EntitlementState.expired,
    limits: {Capability.startBackup: 500},
  );

  final AccessTier tier;
  final EntitlementState entitlementState;
  final Map<Capability, int> limits;
  final Set<Capability> disabledCapabilities;

  bool get hasPremiumAccess {
    return tier == AccessTier.premium &&
        entitlementState == EntitlementState.active;
  }

  int? limitFor(Capability capability) {
    return limits[capability];
  }

  bool isDisabled(Capability capability) {
    return disabledCapabilities.contains(capability) ||
        entitlementState == EntitlementState.unavailable;
  }
}
