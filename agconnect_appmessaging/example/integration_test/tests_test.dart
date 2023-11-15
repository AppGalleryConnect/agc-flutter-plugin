/*
 * Copyright 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
 *2021-2023
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:agconnect_appmessaging/agconnect_appmessaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:agconnect_appmessaging_example/main.dart' as app;
import 'package:integration_test/integration_test.dart';

// Mock AGCAppMessaging for testing
class MockAGCAppMessaging extends Mock implements AGCAppMessaging {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('App Messaging Tests', () {
    testWidgets('Test isDisplayEnable button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('isDisplayEnable'));
      await tester.pump();

      expect(find.text('SUCCESS'), findsOneWidget);
      expect(find.text('true'), findsOneWidget);
    });

    testWidgets('Test Enable Display button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enable Display'));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('SUCCESS'), findsOneWidget);
    });

    testWidgets('Test Disable Display button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Disable Display'));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('SUCCESS'), findsOneWidget);
    });

    testWidgets('Test Trigger button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('trigger\n#AppOnForeground'));
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('SUCCESS'), findsOneWidget);
    });
  });
}
