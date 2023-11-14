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

import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_applinking/src/models/short_app_linking.dart';

void main() {
  group('ShortAppLinking', () {
    test('Should correctly deserialize from JSON', () {
      final jsonString =
          '{"shortLink":"https://short.example.com","testUrl":"https://test.example.com"}';

      final shortAppLinking = ShortAppLinking.fromJson(jsonString);

      final expectedShortLink = Uri.parse('https://short.example.com');
      final expectedTestUrl = Uri.parse('https://test.example.com');
      expect(shortAppLinking.shortLink, equals(expectedShortLink));
      expect(shortAppLinking.testUrl, equals(expectedTestUrl));
    });

    test('Should correctly create instance from map', () {
      final map = {
        'shortLink': 'https://short.example.com',
        'testUrl': 'https://test.example.com',
      };

      final shortAppLinking = ShortAppLinking.fromMap(map);

      final expectedShortLink = Uri.parse('https://short.example.com');
      final expectedTestUrl = Uri.parse('https://test.example.com');
      expect(shortAppLinking.shortLink, equals(expectedShortLink));
      expect(shortAppLinking.testUrl, equals(expectedTestUrl));
    });
  });
}
