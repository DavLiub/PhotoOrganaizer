import 'package:flutter/widgets.dart';

import '../presentation/app/smart_photo_archive_app.dart';
import 'app_composition_root.dart';
import 'app_mode.dart';
import 'app_platform.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  final compositionRoot = AppCompositionRoot.configure(
    mode: AppMode.fromEnvironment(),
    platform: appPlatformFromName(
      const String.fromEnvironment('APP_PLATFORM', defaultValue: 'android'),
    ),
  );

  runApp(SmartPhotoArchiveApp(compositionRoot: compositionRoot));
}
