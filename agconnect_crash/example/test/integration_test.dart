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
  testWidgets('Enable Crash Collection Button Test',
      (WidgetTester tester) async {
    // Build the widget under test
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyWidget(),
        ),
      ),
    );

    // Find the Enable Crash Collection button
    final enableButtonFinder = find.byKey(Key('Enable'));

    // Verify that the button is initially enabled
    expect(tester.widget<ElevatedButton>(enableButtonFinder).enabled, isTrue);

    // Tap the button
    await tester.tap(enableButtonFinder);
    await tester.pumpAndSettle();

    // Verify that the _enableCollection() method is called
    expect(find.byType(MyWidget), findsOneWidget);
    expect(
        tester
            .state<MyWidgetState>(find.byType(MyWidget))
            .enableCollectionCalled,
        isTrue);

    // Verify that the SnackBar is displayed with the correct properties
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Enabled Crash Collection'), findsOneWidget);

    // Wait for the SnackBar to disappear
    await tester.pumpAndSettle(Duration(seconds: 3));

    // Verify that the SnackBar is no longer visible
    expect(find.byType(SnackBar), findsNothing);
  });
}

class MyWidget extends StatefulWidget {
  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  bool enableCollectionCalled = false;

  void _enableCollection() {
    setState(() {
      enableCollectionCalled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: Key('Enable'),
      onPressed: () {
        _enableCollection();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('Enabled Crash Collection'),
          duration: Duration(seconds: 3),
        ));
      },
      child: const Text('Enable Crash Collection'),
    );
  }
}
