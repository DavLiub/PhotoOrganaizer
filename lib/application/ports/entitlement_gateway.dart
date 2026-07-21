enum AccessLevel { free, premium }

abstract interface class EntitlementGateway {
  Future<AccessLevel> currentAccessLevel();
}
