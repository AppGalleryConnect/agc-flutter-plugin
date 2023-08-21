import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:agconnect_remote_config_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Fetch Later',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();
        await tester.tap(find.text('Clear Data'));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        await tester.tap(find.text('Mode 2:Fetch And Activate Next Time'));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(find.text('{}'),findsOneWidget);
      });
}
