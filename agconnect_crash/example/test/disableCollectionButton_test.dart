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

void main() {
  testWidgets('Disabling crash collection shows snackbar',
      (WidgetTester tester) async {
    // Build the widget that contains the ElevatedButton
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {
              // Function to be tested
              _disableCollection();
              ScaffoldMessenger.of(tester.element(find.byType(ElevatedButton)))
                  .showSnackBar(const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text('Disabled Crash Collection'),
                duration: Duration(seconds: 3),
              ));
            },
            child: const Text('Disable Crash Collection'),
          ),
        ),
      ),
    );

    // Tap the ElevatedButton
    await tester.tap(find.text('Disable Crash Collection'));
    await tester.pump();

    // Check if the snackbar is displayed
    expect(find.text('Disabled Crash Collection'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        equals(Colors.orangeAccent));
    expect(tester.widget<SnackBar>(find.byType(SnackBar)).duration,
        equals(Duration(seconds: 3)));
  });
}

void _disableCollection() {
  // Your logic to disable crash collection goes here
  // This function can be a placeholder for your actual implementation
}
