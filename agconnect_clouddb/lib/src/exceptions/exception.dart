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

part of agconnect_clouddb;

class AGConnectCloudDBException implements Exception {
  final String code;
  final String message;

  const AGConnectCloudDBException._({
    required this.code,
    required this.message,
  });

  factory AGConnectCloudDBException._from(dynamic e) {
    if (e is AGConnectCloudDBException) {
      return e;
    } else {
      if (e is PlatformException) {
        return AGConnectCloudDBException._(
          code: e.code,
          message: e.message ?? 'Something went wrong.',
        );
      } else {
        return AGConnectCloudDBException._(
          code: 'UNKNOWN',
          message: e is String ? e : 'Something went wrong.',
        );
      }
    }
  }

  @override
  String toString() {
    return '$AGConnectCloudDBException(code: $code, message: $message)';
  }
}
