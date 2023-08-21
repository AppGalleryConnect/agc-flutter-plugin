import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:agconnect_remote_config_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Fetch Immediately',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();
        await tester.tap(find.text('Mode 1:Fetch And Activate Immediately'));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(find.text('{aa: bb}'),findsOneWidget);
      });
}
