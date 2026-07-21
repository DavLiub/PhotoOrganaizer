import '../../application/ports/entitlement_gateway.dart';
import '../../domain/entities/access_profile.dart';

class StaticEntitlementGateway implements EntitlementGateway {
  const StaticEntitlementGateway({this.profile = AccessProfile.free});

  final AccessProfile profile;

  @override
  Future<AccessProfile> currentProfile() async {
    return profile;
  }
}
