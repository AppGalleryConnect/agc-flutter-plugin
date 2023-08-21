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
import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_cloudfunctions/src/function_result.dart';

void main() {
  group('FunctionResult', () {
    test('should return correct value', () {
      final result = FunctionResult('{"name": "John", "age": 30}');
      expect(result.getValue(), equals('{"name": "John", "age": 30}'));
    });

    test('should return correct map', () {
      final result = FunctionResult('{"name": "John", "age": 30}');
      expect(result.getMap(), equals({'name': 'John', 'age': 30}));
    });

    test('should return correct string representation of FunctionResult', () {
      final result = FunctionResult('{"name": "John", "age": 30}');
      expect('$result',
          equals('FunctionResult(result: {"name": "John", "age": 30})'));
    });

    test('should return true when comparing two equal FunctionResults', () {
      final result1 = FunctionResult('{"name": "John", "age": 30}');
      final result2 = FunctionResult('{"name": "John", "age": 30}');
      expect(result1 == result2, isTrue);
    });

    test('should return false when comparing two different FunctionResults',
        () {
      final result1 = FunctionResult('{"name": "John", "age": 30}');
      final result2 = FunctionResult('{"name": "Jane", "age": 25}');
      expect(result1 == result2, isFalse);
    });
  });
}
