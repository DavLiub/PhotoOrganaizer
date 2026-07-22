import '../../domain/entities/access_profile.dart';

abstract interface class EntitlementGateway {
  bool get isProductionSafe;

  Future<AccessProfile> currentProfile();
}
