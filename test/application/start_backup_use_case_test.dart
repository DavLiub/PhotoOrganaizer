import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/policies/access_override.dart';
import 'package:photo_organizer/application/policies/access_policy.dart';
import 'package:photo_organizer/application/ports/background_scheduler.dart';
import 'package:photo_organizer/application/ports/cloud_provider.dart';
import 'package:photo_organizer/application/ports/entitlement_gateway.dart';
import 'package:photo_organizer/application/ports/media_library_gateway.dart';
import 'package:photo_organizer/application/ports/photo_index_repository.dart';
import 'package:photo_organizer/application/use_cases/start_backup_use_case.dart';
import 'package:photo_organizer/domain/entities/access_profile.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/entities/photo_index_entry.dart';
import 'package:photo_organizer/domain/models/protection_summary.dart';
import 'package:photo_organizer/domain/value_objects/access_decision.dart';
import 'package:photo_organizer/domain/value_objects/capability.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/domain/value_objects/photo_identity.dart';

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
  bool get isProductionSafe => true;

  @override
  Future<AccessProfile> currentProfile() async {
    return profile;
  }
}

class _FakeMediaGateway implements MediaLibraryGateway {
  @override
  Future<LibraryScan> scanLibrary({int pageSize = 100}) async {
    return const LibraryScan.empty();
  }
}

class _FakePhotoIndex implements PhotoIndexRepository {
  @override
  Future<List<PhotoIndexEntry>> findByAssetIds(Set<String> assetIds) async {
    return const [];
  }

  @override
  Future<PhotoIndexEntry?> findByIdentity(PhotoIdentity identity) async {
    return null;
  }

  @override
  Future<void> upsertEntries(List<PhotoIndexEntry> entries) async {}

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
      kind: FailureKind.cloudAuth,
      code: 'not_implemented',
      safeMessage: 'Fake cloud provider does not upload photos.',
    );
  }
}
