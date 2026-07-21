import '../../application/ports/entitlement_gateway.dart';

class StaticEntitlementGateway implements EntitlementGateway {
  @override
  Future<AccessLevel> currentAccessLevel() async {
    return AccessLevel.free;
  }
}
