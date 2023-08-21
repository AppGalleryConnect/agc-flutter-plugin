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

import 'dart:io';

import 'package:flutter/services.dart';

import 'agconnect_options.dart';

class AGConnectInstance {
  static const MethodChannel _channel =
  const MethodChannel('com.huawei.flutter/agconnect_core');

  static final AGConnectInstance instance = AGConnectInstance();

  /// Sets instance with specified parameters.
  /// @options options of AGConnect.
  Future<void> buildInstance(AGConnectOptions options) {
    if(Platform.isIOS) {
      print('The buildInstance method only supports Android, please refer to the iOS development guide to buildInstance secret on iOS.');
    }
    return _channel.invokeMethod(
        'buildInstance', <String, dynamic>{
          'productId': options.productId,
          'appId': options.appId,
          'cpId': options.cpId,
          'clientId': options.clientId,
          'clientSecret': options.clientSecret,
          'apiKey': options.apiKey,
          'routePolicy': options.routePolicy,
          'packageName': options.packageName,
        });
  }
}
