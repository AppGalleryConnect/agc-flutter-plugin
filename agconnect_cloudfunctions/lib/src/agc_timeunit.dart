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

import 'package:flutter/foundation.dart';

@immutable
class AGCTimeUnit {
  static const NANOSECONDS = const AGCTimeUnit._(0);
  static const MICROSECONDS = const AGCTimeUnit._(1);
  static const MILLISECONDS = const AGCTimeUnit._(2);
  static const SECONDS = const AGCTimeUnit._(3);
  static const MINUTES = const AGCTimeUnit._(4);
  static const HOURS = const AGCTimeUnit._(5);
  static const DAYS = const AGCTimeUnit._(6);

  final int _value;

  const AGCTimeUnit._(this._value);

  /// Creates a [AGCTimeUnit] object from a integer.
  factory AGCTimeUnit.fromInt(int value) {
    if (value >= 0 && value <= 6) {
      return AGCTimeUnit._(value);
    } else {
      throw Exception('Value must be in the correct range: -1 < value < 7');
    }
  }

  int toInt() => _value;

  /// Converts [AGCTimeUnit] object to string.
  @override
  String toString() => 'AGCTimeUnit(value: $_value)';

  /// Compares two [AGCTimeUnit] objects.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AGCTimeUnit && other._value == _value);
  }

  /// Generates the hash code for a [AGCTimeUnit] object.
  @override
  int get hashCode => _value.hashCode;
}
