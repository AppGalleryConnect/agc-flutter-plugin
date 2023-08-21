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

import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable

/// Contains methods for obtaining the return value of a cloud function.
///
/// ```dart
/// final String result = functionResult.getValue();
/// ```
class FunctionResult {
  final String _result;

  const FunctionResult(this._result);

  /// Obtains the return value after a cloud function is executed. The return value is of the string type.
  String getValue() => _result;

  Map<String, dynamic> getMap() => jsonDecode(_result);

  /// Converts [FunctionResult] object to string.
  @override
  String toString() => 'FunctionResult(result: $_result)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FunctionResult && other._result == _result);
  }

  /// Generates the hash code for a [FunctionResult] object.
  @override
  int get hashCode => _result.hashCode;
}
