import '../../domain/value_objects/access_decision.dart';
import '../../domain/value_objects/capability.dart';

class AccessOverride {
  const AccessOverride(this._decisions);

  static const none = AccessOverride({});

  factory AccessOverride.allow(Capability capability) {
    return AccessOverride({
      capability: AccessDecision.allowed(
        capability,
        reason: AccessReason.forcedAllow,
        message: 'Access was allowed by test override.',
      ),
    });
  }

  factory AccessOverride.deny(Capability capability) {
    return AccessOverride({
      capability: AccessDecision.denied(
        capability,
        reason: AccessReason.forcedDeny,
        message: 'Access was denied by test override.',
      ),
    });
  }

  factory AccessOverride.limit(Capability capability, {required int limit}) {
    return AccessOverride({
      capability: AccessDecision.limited(
        capability,
        reason: AccessReason.forcedLimit,
        message: 'Access was limited by test override.',
        limit: limit,
      ),
    });
  }

  final Map<Capability, AccessDecision> _decisions;

  bool get isActive => _decisions.isNotEmpty;

  AccessDecision? decisionFor(Capability capability) {
    return _decisions[capability];
  }
}
