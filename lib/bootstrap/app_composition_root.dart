import '../application/ports/background_scheduler.dart';
import '../application/ports/app_settings_repository.dart';
import '../application/ports/cloud_provider.dart';
import '../application/ports/entitlement_gateway.dart';
import '../application/ports/media_library_gateway.dart';
import '../application/ports/media_permission_gateway.dart';
import '../application/ports/media_source_repository.dart';
import '../application/ports/observability_sink.dart';
import '../application/ports/photo_index_repository.dart';
import '../application/ports/photo_thumbnail_gateway.dart';
import '../application/ports/source_selection_repository.dart';
import '../application/policies/access_override.dart';
import '../application/policies/access_policy.dart';
import '../application/use_cases/check_media_access.dart';
import '../application/use_cases/index_photos.dart';
import '../application/use_cases/list_media_sources.dart';
import '../application/use_cases/list_library_photos.dart';
import '../application/use_cases/observe_protection_summary_use_case.dart';
import '../application/use_cases/read_app_settings.dart';
import '../application/use_cases/request_media_access.dart';
import '../application/use_cases/resolve_photo_identity.dart';
import '../application/use_cases/save_app_locale.dart';
import '../application/use_cases/scan_media_library.dart';
import '../application/use_cases/start_backup_use_case.dart';
import '../application/use_cases/update_source_selection.dart';
import '../domain/models/protection_summary.dart';
import '../infrastructure/background/work_manager_background_scheduler.dart';
import '../infrastructure/cloud/google_drive_cloud_provider.dart';
import '../infrastructure/entitlements/static_entitlement_gateway.dart';
import '../infrastructure/observability/console_observability_sink.dart';
import '../infrastructure/storage/app_database.dart';
import '../infrastructure/storage/app_settings_store.dart';
import '../infrastructure/storage/media_source_store.dart';
import '../infrastructure/storage/local_photo_index_repository.dart';
import '../infrastructure/storage/source_selection_store.dart';
import 'app_mode.dart';
import 'app_platform.dart';
import 'media_adapters.dart';

class AppCompositionRoot {
  AppCompositionRoot._({
    required this.mode,
    required this.platform,
    required this.mediaLibraryGateway,
    required this.mediaPermissionGateway,
    required this.photoThumbnailGateway,
    required this.appSettingsRepository,
    required this.mediaSourceRepository,
    required this.sourceSelectionRepository,
    required this.photoIndexRepository,
    required this.cloudProvider,
    required this.backgroundScheduler,
    required this.entitlementGateway,
    required this.accessPolicy,
    required this.observabilitySink,
    required this.readAppSettings,
    required this.checkMediaAccess,
    required this.indexPhotos,
    required this.listMediaSources,
    required this.listLibraryPhotos,
    required this.requestMediaAccess,
    required this.resolvePhotoIdentity,
    required this.saveAppLocale,
    required this.scanMediaLibrary,
    required this.observeProtectionSummary,
    required this.startBackup,
    required this.updateSourceSelection,
  });

  final AppMode mode;
  final AppPlatform platform;
  final MediaLibraryGateway mediaLibraryGateway;
  final MediaPermissionGateway mediaPermissionGateway;
  final PhotoThumbnailGateway photoThumbnailGateway;
  final AppSettingsRepository appSettingsRepository;
  final MediaSourceRepository mediaSourceRepository;
  final SourceSelectionRepository sourceSelectionRepository;
  final PhotoIndexRepository photoIndexRepository;
  final CloudProvider cloudProvider;
  final BackgroundScheduler backgroundScheduler;
  final EntitlementGateway entitlementGateway;
  final AccessPolicy accessPolicy;
  final ObservabilitySink observabilitySink;
  final ReadAppSettings readAppSettings;
  final CheckMediaAccess checkMediaAccess;
  final IndexPhotos indexPhotos;
  final ListMediaSources listMediaSources;
  final ListLibraryPhotos listLibraryPhotos;
  final RequestMediaAccess requestMediaAccess;
  final ResolvePhotoIdentity resolvePhotoIdentity;
  final SaveAppLocale saveAppLocale;
  final ScanMediaLibrary scanMediaLibrary;
  final ObserveProtectionSummaryUseCase observeProtectionSummary;
  final StartBackupUseCase startBackup;
  final UpdateSourceSelection updateSourceSelection;

