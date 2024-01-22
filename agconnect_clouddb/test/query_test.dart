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

import 'package:agconnect_clouddb/agconnect_clouddb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("query test", () {
    test('equalto', () async {
      AGConnectCloudDBQuery('BookInfo').equalTo('price', 5);
    });

    test('equaltoFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').equalTo('', 5),
          throwsA(isA<FormatException>()));
    });

    test('equaltoValueException', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').equalTo('price', null),
          throwsA(isA<FormatException>()));
      expect(
          () => AGConnectCloudDBQuery('BookInfo').equalTo('price', DateTime(1)),
          throwsA(isA<FormatException>()));
    });

    test('notEqualto', () async {
      AGConnectCloudDBQuery('BookInfo').notEqualTo('price', 5);
    });

    test('notEqualtoFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').notEqualTo('', 5),
          throwsA(isA<FormatException>()));
    });

    test('notEqualtoValueException', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').notEqualTo('price', null),
          throwsA(isA<FormatException>()));
      expect(
          () => AGConnectCloudDBQuery('BookInfo')
              .notEqualTo('price', DateTime(1)),
          throwsA(isA<FormatException>()));
    });

    test('lessThan', () async {
      AGConnectCloudDBQuery('BookInfo').lessThan('price', 5);
    });

    test('lessThanFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').lessThan('', 5),
          throwsA(isA<FormatException>()));
    });

    test('lessThanValueException', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').lessThan('price', null),
          throwsA(isA<FormatException>()));
      expect(
          () =>
              AGConnectCloudDBQuery('BookInfo').lessThan('price', DateTime(1)),
          throwsA(isA<FormatException>()));
    });

    test('lessThanOrEqualTo', () async {
      AGConnectCloudDBQuery('BookInfo').lessThanOrEqualTo('price', 5);
    });

    test('lessThanOrEqualToFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').lessThanOrEqualTo('', 5),
          throwsA(isA<FormatException>()));
    });

    test('lessThanOrEqualToValueException', () async {
      expect(
          () => AGConnectCloudDBQuery('BookInfo')
              .lessThanOrEqualTo('price', null),
          throwsA(isA<FormatException>()));
      expect(
          () => AGConnectCloudDBQuery('BookInfo')
              .lessThanOrEqualTo('price', DateTime(1)),
          throwsA(isA<FormatException>()));
    });

    test('greaterThan', () async {
      AGConnectCloudDBQuery('BookInfo').greaterThan('price', 5);
    });

    test('greaterThanFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').greaterThan('', 5),
          throwsA(isA<FormatException>()));
    });

    test('greaterThanValueException', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').greaterThan('price', null),
          throwsA(isA<FormatException>()));
      expect(
          () => AGConnectCloudDBQuery('BookInfo')
              .greaterThan('price', DateTime(1)),
          throwsA(isA<FormatException>()));
    });

    test('greaterThanOrEqualTo', () async {
      AGConnectCloudDBQuery('BookInfo').greaterThanOrEqualTo('price', 5);
    });

    test('greaterThanOrEqualToFieldEmpty', () async {
      expect(
          () => AGConnectCloudDBQuery('BookInfo').greaterThanOrEqualTo('', 5),
          throwsA(isA<FormatException>()));
    });

    test('greaterThanOrEqualToValueException', () async {
      expect(
          () => AGConnectCloudDBQuery('BookInfo')
              .greaterThanOrEqualTo('price', null),
          throwsA(isA<FormatException>()));
      expect(
          () => AGConnectCloudDBQuery('BookInfo')
              .greaterThanOrEqualTo('price', DateTime(1)),
          throwsA(isA<FormatException>()));
    });

    test('whereIn', () async {
      AGConnectCloudDBQuery('BookInfo').whereIn('price', <int>[5]);
    });

    test('whereInFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').whereIn('', <int>[5]),
          throwsA(isA<FormatException>()));
    });

    test('whereInValueException', () async {
      expect(
          () =>
              AGConnectCloudDBQuery('BookInfo').whereIn('price', List.empty()),
          throwsA(isA<FormatException>()));
      expect(
          () =>
              AGConnectCloudDBQuery('BookInfo').whereIn('price', [DateTime(1)]),
          throwsA(isA<FormatException>()));
    });

    test('beginsWith', () async {
      AGConnectCloudDBQuery('BookInfo').beginsWith('author', 'test');
    });

    test('beginsWithFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').beginsWith('', ''),
          throwsA(isA<FormatException>()));
    });

    test('endsWith', () async {
      AGConnectCloudDBQuery('BookInfo').endsWith('author', 'test');
    });

    test('endsWithFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').endsWith('', ''),
          throwsA(isA<FormatException>()));
    });

    test('contains', () async {
      AGConnectCloudDBQuery('BookInfo').contains('author', 'test');
    });

    test('containsFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').contains('', ''),
          throwsA(isA<FormatException>()));
    });

    test('isNull', () async {
      AGConnectCloudDBQuery('BookInfo').isNull('price');
    });

    test('isNullFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').isNull(''),
          throwsA(isA<FormatException>()));
    });

    test('isNotNull', () async {
      AGConnectCloudDBQuery('BookInfo').isNotNull('price');
    });

    test('isNotNullFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').isNotNull(''),
          throwsA(isA<FormatException>()));
    });

    test('orderBy', () async {
      AGConnectCloudDBQuery('BookInfo').orderBy('price');
    });

    test('orderByFieldEmpty', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').orderBy(''),
          throwsA(isA<FormatException>()));
    });

    test('limit', () async {
      AGConnectCloudDBQuery('BookInfo').limit(5);
    });

    test('limitCountFail', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').limit(0),
          throwsA(isA<FormatException>()));
    });

    test('limitOffsetFail', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').limit(1, offset: 0),
          throwsA(isA<FormatException>()));
    });

    test('startAt', () async {
      AGConnectCloudDBQuery('BookInfo')
          .startAt({'id': 1, 'author': 'Test', 'price': 5});
    });

    test('startAtFail', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').startAt({}),
          throwsA(isA<FormatException>()));
    });

    test('startAfter', () async {
      AGConnectCloudDBQuery('BookInfo')
          .startAfter({'id': 1, 'author': 'Test', 'price': 5});
    });

    test('startAfterFail', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').startAfter({}),
          throwsA(isA<FormatException>()));
    });

    test('endAt', () async {
      AGConnectCloudDBQuery('BookInfo')
          .endAt({'id': 1, 'author': 'Test', 'price': 5});
    });

    test('endAtFail', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').endAt({}),
          throwsA(isA<FormatException>()));
    });

    test('endBefore', () async {
      AGConnectCloudDBQuery('BookInfo')
          .endBefore({'id': 1, 'author': 'Test', 'price': 5});
    });

    test('endBeforeFail', () async {
      expect(() => AGConnectCloudDBQuery('BookInfo').endBefore({}),
          throwsA(isA<FormatException>()));
    });
  });
}
