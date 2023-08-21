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

/// Error Codes of the Remote Configuration SDK
class RemoteConfigException implements Exception {

  /// Network Error Please try again later
  static const int RemoteConfigErrorCodeFetchThrottled = 1;

  /// System error. Contact Huawei technical support.
  static const int RemoteConfigErrorCodeUnknown = 0x0c2a0001;

  /// No parameter condition is configured for the application.
  static const int RemoteConfigErrorCodeRcsConfigEmpty = 0x0c2a0004;

  /// The response data is not changed.
  static const int RemoteConfigErrorCodeDataNotModified = 0x0c2a3001;

  RemoteConfigException({this.code, this.message, this.throttleEndTimeMillis});

  /// Error Code
  final int? code;

  /// Error Description
  final String? message;

  /// Current limiting time, in milliseconds.
  final int? throttleEndTimeMillis;

  @override
  String toString() {
    if (throttleEndTimeMillis != null) {
      return "Exception: code : $code , message: $message. throttle time $throttleEndTimeMillis milliseconds";
    }
    return "Exception: code : $code , message: $message.";
  }
}
