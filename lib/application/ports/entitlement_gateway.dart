import '../../domain/entities/access_profile.dart';

abstract interface class EntitlementGateway {
  Future<AccessProfile> currentProfile();
}
