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
import 'package:flutter/services.dart';

@immutable

/// Exception returned when a function fails to be executed. [FunctionError]
class FunctionError {
  static const int UNKNOW_ERROR_CODE = -1;

  final String message;
  final int code;

  /// Default constructor.
  FunctionError(this.message, this.code);

  /// Obtains the result code of an exception.
  factory FunctionError.fromException(PlatformException e) {
    return FunctionError(e.message ?? '', int.parse(e.code));
  }

  /// Creates a [FunctionError] object from a JSON string.
  factory FunctionError.fromJson(String source) {
    return FunctionError.fromMap(json.decode(source));
  }

  /// Creates a [FunctionError] object from a map.
  factory FunctionError.fromMap(Map<String, dynamic> map) {
    return FunctionError(
      map['message'] ?? '',
      map['code'] ?? UNKNOW_ERROR_CODE,
    );
  }

  /// Converts [FunctionError] object to map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'code': code,
    };
  }

  /// Converts [FunctionError] object to JSON string.
  String toJson() => json.encode(toMap());

  /// Converts [FunctionError] object to string.
  @override
  String toString() => 'FunctionError(message: $message, code: $code)';

  /// Compares two [FunctionError] objects.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FunctionError &&
            other.message == message &&
            other.code == code);
  }

  /// Generates the hash code for a [FunctionError] object.
  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}
