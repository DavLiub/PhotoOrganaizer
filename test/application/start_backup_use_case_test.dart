import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organaizer/application/policies/access_override.dart';
import 'package:photo_organaizer/application/policies/access_policy.dart';
import 'package:photo_organaizer/application/ports/background_scheduler.dart';
import 'package:photo_organaizer/application/ports/cloud_provider.dart';
import 'package:photo_organaizer/application/ports/entitlement_gateway.dart';
import 'package:photo_organaizer/application/ports/media_library_gateway.dart';
import 'package:photo_organaizer/application/ports/photo_index_repository.dart';
import 'package:photo_organaizer/application/use_cases/start_backup_use_case.dart';
import 'package:photo_organaizer/domain/entities/access_profile.dart';
import 'package:photo_organaizer/domain/entities/photo_asset.dart';
import 'package:photo_organaizer/domain/models/protection_summary.dart';
import 'package:photo_organaizer/domain/value_objects/access_decision.dart';
import 'package:photo_organaizer/domain/value_objects/capability.dart';
import 'package:photo_organaizer/domain/value_objects/operation_result.dart';

void main() {
  group('StartBackupUseCase', () {
    test('schedules backup when access can proceed', () async {
      final scheduler = _FakeScheduler();
      final useCase = _buildUseCase(
        scheduler: scheduler,
        policy: AccessPolicy(
          entitlementGateway: _FakeEntitlementGateway(AccessProfile.free),
        ),
      );

      final decision = await useCase();

      expect(decision.status, AccessStatus.limited);
      expect(scheduler.scheduleCalls, 1);
    });

    test('does not schedule backup when access is denied', () async {
      final scheduler = _FakeScheduler();
      final useCase = _buildUseCase(
        scheduler: scheduler,
        policy: AccessPolicy(
          entitlementGateway: _FakeEntitlementGateway(AccessProfile.premium),
          override: AccessOverride.deny(Capability.startBackup),
        ),
      );

      final decision = await useCase();

      expect(decision.status, AccessStatus.denied);
      expect(scheduler.scheduleCalls, 0);
    });
  });
}

StartBackupUseCase _buildUseCase({
  required BackgroundScheduler scheduler,
  required AccessPolicy policy,
}) {
  return StartBackupUseCase(
    mediaLibraryGateway: _FakeMediaGateway(),
    photoIndexRepository: _FakePhotoIndex(),
    cloudProvider: _FakeCloudProvider(),
    backgroundScheduler: scheduler,
    accessPolicy: policy,
  );
}

class _FakeScheduler implements BackgroundScheduler {
  int scheduleCalls = 0;

  @override
  Future<void> scheduleBackup() async {
    scheduleCalls++;
  }
}

class _FakeEntitlementGateway implements EntitlementGateway {
  const _FakeEntitlementGateway(this.profile);

  final AccessProfile profile;

  @override
  Future<AccessProfile> currentProfile() async {
    return profile;
  }
}

class _FakeMediaGateway implements MediaLibraryGateway {
  @override
  Future<List<PhotoAsset>> scanPhotos() async {
    return const [];
  }
}

class _FakePhotoIndex implements PhotoIndexRepository {
  @override
  Future<void> upsertPhotos(List<PhotoAsset> photos) async {}

  @override
  Stream<ProtectionSummary> watchProtectionSummary() {
    return Stream.value(ProtectionSummary.empty());
  }
}

class _FakeCloudProvider implements CloudProvider {
  @override
  Future<OperationResult<CloudUploadConfirmation>> uploadPhoto(
    PhotoAsset photo,
  ) async {
    return OperationFailure(
      code: 'not_implemented',
      message: 'Fake cloud provider does not upload photos.',
    );
  }
}
