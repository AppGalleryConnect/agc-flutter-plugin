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

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_crash/agconnect_crash.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('crash test', () {
    const MethodChannel channel =
        MethodChannel('com.huawei.flutter/agconnect_crash');
    late MethodCall mockCall;

    Future<Object?> handler(MethodCall methodCall) async {
      mockCall = methodCall;
      switch (methodCall.method) {
        case 'testIt':
          return null;
        case 'enableCrashCollection':
          return null;
        case 'setUserId':
          return null;
        case 'setCustomKey':
          return null;
        case 'customLog':
          return null;
        case 'recordError':
          return null;
        default:
          throw PlatformException(
              code: '0', message: 'Unknown method call, please update test.');
      }
    }

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, handler);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('testIt', () async {
      await AGCCrash.instance.testIt();
      expect(mockCall.method, 'testIt');
      expect(mockCall.arguments, null);
    });

    test('enableCrashCollection', () async {
      await AGCCrash.instance.enableCrashCollection(true);
      expect(mockCall.method, 'enableCrashCollection');
      expect(mockCall.arguments['enable'], true);
    });

    test('setUserId', () async {
      await AGCCrash.instance.setUserId('testUserId');
      expect(mockCall.method, 'setUserId');
      expect(mockCall.arguments['userId'], 'testUserId');
    });

    test('setCustomKey', () async {
      await AGCCrash.instance.setCustomKey('testKey', 'testValue');
      expect(mockCall.method, 'setCustomKey');
      expect(mockCall.arguments['key'], 'testKey');
      expect(mockCall.arguments['value'], 'testValue');
    });

    test('setCustomKey with bool', () async {
      await AGCCrash.instance.setCustomKey('testKey', true);
      expect(mockCall.method, 'setCustomKey');
      expect(mockCall.arguments['key'], 'testKey');
      expect(mockCall.arguments['value'], 'true');
    });

    test('setCustomKey with int', () async {
      await AGCCrash.instance.setCustomKey('testKey', 123);
      expect(mockCall.method, 'setCustomKey');
      expect(mockCall.arguments['key'], 'testKey');
      expect(mockCall.arguments['value'], '123');
    });

    test('setCustomKey with null', () async {
      await AGCCrash.instance.setCustomKey('testKey', null);
      expect(mockCall.method, 'setCustomKey');
      expect(mockCall.arguments['key'], 'testKey');
      expect(mockCall.arguments['value'], 'null');
    });

    test('log', () async {
      await AGCCrash.instance.log(message: 'testlog');
      expect(mockCall.method, 'customLog');
      expect(mockCall.arguments['level'], 1);
      expect(mockCall.arguments['message'], 'testlog');
    });

    test('log with error', () async {
      await AGCCrash.instance.log(level: LogLevel.error, message: 'testlog');
      expect(mockCall.method, 'customLog');
      expect(mockCall.arguments['level'], 3);
      expect(mockCall.arguments['message'], 'testlog');
    });
  });
}
