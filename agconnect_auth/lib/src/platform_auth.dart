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

import 'package:flutter/services.dart';

import '../agconnect_auth.dart';

class PlatformAuth {
  static const MethodChannel methodChannel =
      MethodChannel('com.huawei.flutter/agconnect_auth');

  static const EventChannel eventChannel =
      EventChannel('com.huawei.flutter.event/agconnect_auth');

  static handlePlatformException(Object exception) {
    if (exception is PlatformException) {
      int? code = int.tryParse(exception.code);
      Map? details = exception.details!=null ? exception.details as Map : null;
      throw AGCAuthException(code, details?['exceptionCode'], exception.message);
    }
    throw exception;
  }
}
