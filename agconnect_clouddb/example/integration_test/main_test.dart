/*
 * Copyright 2020-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

import 'package:agconnect_clouddb_example/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('User Login Test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    expect(find.textContaining("UserID: null"), findsNothing);
  });

  testWidgets('Open CloudDB', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('openCloudDBZone2'));
    await tester.pumpAndSettle();
    expect(find.textContaining("SUCCESS"), findsOneWidget);
    await tester.tap(find.text("Close"));
    await tester.pumpAndSettle();
    await tester.tap(find.text('closeCloudDBZone'));
    await tester.pumpAndSettle();
    expect(find.textContaining("SUCCESS"), findsOneWidget);
    await tester.tap(find.byType(AlertDialog));
    await tester.pumpAndSettle();
  });

  testWidgets('MaximumQuery', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('openCloudDBZone2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Close"));
    await tester.pumpAndSettle();
    final Finder buttonToTap = find.text('executeMaximumQuery');

    await tester.dragUntilVisible(
      buttonToTap, 
      find.byType(Expanded), 
      const Offset(0, -500), 
    );
    await tester.tap(buttonToTap);
    await tester.pumpAndSettle();
    expect(find.textContaining("SUCCESS"), findsOneWidget);
  });
}
