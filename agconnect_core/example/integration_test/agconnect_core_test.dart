import 'package:agconnect_core/agconnect_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:agconnect_core_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Testing buildInstance shows snackbar', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('buildInstance'));
    await tester.pumpAndSettle();
    expect(find.text('buildInstance function called successfully check logs!'),findsOneWidget);
  });

  testWidgets('Testing getString shows snackbar', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('getString'));
    await tester.pumpAndSettle();
    expect(find.text('getString called successfully check logs!'),findsOneWidget);
  });

  testWidgets('Testing getPackageName shows snackbar', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('getPackageName'));
    await tester.pumpAndSettle();
    expect(find.text('getPackageName called successfully check logs!'),findsOneWidget);
  });

  testWidgets('Testing getRoutePolicy shows snackbar', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('getRoutePolicy'));
    await tester.pumpAndSettle();
    expect(find.text('getRoutePolicy called successfully check logs!'),findsOneWidget);
  });
}
