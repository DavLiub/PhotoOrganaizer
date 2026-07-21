import 'package:flutter/widgets.dart';

import 'app_composition_root.dart';
import '../presentation/app/smart_photo_archive_app.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  final compositionRoot = AppCompositionRoot.configure();

  runApp(SmartPhotoArchiveApp(compositionRoot: compositionRoot));
}
