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
import 'package:agconnect_cloudfunctions/src/agc_timeunit.dart';

void main() {
  group('AGCTimeUnit', () {
    test('should create AGCTimeUnit from int', () {
      expect(AGCTimeUnit.fromInt(0), equals(AGCTimeUnit.NANOSECONDS));
      expect(AGCTimeUnit.fromInt(1), equals(AGCTimeUnit.MICROSECONDS));
      expect(AGCTimeUnit.fromInt(2), equals(AGCTimeUnit.MILLISECONDS));
      expect(AGCTimeUnit.fromInt(3), equals(AGCTimeUnit.SECONDS));
      expect(AGCTimeUnit.fromInt(4), equals(AGCTimeUnit.MINUTES));
      expect(AGCTimeUnit.fromInt(5), equals(AGCTimeUnit.HOURS));
      expect(AGCTimeUnit.fromInt(6), equals(AGCTimeUnit.DAYS));
    });

    test('should throw exception when creating AGCTimeUnit from invalid int',
        () {
      expect(() => AGCTimeUnit.fromInt(-1), throwsException);
      expect(() => AGCTimeUnit.fromInt(7), throwsException);
    });

    test('should convert AGCTimeUnit to int', () {
      expect(AGCTimeUnit.NANOSECONDS.toInt(), equals(0));
      expect(AGCTimeUnit.MICROSECONDS.toInt(), equals(1));
      expect(AGCTimeUnit.MILLISECONDS.toInt(), equals(2));
      expect(AGCTimeUnit.SECONDS.toInt(), equals(3));
      expect(AGCTimeUnit.MINUTES.toInt(), equals(4));
      expect(AGCTimeUnit.HOURS.toInt(), equals(5));
      expect(AGCTimeUnit.DAYS.toInt(), equals(6));
    });

    test('should return true when comparing two equal AGCTimeUnits', () {
      final unit1 = AGCTimeUnit.NANOSECONDS;
      final unit2 = AGCTimeUnit.NANOSECONDS;
      expect(unit1 == unit2, isTrue);
    });

    test('should return false when comparing two different AGCTimeUnits', () {
      final unit1 = AGCTimeUnit.NANOSECONDS;
      final unit2 = AGCTimeUnit.SECONDS;
      expect(unit1 == unit2, isFalse);
    });
  });
}
