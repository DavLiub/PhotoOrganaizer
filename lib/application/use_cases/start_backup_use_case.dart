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
  });

  final MediaLibraryGateway mediaLibraryGateway;
  final PhotoIndexRepository photoIndexRepository;
  final CloudProvider cloudProvider;
  final BackgroundScheduler backgroundScheduler;

  Future<void> call() async {
    await backgroundScheduler.scheduleBackup();
  }
}
