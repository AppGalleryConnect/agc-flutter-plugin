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
import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_core/agconnect_core.dart';

void main() {
  const MethodChannel channel = MethodChannel('com.huawei.flutter/agconnect_core');
  final optionsBuilder = AGConnectOptionsBuilder()
    ..productId = "productId"
    ..appId = "appId"
    ..cpId = "cpId"
    ..clientId = "clientId"
    ..clientSecret = "clientSecret"
    ..apiKey = "apiKey"
    ..routePolicy = AGCRoutePolicy.GERMANY
    ..packageName = "packageName";

  TestWidgetsFlutterBinding.ensureInitialized();
  MethodCall? mockCall;
  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      mockCall = methodCall;
      switch (methodCall.method) {
        case'buildInstance':
          return null;
        case'getRoutePolicy':
          return null;
        case'getPackageName':
          return null;
        case'getString':
          return null;
      }
      throw PlatformException(code: '0', message: 'Unknown method call, please update test.');
    });
    mockCall = null;
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('buildInstance', () async {
    await AGConnectInstance.instance.buildInstance(AGConnectOptions(optionsBuilder));
    expect(mockCall?.method, 'buildInstance');
    expect(mockCall?.arguments, {
      'productId': 'productId',
      'appId': 'appId',
      'cpId': 'cpId',
      'clientId': 'clientId',
      'clientSecret': 'clientSecret',
      'apiKey': 'apiKey',
      'routePolicy': 2,
      'packageName': 'packageName'
    });
  });

  test('getPackageName', () async {
    await AGConnectOptions(optionsBuilder)
        .getPackageName();
    expect(mockCall?.method, 'getPackageName');
    expect(mockCall?.arguments, null);
  });

  test('getString', () async {
    await AGConnectOptions(optionsBuilder).getString("appId", "defaultValue");
    expect(mockCall?.method, 'getString');
    expect(mockCall?.arguments,{'path': 'appId', 'def': 'defaultValue'});
  });

}
