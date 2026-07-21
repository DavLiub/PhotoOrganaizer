import '../../domain/value_objects/access_decision.dart';
import '../../domain/value_objects/capability.dart';
import '../policies/access_policy.dart';
import '../ports/background_scheduler.dart';
import '../ports/cloud_provider.dart';
import '../ports/media_library_gateway.dart';
import '../ports/photo_index_repository.dart';

class StartBackupUseCase {
  const StartBackupUseCase({
    required this.mediaLibraryGateway,
    required this.photoIndexRepository,
    required this.cloudProvider,
    required this.backgroundScheduler,
    required this.accessPolicy,
  });

  final MediaLibraryGateway mediaLibraryGateway;
  final PhotoIndexRepository photoIndexRepository;
  final CloudProvider cloudProvider;
  final BackgroundScheduler backgroundScheduler;
  final AccessPolicy accessPolicy;

  Future<AccessDecision> call() async {
    final decision = await accessPolicy.check(Capability.startBackup);
    if (!decision.canProceed) {
      return decision;
    }

    await backgroundScheduler.scheduleBackup();
    return decision;
  }
}
