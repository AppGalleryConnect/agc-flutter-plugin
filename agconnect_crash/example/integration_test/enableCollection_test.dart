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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:agconnect_crash_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Enable Crash Collection Button Test',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Find the Enable Crash Collection button
    final enableButtonFinder = find.text('Enable Crash Collection');

    await tester.tap(enableButtonFinder);
    await tester.pumpAndSettle();

    // Verify that the SnackBar is displayed with the correct properties
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Enabled Crash Collection'), findsOneWidget);

    // Wait for the SnackBar to disappear
    await tester.pumpAndSettle(Duration(seconds: 3));

    // Verify that the SnackBar is no longer visible
    expect(find.byType(SnackBar), findsNothing);
  });
}
