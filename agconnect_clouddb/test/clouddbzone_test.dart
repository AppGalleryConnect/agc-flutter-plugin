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

  group("clouddbzone test", () {
    const MethodChannel channel =
        MethodChannel('com.huawei.agconnectclouddb/methodChannel/');

    Future<Object?> handler(MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getCloudDBZoneConfig':
          return {
            "zoneName": "demo",
            "capacity": 50,
            "syncProperty": 1,
            "accessProperty": 0,
            "isPersistenceEnabled": false,
            "isEncrypted": false,
          };
        case 'executeQuery':
        case 'executeQueryUnsynced':
        case 'subscribeSnapshot':
          return {
            "isFromCloud": true,
            "hasPendingWrites": false,
            "snapshotObjects": [
              {'id': 1, 'author': 'Test', 'price': 5}
            ],
            "upsertedObjects": [
              {'id': 1, 'author': 'Test', 'price': 5}
            ],
            "deletedObjects": [
              {'id': 1, 'author': 'Test', 'price': 5}
            ],
          };
        case 'openCloudDBZone2':
          return {
            "zoneId": "demo",
          };
        case 'executeServerStatusQuery':
          return {
            "serverTimeStamp": 1,
          };
        case 'executeUpsert':
        case 'executeDelete':
        case 'executeCountQuery':
          return 50;
        case 'executeAverageQuery':
        case 'executeSumQuery':
        case 'executeMaximumQuery':
        case 'executeMinimalQuery':
          return 5;
        case 'runTransaction':
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

    test('getCloudDBZoneConfig', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.getCloudDBZoneConfig();
      expect(50, result.capacity);
    });

    test('executeUpsert', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result =
          await zone.executeUpsert(objectTypeName: "BookInfo", entries: [
        {'id': 1, 'author': 'Test', 'price': 5}
      ]);
      expect(50, result);
    });

    test('executeDelete', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result =
          await zone.executeDelete(objectTypeName: "BookInfo", entries: [
        {'id': 1, 'author': 'Test', 'price': 5}
      ]);
      expect(50, result);
    });

    test('executeQuery', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeQuery(
          query: AGConnectCloudDBQuery('BookInfo'),
          policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      result.toString();
      expect(1, result.snapshotObjects.length);
      expect(5, result.snapshotObjects[0]['price']);
    });

    test('executeAverageQuery', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeAverageQuery(
          field: 'price',
          query: AGConnectCloudDBQuery('BookInfo'),
          policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      expect(5, result);
    });

    test('executeAverageQuery', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeAverageQuery(
          field: 'price',
          query: AGConnectCloudDBQuery('BookInfo'),
          policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      expect(5, result);
    });

    test('executeSumQuery', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeSumQuery(
          field: 'price',
          query: AGConnectCloudDBQuery('BookInfo'),
          policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      expect(5, result);
    });

    test('executeMaximumQuery', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeMaximumQuery(
          field: 'price',
          query: AGConnectCloudDBQuery('BookInfo'),
          policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      expect(5, result);
    });

    test('executeMinimalQuery', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeMinimalQuery(
          field: 'price',
          query: AGConnectCloudDBQuery('BookInfo'),
          policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      expect(5, result);
    });

    test('executeCountQuery', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeCountQuery(
          field: 'price',
          query: AGConnectCloudDBQuery('BookInfo'),
          policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      expect(50, result);
    });

    test('executeQueryUnsynced', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeQueryUnsynced(
          query: AGConnectCloudDBQuery('BookInfo'));
      expect(1, result.snapshotObjects.length);
      expect(5, result.snapshotObjects[0]['price']);
    });

    test('executeServerStatusQuery', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.executeServerStatusQuery();
      expect(1, result.getServerTimeStamp());
      expect('1', result.toString());
    });

    test('runTransaction', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      await zone.runTransaction(
          transaction: AGConnectCloudDBTransaction()
            ..executeUpsert(
              objectTypeName: 'BookInfo',
              entries: <Map<String, dynamic>>[
                <String, dynamic>{
                  'id': 10,
                  'bookName': 'Book_10',
                  'price': 5.10,
                },
                <String, dynamic>{
                  'id': 20,
                  'bookName': 'Book_20',
                  'price': 25.20,
                },
              ],
            )
            ..executeDelete(
                objectTypeName: 'BookInfo',
                entries: <Map<String, dynamic>>[
                  <String, dynamic>{
                    'id': 10,
                    'bookName': 'Book_10',
                    'price': 5.10,
                  },
                  <String, dynamic>{
                    'id': 20,
                    'bookName': 'Book_20',
                    'price': 25.20,
                  },
                ]));
    });

    test('subscribeSnapshot', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone2(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      var result = await zone.subscribeSnapshot(
          query: AGConnectCloudDBQuery('BookInfo'),
          policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT);
      result.listen((AGConnectCloudDBZoneSnapshot? snapshot) {
        expect(1, snapshot?.snapshotObjects[0].length);
      });
    });
  });
}
