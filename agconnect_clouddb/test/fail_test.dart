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
        case 'openCloudDBZone':
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

    test('initializeFail', () async {
      expect(() => AGConnectCloudDB.getInstance().initialize(),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('createObjectTypeFail', () async {
      expect(() => AGConnectCloudDB.getInstance().createObjectType(),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('getCloudDBZoneConfigsFail', () async {
      expect(() => AGConnectCloudDB.getInstance().getCloudDBZoneConfigs(),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('closeCloudDBZoneFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(() => AGConnectCloudDB.getInstance().closeCloudDBZone(zone: zone),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('openCloudDBZone2Fail', () async {
      expect(
          () => AGConnectCloudDB.getInstance().openCloudDBZone2(
              zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo')),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('deleteCloudDBZoneFail', () async {
      expect(
          () => AGConnectCloudDB.getInstance()
              .deleteCloudDBZone(zoneName: 'demo'),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('deleteCloudDBZoneEmptyZone', () async {
      expect(
          () => AGConnectCloudDB.getInstance().deleteCloudDBZone(zoneName: ''),
          throwsA(isA<FormatException>()));
    });

    test('enableNetworkFail', () async {
      expect(
          () => AGConnectCloudDB.getInstance().enableNetwork(zoneName: 'demo'),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('enableNetworkEmptyZone', () async {
      expect(() => AGConnectCloudDB.getInstance().enableNetwork(zoneName: ''),
          throwsA(isA<FormatException>()));
    });

    test('disableNetworkFail', () async {
      expect(
          () => AGConnectCloudDB.getInstance().disableNetwork(zoneName: 'demo'),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('disableNetworkEmptyZone', () async {
      expect(() => AGConnectCloudDB.getInstance().disableNetwork(zoneName: ''),
          throwsA(isA<FormatException>()));
    });

    test('setUserKeyFail', () async {
      expect(
          () => AGConnectCloudDB.getInstance().setUserKey(
              userKey: 'test', userReKey: '', needStrongCheck: false),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('updateDataEncryptionKeyFail', () async {
      expect(() => AGConnectCloudDB.getInstance().updateDataEncryptionKey(),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('subscribeSnapshotFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.subscribeSnapshot(
              query: AGConnectCloudDBQuery('BookInfo'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('runTransactionFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.runTransaction(transaction: AGConnectCloudDBTransaction()),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeServerStatusQueryFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(() => zone.executeServerStatusQuery(),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeQueryUnsyncedFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeQueryUnsynced(
              query: AGConnectCloudDBQuery('BookInfo')),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeCountQueryFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeCountQuery(
              field: 'field',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeCountQueryEmptyField', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeCountQuery(
              field: '',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<FormatException>()));
    });

    test('executeMinimalQueryFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeMinimalQuery(
              field: 'field',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeMinimalQueryEmptyField', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeMinimalQuery(
              field: '',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<FormatException>()));
    });

    test('executeMaximumQueryFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeMaximumQuery(
              field: 'field',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeMaximumQueryEmptyField', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeMaximumQuery(
              field: '',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<FormatException>()));
    });

    test('executeSumQueryFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeSumQuery(
              field: 'field',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeSumQueryEmptyField', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeSumQuery(
              field: '',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<FormatException>()));
    });

    test('executeAverageQueryFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeAverageQuery(
              field: 'field',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeAverageQueryEmptyField', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeAverageQuery(
              field: '',
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<FormatException>()));
    });

    test('executeQueryFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeQuery(
              query: AGConnectCloudDBQuery('objectTypeName'),
              policy: AGConnectCloudDBZoneQueryPolicy.POLICY_QUERY_DEFAULT),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeDeleteEmptyObjectName', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeDelete(objectTypeName: '', entries: List.empty()),
          throwsA(isA<FormatException>()));
    });

    test('executeDeleteEmptyList', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () =>
              zone.executeDelete(objectTypeName: 'test', entries: List.empty()),
          throwsA(isA<FormatException>()));
    });

    test('executeDeleteFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeDelete(objectTypeName: 'test', entries: [
                {'test': '1'}
              ]),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('executeUpsertEmptyObjectName', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeUpsert(objectTypeName: '', entries: List.empty()),
          throwsA(isA<FormatException>()));
    });

    test('executeUpsertEmptyList', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () =>
              zone.executeUpsert(objectTypeName: 'test', entries: List.empty()),
          throwsA(isA<FormatException>()));
    });

    test('executeUpsertFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(
          () => zone.executeUpsert(objectTypeName: 'test', entries: [
                {'test': '1'}
              ]),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('getCloudDBZoneConfigFail', () async {
      var zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
          zoneConfig: AGConnectCloudDBZoneConfig(zoneName: 'demo'));
      expect(() => zone.getCloudDBZoneConfig(),
          throwsA(isA<AGConnectCloudDBException>()));
    });

    test('AGConnectCloudDBZoneConfigEmptyName', () async {
      expect(
              () => AGConnectCloudDBZoneConfig(zoneName: ''),
          throwsA(isA<FormatException>()));
    });

    test('transactionUpsertEmptyObject', () async {
      expect(
              () => AGConnectCloudDBTransaction().executeUpsert(objectTypeName: '', entries: List.empty()),
          throwsA(isA<FormatException>()));
    });

    test('transactionUpsertEmptyList', () async {
      expect(
              () => AGConnectCloudDBTransaction().executeUpsert(objectTypeName: 'test', entries: List.empty()),
          throwsA(isA<FormatException>()));
    });

    test('transactionDeleteEmptyObject', () async {
      expect(
              () => AGConnectCloudDBTransaction().executeDelete(objectTypeName: '', entries: List.empty()),
          throwsA(isA<FormatException>()));
    });

    test('transactionDeleteEmptyList', () async {
      expect(
              () => AGConnectCloudDBTransaction().executeDelete(objectTypeName: 'test', entries: List.empty()),
          throwsA(isA<FormatException>()));
    });

    test('AGConnectCloudDBQueryEmpty', () async {
      expect(
              () => AGConnectCloudDBQuery(''),
          throwsA(isA<FormatException>()));
    });
  });
}
