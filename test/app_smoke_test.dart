import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organaizer/bootstrap/app_composition_root.dart';
import 'package:photo_organaizer/presentation/app/smart_photo_archive_app.dart';

void main() {
  testWidgets('renders application shell', (tester) async {
    await tester.pumpWidget(
      SmartPhotoArchiveApp(
        compositionRoot: AppCompositionRoot.configure(),
      ),
    );

    expect(find.text('Smart Photo Archive'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Photos'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
  });
}
