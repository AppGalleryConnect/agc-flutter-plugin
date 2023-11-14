/*
 * Copyright 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:agconnect_cloudstorage_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Testing getArea', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('getArea'));
    await tester.pumpAndSettle();
    expect(find.text('SG'),findsOneWidget);
  });

  testWidgets('Testing retryTimes get function', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('getRetry'));
    await tester.pumpAndSettle();
    expect(find.text('SUCCESS'),findsOneWidget);
  });

  testWidgets('Testing retryTimes set function', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '9');
    await tester.tap(find.text('setRetry'));
    await tester.pumpAndSettle();
    expect(find.text('true'),findsOneWidget);
  });

  testWidgets('Testing MaxRequest get function', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('getMaxRequest'));
    await tester.pumpAndSettle();
    expect(find.text('SUCCESS'),findsOneWidget);
  });

  testWidgets('Testing MaxRequest set function', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '9');
    await tester.tap(find.text('setMaxRequest'));
    await tester.pumpAndSettle();
    expect(find.text('true'),findsOneWidget);
  });

  testWidgets('Testing MaxUploadTimeout get function', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('getMaxUpload'));
    await tester.pumpAndSettle();
    expect(find.text('SUCCESS'),findsOneWidget);
  });

  testWidgets('Testing MaxUploadTimeout set function', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '9');
    await tester.tap(find.text('setMaxUpload'));
    await tester.pumpAndSettle();
    expect(find.text('true'),findsOneWidget);
  });

  testWidgets('Testing MaxDownloadTimeout get function', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('getMaxDownload'));
    await tester.pumpAndSettle();
    expect(find.text('SUCCESS'),findsOneWidget);
  });

  testWidgets('Testing MaxDownloadTimeout set function', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '9');
    await tester.tap(find.text('setDownload'));
    await tester.pumpAndSettle();
    expect(find.text('true'),findsOneWidget);
  });

  testWidgets('Testing max:2 button', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('max:2'));
    await tester.pumpAndSettle();
    expect(find.text('SUCCESS'),findsOneWidget);
  });

  testWidgets('Testing all button', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('all'));
    await tester.pumpAndSettle();
    expect(find.text('SUCCESS'),findsOneWidget);
  });
}
