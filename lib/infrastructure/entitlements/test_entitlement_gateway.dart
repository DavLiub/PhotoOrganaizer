import '../../application/ports/entitlement_gateway.dart';
import '../../domain/entities/access_profile.dart';

class TestEntitlementGateway implements EntitlementGateway {
  TestEntitlementGateway(this._profile);

  AccessProfile _profile;

  @override
  bool get isProductionSafe => false;

  void setProfile(AccessProfile profile) {
    _profile = profile;
  }

  @override
  Future<AccessProfile> currentProfile() async {
    return _profile;
  }
}
