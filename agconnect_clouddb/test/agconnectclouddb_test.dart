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

  group("fail test", () {
    const MethodChannel channel =
    MethodChannel('com.huawei.agconnectclouddb/methodChannel/');

    Future<Object?> handler(MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getCloudDBZoneConfigs':
          return [
            {
              "zoneName": "demo",
              "capacity": 50,
              "syncProperty": 1,
              "accessProperty": 0,
              "isPersistenceEnabled": false,
              "isEncrypted": false,
            }
          ];
        case 'openCloudDBZone':
        case 'openCloudDBZone2':
          return {
            "zoneId": "demo",
          };
        case 'closeCloudDBZone':
        case 'deleteCloudDBZone':
        case 'enableNetwork':
        case 'disableNetwork':
        case 'setUserKey':
        case 'updateDataEncryptionKey':
        case 'initialize':
        case 'createObjectType':
          return true;
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

    test('getCloudDBZoneConfigs', () async {
      var result = await AGConnectCloudDB.getInstance().getCloudDBZoneConfigs();
      expect(50, result[0].capacity);
      expect(false, result[0].isEncrypted);
      expect(AGConnectCloudDBZoneSyncProperty.CLOUDDBZONE_CLOUD_CACHE,
          result[0].syncProperty);
    });

    test('initialize', () async {
      await AGConnectCloudDB.getInstance().initialize();
    });

    test('createObjectType', () async {
      await AGConnectCloudDB.getInstance().createObjectType();
    });

    test('openCloudDBZone', () async {
      await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
    });

    test('openCloudDBZone2', () async {
      await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
    });

    test('closeCloudDBZone', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      await AGConnectCloudDB.getInstance().closeCloudDBZone(zone: zone);
    });

    test('deleteCloudDBZone', () async {
      await AGConnectCloudDB.getInstance().deleteCloudDBZone(zoneName: 'demo');
    });

    test('enableNetwork', () async {
      await AGConnectCloudDB.getInstance().enableNetwork(zoneName: 'demo');
    });

    test('disableNetwork', () async {
      await AGConnectCloudDB.getInstance().disableNetwork(zoneName: 'demo');
    });

    test('setUserKey', () async {
      await AGConnectCloudDB.getInstance()
          .setUserKey(userKey: 'test', userReKey: '', needStrongCheck: false);
    });

    test('updateDataEncryptionKey', () async {
      await AGConnectCloudDB.getInstance().updateDataEncryptionKey();
    });

    test('onDataEncryptionKeyChanged', () async {
      AGConnectCloudDB.getInstance()
          .onDataEncryptionKeyChanged()
          .listen((bool? changed) {
        expect(changed, true);
      });

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
          'com.huawei.agconnectclouddb/eventChannel/onDataEncryptionKeyChange',
          const StandardMethodCodec().encodeSuccessEnvelope(true),
              (ByteData? data) {});
    });

    test('onEvent', () async {
      AGConnectCloudDB.getInstance().onEvent().listen((String? changed) {
        expect(changed, 'Test');
      });

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
          'com.huawei.agconnectclouddb/eventChannel/onEvent',
          const StandardMethodCodec().encodeSuccessEnvelope('Test'),
              (ByteData? data) {});
    });
  });
}
