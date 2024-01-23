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

import 'package:agconnect_clouddb/agconnect_clouddb.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("exception test", () {
    const MethodChannel channel =
    MethodChannel('com.huawei.agconnectclouddb/methodChannel/');

    Future<Object?> handler(MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'executeQueryUnsynced':
          throw PlatformException(code: '1');
        case 'executeQuery':
          throw MissingPluginException('Please add plugin');
        case 'openCloudDBZone2':
          return {
            "zoneId": "demo",
          };
        default:
          throw PlatformException(
              code: '0', message: 'Unknown method call, please update test.');
      }
    }

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, handler);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('PlatformException', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(() =>
          zone.executeQueryUnsynced(query: AGConnectCloudDBQuery('BookInfo')),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('PluginException', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(() =>
          zone.executeQuery(query: AGConnectCloudDBQuery('BookInfo'),policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('ToString', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      try{
       await zone.executeQuery(query: AGConnectCloudDBQuery('BookInfo'),policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      }
      on AGConnectCloudDBException catch(e){
        expect("AGConnectCloudDBException(code: UNKNOWN, message: Something went wrong.)", e.toString());
      }
    });
  });
}
