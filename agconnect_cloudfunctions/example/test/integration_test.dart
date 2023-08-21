/*
 * Copyright (c) 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
 *
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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_cloudfunctions_example/main.dart' as app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('MyApp', () {
    testWidgets('renders MyApp correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('AGC Cloud Functions Example'), findsOneWidget);
      expect(find.text('Call Function'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
    });

    testWidgets('calls the function and updates result',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final functionTextField = find.byType(TextField).first;
      final callFunctionButton = find.text('Call Function');
      final resultTextField = find.byType(TextField).last;

      expect(functionTextField, findsOneWidget);
      expect(callFunctionButton, findsOneWidget);
      expect(resultTextField, findsOneWidget);

      await tester.enterText(functionTextField, 'test-function');
      await tester.tap(callFunctionButton);
      await tester.pump(Duration(seconds: 10));
    });

    testWidgets('resets the text fields', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final functionTextField = find.byType(TextField).first;
      final resetButton = find.text('Reset');
      final resultTextField = find.byType(TextField).last;

      expect(functionTextField, findsOneWidget);
      expect(resetButton, findsOneWidget);
      expect(resultTextField, findsOneWidget);

      await tester.enterText(functionTextField, 'test-function');
      await tester.enterText(resultTextField, 'Test Result');
      await tester.tap(resetButton);
      await tester.pump();

      expect(find.text('testfunc-\$latest'), findsOneWidget);
      await tester.pump();
      expect(
          find.text(
              'Change the function name as you wish and click \'Call Function\' button to get response.'),
          findsOneWidget);
    });
  });
}
