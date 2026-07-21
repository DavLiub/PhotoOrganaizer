import '../application/ports/background_scheduler.dart';
import '../application/ports/cloud_provider.dart';
import '../application/ports/entitlement_gateway.dart';
import '../application/ports/media_library_gateway.dart';
import '../application/ports/observability_sink.dart';
import '../application/ports/photo_index_repository.dart';
import '../application/policies/access_policy.dart';
import '../application/use_cases/observe_protection_summary_use_case.dart';
import '../application/use_cases/start_backup_use_case.dart';
import '../domain/models/protection_summary.dart';
import '../infrastructure/background/work_manager_background_scheduler.dart';
import '../infrastructure/cloud/google_drive_cloud_provider.dart';
import '../infrastructure/entitlements/static_entitlement_gateway.dart';
import '../infrastructure/media/android_media_library_gateway.dart';
import '../infrastructure/observability/debug_observability_sink.dart';
import '../infrastructure/storage/local_photo_index_repository.dart';

class AppCompositionRoot {
  AppCompositionRoot._({
    required this.mediaLibraryGateway,
    required this.photoIndexRepository,
    required this.cloudProvider,
    required this.backgroundScheduler,
    required this.entitlementGateway,
    required this.accessPolicy,
    required this.observabilitySink,
    required this.observeProtectionSummary,
    required this.startBackup,
  });

  final MediaLibraryGateway mediaLibraryGateway;
  final PhotoIndexRepository photoIndexRepository;
  final CloudProvider cloudProvider;
  final BackgroundScheduler backgroundScheduler;
  final EntitlementGateway entitlementGateway;
  final AccessPolicy accessPolicy;
  final ObservabilitySink observabilitySink;
  final ObserveProtectionSummaryUseCase observeProtectionSummary;
  final StartBackupUseCase startBackup;

  factory AppCompositionRoot.configure() {
    final mediaLibraryGateway = AndroidMediaLibraryGateway();
    final photoIndexRepository = LocalPhotoIndexRepository();
    final cloudProvider = GoogleDriveCloudProvider();
    final backgroundScheduler = WorkManagerBackgroundScheduler();
    final entitlementGateway = StaticEntitlementGateway();
    final accessPolicy = AccessPolicy(entitlementGateway: entitlementGateway);
    final observabilitySink = DebugObservabilitySink();

    return AppCompositionRoot._(
      mediaLibraryGateway: mediaLibraryGateway,
      photoIndexRepository: photoIndexRepository,
      cloudProvider: cloudProvider,
      backgroundScheduler: backgroundScheduler,
      entitlementGateway: entitlementGateway,
      accessPolicy: accessPolicy,
      observabilitySink: observabilitySink,
      observeProtectionSummary: ObserveProtectionSummaryUseCase(
        initialSummary: ProtectionSummary.empty(),
      ),
      startBackup: StartBackupUseCase(
        mediaLibraryGateway: mediaLibraryGateway,
        photoIndexRepository: photoIndexRepository,
        cloudProvider: cloudProvider,
        backgroundScheduler: backgroundScheduler,
        accessPolicy: accessPolicy,
      ),
    );
  }
}
