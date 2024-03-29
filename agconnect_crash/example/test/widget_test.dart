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
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Mock platform version
    final mockPlatform =
        'HarmonyOS'; // Replace with your desired platform value

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(mockPlatform));

    // Verify that platform version is displayed.
    expect(
      find.text('Running on: $mockPlatform'),
      findsOneWidget,
    );
  });
}

class MyApp extends StatelessWidget {
  final String platform;

  MyApp(this.platform);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Running on: $platform'),
        ),
      ),
    );
  }
}