  factory AppCompositionRoot.configure({
    AppMode mode = AppMode.production,
    AppPlatform platform = AppPlatform.android,
    EntitlementGateway? entitlementGateway,
    AccessOverride accessOverride = AccessOverride.none,
  }) {
    _validateMode(
      mode: mode,
      entitlementGateway: entitlementGateway,
      accessOverride: accessOverride,
    );

    final mediaAdapters = MediaAdapters.forPlatform(platform);
    final mediaLibraryGateway = mediaAdapters.libraryGateway;
    final mediaPermissionGateway = mediaAdapters.permissionGateway;
    final photoThumbnailGateway = mediaAdapters.thumbnailGateway;
    AppDatabase? database;
    AppDatabase createDatabase() => database ??= AppDatabase.defaults();
    final appSettingsRepository = AppSettingsStore(
      createDatabase: createDatabase,
    );
    final mediaSourceRepository = MediaSourceStore(
      createDatabase: createDatabase,
    );
    final sourceSelectionRepository = SourceSelectionStore(
      createDatabase: createDatabase,
    );
    final photoIndexRepository = LocalPhotoIndexRepository(
      createDatabase: createDatabase,
    );
    final cloudProvider = GoogleDriveCloudProvider();
    final backgroundScheduler = WorkManagerBackgroundScheduler();
    final resolvedEntitlementGateway =
        entitlementGateway ?? const StaticEntitlementGateway();
    final accessPolicy = AccessPolicy(
      entitlementGateway: resolvedEntitlementGateway,
      override: accessOverride,
    );
    final observabilitySink = ConsoleObservabilitySink();
    final indexPhotos = IndexPhotos(
      repository: photoIndexRepository,
      permissionGateway: mediaPermissionGateway,
    );

    return AppCompositionRoot._(
      mode: mode,
      platform: platform,
      mediaLibraryGateway: mediaLibraryGateway,
      mediaPermissionGateway: mediaPermissionGateway,
      photoThumbnailGateway: photoThumbnailGateway,
      appSettingsRepository: appSettingsRepository,
      mediaSourceRepository: mediaSourceRepository,
      sourceSelectionRepository: sourceSelectionRepository,
      photoIndexRepository: photoIndexRepository,
      cloudProvider: cloudProvider,
      backgroundScheduler: backgroundScheduler,
      entitlementGateway: resolvedEntitlementGateway,
      accessPolicy: accessPolicy,
      observabilitySink: observabilitySink,
      readAppSettings: ReadAppSettings(appSettingsRepository),
      checkMediaAccess: CheckMediaAccess(mediaPermissionGateway),
      indexPhotos: indexPhotos,
      listMediaSources: ListMediaSources(
        mediaSourceRepository: mediaSourceRepository,
        sourceSelectionRepository: sourceSelectionRepository,
      ),
      listLibraryPhotos: ListLibraryPhotos(
        photoIndexRepository: photoIndexRepository,
        mediaSourceRepository: mediaSourceRepository,
        sourceSelectionRepository: sourceSelectionRepository,
      ),
      requestMediaAccess: RequestMediaAccess(mediaPermissionGateway),
      resolvePhotoIdentity: ResolvePhotoIdentity(photoIndexRepository),
      saveAppLocale: SaveAppLocale(appSettingsRepository),
      scanMediaLibrary: ScanMediaLibrary(
        libraryGateway: mediaLibraryGateway,
        permissionGateway: mediaPermissionGateway,
        sourceRepository: mediaSourceRepository,
        indexPhotos: indexPhotos,
      ),
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
      updateSourceSelection: UpdateSourceSelection(sourceSelectionRepository),
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
