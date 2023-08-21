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

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'agc_timeunit.dart';
import 'function_result.dart';

/// Contains methods for calling cloud functions.
/// ```dart
/// FunctionCallable functionCallable = FunctionCallable("your-cloud-function-handler");
/// ```
class FunctionCallable {
  static const int DEFAULT_TIMEOUT = 70;
  static const AGCTimeUnit DEFAULT_TIMEUNIT = AGCTimeUnit.SECONDS;

  /// Function HTTP Trigger Identifier.
  String httpTriggerURI;

  /// Timeout interval of a function.
  /// For Android, the interval unit is defined by the units parameter and the
  /// default time unit is seconds.
  ///
  /// For iOS, the time unit is seconds. This parameter is optional.
  int timeout;

  /// Time unit definition. This parameter is optional. The default value is
  /// [AGCTimeUnit.SECONDS].
  AGCTimeUnit units;

  /// Default constructor.
  FunctionCallable(
    this.httpTriggerURI, {
    this.timeout = 70,
    this.units = AGCTimeUnit.SECONDS,
  });

  /// Creates a [FunctionCallable] object from a JSON string.
  factory FunctionCallable.fromJson(String source) {
    return FunctionCallable.fromMap(json.decode(source));
  }

  /// Creates a [FunctionCallable] object from a map.
  factory FunctionCallable.fromMap(Map<String, dynamic> map) {
    return FunctionCallable(
      map['httpTriggerURI'],
      timeout: map['timeout'],
      units: AGCTimeUnit.fromInt(map['units']),
    );
  }

  /// Configures and calls a cloud function.
  Future<FunctionResult> call([dynamic parameters]) async {
    final FunctionResult functionResult =
        await _AGConnectCloudFunctions.callFunction(
      arguments: toMap()..putIfAbsent('functionParameters', () => parameters),
    );
    return functionResult;
  }

  /// Clones [FunctionCallable] object.
  FunctionCallable clone(
      {String? httpTriggerURI, int? timeout, AGCTimeUnit? units}) {
    return FunctionCallable(
      httpTriggerURI ?? this.httpTriggerURI,
      timeout: timeout ?? this.timeout,
      units: units ?? this.units,
    );
  }

  /// Converts [FunctionCallable] object to map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'httpTriggerURI': httpTriggerURI,
      'timeout': timeout,
      'units': units.toInt(),
    };
  }

  /// Converts [FunctionCallable] object to JSON string.
  String toJson() => json.encode(toMap());

  /// Converts [FunctionCallable] object to string.
  @override
  String toString() =>
      'FunctionCallable(httpTriggerURI: $httpTriggerURI, timeout: $timeout, units: $units)';

  /// Compares two [FunctionCallable] objects.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FunctionCallable &&
            other.httpTriggerURI == httpTriggerURI &&
            other.timeout == timeout &&
            other.units == units);
  }

  /// Generates the hash code for a [FunctionCallable] object.
  @override
  int get hashCode =>
      httpTriggerURI.hashCode ^ timeout.hashCode ^ units.hashCode;
}

/// Internal class to call native Cloud Function methods using Platform Channels.
class _AGConnectCloudFunctions {
  static const MethodChannel _methodChannel = const MethodChannel(
      'com.huawei.agc.flutter.cloudfunctions/MethodChannel');

  /// Calls the native Cloud Function method and returns the result as [FunctionResult] type.
  static Future<FunctionResult> callFunction(
      {Map<String, dynamic> arguments = const <String, dynamic>{}}) async {
    final String? result =
        await _methodChannel.invokeMethod<String>('callFunction', arguments);
    return FunctionResult(result!);
  }
}
