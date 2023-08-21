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

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_cloudfunctions/src/agc_timeunit.dart';
import 'package:agconnect_cloudfunctions/src/function_callable.dart';

import 'package:mockito/mockito.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    final MethodChannel channel =
        MethodChannel('com.huawei.agc.flutter.cloudfunctions/MethodChannel');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        // ignore: body_might_complete_normally_nullable
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'callFunction') {
        final String result = 'Mocked Result';
        return result;
      }
    });
  });
  group('FunctionCallable', () {
    test(
        'FunctionCallable.fromMap() should return a valid FunctionCallable object',
        () {
      final map = {
        'httpTriggerURI': 'https://example.com',
        'timeout': 70,
        'units': 3,
      };
      final functionCallable = FunctionCallable.fromMap(map);
      expect(functionCallable.httpTriggerURI, equals('https://example.com'));
      expect(functionCallable.timeout, equals(70));
      expect(functionCallable.units, equals(AGCTimeUnit.SECONDS));
    });

    test(
        'FunctionCallable.clone() should return a cloned FunctionCallable object',
        () {
      final functionCallable = FunctionCallable('https://example.com',
          timeout: 70, units: AGCTimeUnit.SECONDS);
      final clonedCallable = functionCallable.clone();
      expect(clonedCallable.httpTriggerURI, equals('https://example.com'));
      expect(clonedCallable.timeout, equals(70));
      expect(clonedCallable.units, equals(AGCTimeUnit.SECONDS));
    });

    test(
        'FunctionCallable.toMap() should return a valid map representation of FunctionCallable',
        () {
      final functionCallable = FunctionCallable('https://example.com',
          timeout: 70, units: AGCTimeUnit.SECONDS);
      final map = functionCallable.toMap();
      expect(map['httpTriggerURI'], equals('https://example.com'));
      expect(map['timeout'], equals(70));
      expect(map['units'], equals(3));
    });

    test('FunctionCallable.toJson() should return a valid JSON string', () {
      final functionCallable = FunctionCallable('https://example.com',
          timeout: 70, units: AGCTimeUnit.SECONDS);
      final jsonString = functionCallable.toJson();
      final expectedJsonString =
          '{"httpTriggerURI":"https://example.com","timeout":70,"units":3}';
      expect(jsonString, equals(expectedJsonString));
    });

    test(
        'FunctionCallable toString() should return a valid string representation',
        () {
      final functionCallable = FunctionCallable('https://example.com',
          timeout: 70, units: AGCTimeUnit.SECONDS);
      final expectedString =
          'FunctionCallable(httpTriggerURI: https://example.com, timeout: 70, units: AGCTimeUnit(value: 3))';
      expect(functionCallable.toString(), equals(expectedString));
    });

    test('FunctionCallable equality should work correctly', () {
      final functionCallable1 = FunctionCallable('https://example.com',
          timeout: 70, units: AGCTimeUnit.SECONDS);
      final functionCallable2 = FunctionCallable('https://example.com',
          timeout: 70, units: AGCTimeUnit.SECONDS);
      final functionCallable3 = FunctionCallable('https://different.com',
          timeout: 70, units: AGCTimeUnit.SECONDS);
      final functionCallable4 = FunctionCallable('https://example.com',
          timeout: 100, units: AGCTimeUnit.MINUTES);
      expect(functionCallable1, equals(functionCallable2));
      expect(functionCallable1, isNot(equals(functionCallable3)));
      expect(functionCallable1, isNot(equals(functionCallable4)));
    });

    test('FunctionCallable hashCode should return the correct value', () {
      final functionCallable = FunctionCallable('https://example.com',
          timeout: 70, units: AGCTimeUnit.SECONDS);
      final hashCode = functionCallable.hashCode;
      final expectedHashCode =
          'https://example.com'.hashCode ^ 70.hashCode ^ 3.hashCode;
      expect(hashCode, equals(expectedHashCode));
    });
  });
}
