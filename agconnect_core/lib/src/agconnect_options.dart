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

import 'agconnect_routepolicy.dart';

class AGConnectOptions {
  static const MethodChannel _channel =
      const MethodChannel('com.huawei.flutter/agconnect_core');

  String? productId;
  String? appId;
  String? cpId;
  String? clientId;
  String? clientSecret;
  String? apiKey;
  int? routePolicy;
  String? packageName;

  AGConnectOptions(AGConnectOptionsBuilder builder) :
      productId = builder.productId,
      appId = builder.appId,
      cpId = builder.cpId,
      clientId = builder.clientId,
      clientSecret = builder.clientSecret,
      apiKey = builder.apiKey,
      routePolicy = builder.routePolicy,
      packageName = builder.packageName;

  /// Gets route policy of project.
  Future<int?> getRoutePolicy() {
    if (Platform.isIOS) {
      print(
          'The getRoutePolicy method only supports Android, please refer to the iOS development guide to getRoutePolicy secret on iOS.');
    }
    return _channel.invokeMethod('getRoutePolicy')
        .then((value) => getRoutePolicyFromName(value["routeName"]));
  }

  /// Gets package name of project.
  Future<String?> getPackageName() {
    if (Platform.isIOS) {
      print(
          'The getPackageName method only supports Android, please refer to the iOS development guide to getPackageName secret on iOS.');
    }
    return _channel.invokeMethod('getPackageName').then((value) => value);
  }

  /// Gets parameter from agconnect-services.json file.
  Future<String?> getString(String path,String def) {
    if (Platform.isIOS) {
      print(
          'The getString method only supports Android, please refer to the iOS development guide to getString secret on iOS.');
    }
      return _channel.invokeMethod(
          'getString', <String, dynamic>{'path': path,'def':def}).then((value) => value);
  }

  int getRoutePolicyFromName(String routeName){
    switch (routeName) {
      case "GERMANY":
      return AGCRoutePolicy.GERMANY;
      case "CHINA":
        return AGCRoutePolicy.CHINA;
      case "RUSSIA":
        return AGCRoutePolicy.RUSSIA;
      case "SINGAPORE":
        return AGCRoutePolicy.SINGAPORE;
      default:
        return AGCRoutePolicy.UNKNOWN;
    }
  }
}

class AGConnectOptionsBuilder{
  String? productId;
  String? appId;
  String? cpId;
  String? clientId;
  String? clientSecret;
  String? apiKey;
  int? routePolicy;
  String? packageName;
}
