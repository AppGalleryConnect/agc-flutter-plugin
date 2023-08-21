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
import 'package:agconnect_cloudfunctions/src/function_error.dart';

void main() {
  group('FunctionError', () {
    test('should create FunctionError from PlatformException', () {
      final exception = PlatformException(code: '404', message: 'Not Found');
      final error = FunctionError.fromException(exception);
      expect(error.message, equals('Not Found'));
      expect(error.code, equals(404));
    });

    test('should create FunctionError from JSON', () {
      final json = '{"message": "Bad Request", "code": 400}';
      final error = FunctionError.fromJson(json);
      expect(error.message, equals('Bad Request'));
      expect(error.code, equals(400));
    });

    test('should create FunctionError from Map', () {
      final map = {'message': 'Internal Server Error', 'code': 500};
      final error = FunctionError.fromMap(map);
      expect(error.message, equals('Internal Server Error'));
      expect(error.code, equals(500));
    });

    test('should convert FunctionError to JSON', () {
      final error = FunctionError('Unauthorized', 401);
      final json = error.toJson();
      expect(json, equals('{"message":"Unauthorized","code":401}'));
    });

    test('should return correct string representation of FunctionError', () {
      final error = FunctionError('Forbidden', 403);
      expect('$error', equals('FunctionError(message: Forbidden, code: 403)'));
    });

    test('should return true when comparing two equal FunctionErrors', () {
      final error1 = FunctionError('Not Found', 404);
      final error2 = FunctionError('Not Found', 404);
      expect(error1 == error2, isTrue);
    });

    test('should return false when comparing two different FunctionErrors', () {
      final error1 = FunctionError('Bad Request', 400);
      final error2 = FunctionError('Internal Server Error', 500);
      expect(error1 == error2, isFalse);
    });
  });
}
