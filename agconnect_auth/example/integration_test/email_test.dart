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
import 'dart:convert';
import 'dart:io';

import 'package:agconnect_auth_example/main.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Email Create Authentication',
          (WidgetTester tester) async {
        Map<String, dynamic> user = await jsonDecode(await loadAsset());
        app.main();
        await tester.pumpAndSettle();
        await tester.tap(find.text('Email'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('createEmailUser'));
        await tester.pumpAndSettle();

        final countryField = find.ancestor(
          of: find.text('email'),
          matching: find.byType(CupertinoTextField),
        );
        await tester.enterText(countryField, user['email']);
        await tester.pumpAndSettle();
        await tester.tap(find.text('send'));
        await tester.pumpAndSettle(const Duration(seconds: 10));
        expect(find.text("Verification code sent"), findsOneWidget);
      });
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/user-info.json');
}