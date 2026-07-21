import 'capability.dart';

enum AccessStatus { allowed, limited, denied, unavailable }

enum AccessReason {
  none,
  freeTierLimit,
  premiumRequired,
  entitlementExpired,
  capabilityUnavailable,
  forcedAllow,
  forcedDeny,
  forcedLimit,
}

class AccessDecision {
  const AccessDecision({
    required this.capability,
    required this.status,
    required this.reason,
    required this.message,
    this.limit,
  });

  factory AccessDecision.allowed(
    Capability capability, {
    AccessReason reason = AccessReason.none,
    String message = 'Access allowed.',
  }) {
    return AccessDecision(
      capability: capability,
      status: AccessStatus.allowed,
      reason: reason,
      message: message,
    );
  }

  factory AccessDecision.limited(
    Capability capability, {
    required AccessReason reason,
    required String message,
    int? limit,
  }) {
    return AccessDecision(
      capability: capability,
      status: AccessStatus.limited,
      reason: reason,
      message: message,
      limit: limit,
    );
  }

  factory AccessDecision.denied(
    Capability capability, {
    required AccessReason reason,
    required String message,
  }) {
    return AccessDecision(
      capability: capability,
      status: AccessStatus.denied,
      reason: reason,
      message: message,
    );
  }

  factory AccessDecision.unavailable(
    Capability capability, {
    required String message,
  }) {
    return AccessDecision(
      capability: capability,
      status: AccessStatus.unavailable,
      reason: AccessReason.capabilityUnavailable,
      message: message,
    );
  }

  final Capability capability;
  final AccessStatus status;
  final AccessReason reason;
  final String message;
  final int? limit;

  bool get canProceed {
    return status == AccessStatus.allowed || status == AccessStatus.limited;
  }
}
