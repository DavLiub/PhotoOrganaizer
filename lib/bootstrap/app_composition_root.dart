import '../application/ports/background_scheduler.dart';
import '../application/ports/cloud_provider.dart';
import '../application/ports/entitlement_gateway.dart';
import '../application/ports/media_library_gateway.dart';
import '../application/ports/media_permission_gateway.dart';
import '../application/ports/observability_sink.dart';
import '../application/ports/photo_index_repository.dart';
import '../application/policies/access_override.dart';
import '../application/policies/access_policy.dart';
import '../application/use_cases/check_media_access.dart';
import '../application/use_cases/index_photos.dart';
import '../application/use_cases/observe_protection_summary_use_case.dart';
import '../application/use_cases/request_media_access.dart';
import '../application/use_cases/resolve_photo_identity.dart';
import '../application/use_cases/start_backup_use_case.dart';
import '../domain/models/protection_summary.dart';
import '../infrastructure/background/work_manager_background_scheduler.dart';
import '../infrastructure/cloud/google_drive_cloud_provider.dart';
import '../infrastructure/entitlements/static_entitlement_gateway.dart';
import '../infrastructure/media/android_media_access.dart';
import '../infrastructure/media/android_media_library_gateway.dart';
import '../infrastructure/observability/console_observability_sink.dart';
import '../infrastructure/storage/local_photo_index_repository.dart';
import 'app_mode.dart';

class AppCompositionRoot {
  AppCompositionRoot._({
    required this.mode,
    required this.mediaLibraryGateway,
    required this.mediaPermissionGateway,
    required this.photoIndexRepository,
    required this.cloudProvider,
    required this.backgroundScheduler,
    required this.entitlementGateway,
    required this.accessPolicy,
    required this.observabilitySink,
    required this.checkMediaAccess,
    required this.indexPhotos,
    required this.requestMediaAccess,
    required this.resolvePhotoIdentity,
    required this.observeProtectionSummary,
    required this.startBackup,
  });

  final AppMode mode;
  final MediaLibraryGateway mediaLibraryGateway;
  final MediaPermissionGateway mediaPermissionGateway;
  final PhotoIndexRepository photoIndexRepository;
  final CloudProvider cloudProvider;
  final BackgroundScheduler backgroundScheduler;
  final EntitlementGateway entitlementGateway;
  final AccessPolicy accessPolicy;
  final ObservabilitySink observabilitySink;
  final CheckMediaAccess checkMediaAccess;
  final IndexPhotos indexPhotos;
  final RequestMediaAccess requestMediaAccess;
  final ResolvePhotoIdentity resolvePhotoIdentity;
  final ObserveProtectionSummaryUseCase observeProtectionSummary;
  final StartBackupUseCase startBackup;

  factory AppCompositionRoot.configure({
    AppMode mode = AppMode.production,
    EntitlementGateway? entitlementGateway,
    AccessOverride accessOverride = AccessOverride.none,
  }) {
    _validateMode(
      mode: mode,
      entitlementGateway: entitlementGateway,
      accessOverride: accessOverride,
    );

    final mediaLibraryGateway = AndroidMediaLibraryGateway();
    const mediaPermissionGateway = AndroidMediaAccess();
    final photoIndexRepository = LocalPhotoIndexRepository();
    final cloudProvider = GoogleDriveCloudProvider();
    final backgroundScheduler = WorkManagerBackgroundScheduler();
    final resolvedEntitlementGateway =
        entitlementGateway ?? const StaticEntitlementGateway();
    final accessPolicy = AccessPolicy(
      entitlementGateway: resolvedEntitlementGateway,
      override: accessOverride,
    );
    final observabilitySink = ConsoleObservabilitySink();

    return AppCompositionRoot._(
      mode: mode,
      mediaLibraryGateway: mediaLibraryGateway,
      mediaPermissionGateway: mediaPermissionGateway,
      photoIndexRepository: photoIndexRepository,
      cloudProvider: cloudProvider,
      backgroundScheduler: backgroundScheduler,
      entitlementGateway: resolvedEntitlementGateway,
      accessPolicy: accessPolicy,
      observabilitySink: observabilitySink,
      checkMediaAccess: CheckMediaAccess(mediaPermissionGateway),
      indexPhotos: IndexPhotos(
        repository: photoIndexRepository,
        permissionGateway: mediaPermissionGateway,
      ),
      requestMediaAccess: RequestMediaAccess(mediaPermissionGateway),
      resolvePhotoIdentity: ResolvePhotoIdentity(photoIndexRepository),
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

  static void _validateMode({
    required AppMode mode,
    required EntitlementGateway? entitlementGateway,
    required AccessOverride accessOverride,
  }) {
    if (mode.allowsTestAccess) {
      return;
    }

    if (accessOverride.isActive) {
      throw StateError('AccessOverride cannot be used in production mode.');
    }

    if (entitlementGateway != null && !entitlementGateway.isProductionSafe) {
      throw StateError(
        'Unsafe EntitlementGateway cannot be used in production mode.',
      );
    }
  }
}
