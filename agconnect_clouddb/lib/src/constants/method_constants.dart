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

// ignore_for_file: constant_identifier_names

part of agconnect_clouddb;

abstract class _MethodConstants {
  static const String INITIALIZE = 'initialize';
  static const String CREATE_OBJECT_TYPE = 'createObjectType';

  static const String GET_CLOUD_DB_ZONE_CONFIGS = 'getCloudDBZoneConfigs';
  static const String OPEN_CLOUD_DB_ZONE = 'openCloudDBZone';
  static const String OPEN_CLOUD_DB_ZONE_2 = 'openCloudDBZone2';
  static const String CLOSE_CLOUD_DB_ZONE = 'closeCloudDBZone';
  static const String DELETE_CLOUD_DB_ZONE = 'deleteCloudDBZone';
  static const String ENABLE_NETWORK = 'enableNetwork';
  static const String DISABLE_NETWORK = 'disableNetwork';
  static const String SET_USER_KEY = 'setUserKey';
  static const String UPDATE_DATA_ENCRYPTION_KEY = 'updateDataEncryptionKey';

  static const String GET_CLOUD_DB_ZONE_CONFIG = 'getCloudDBZoneConfig';
  static const String EXECUTE_UPSERT = 'executeUpsert';
  static const String EXECUTE_DELETE = 'executeDelete';
  static const String EXECUTE_QUERY = 'executeQuery';
  static const String EXECUTE_AVERAGE_QUERY = 'executeAverageQuery';
  static const String EXECUTE_SUM_QUERY = 'executeSumQuery';
  static const String EXECUTE_MAXIMUM_QUERY = 'executeMaximumQuery';
  static const String EXECUTE_MINIMAL_QUERY = 'executeMinimalQuery';
  static const String EXECUTE_COUNT_QUERY = 'executeCountQuery';
  static const String EXECUTE_QUERY_UNSYNCED = 'executeQueryUnsynced';
  static const String EXECUTE_SERVER_STATUS_QUERY = 'executeServerStatusQuery';
  static const String RUN_TRANSACTION = 'runTransaction';
  static const String SUBSCRIBE_SNAPSHOT = 'subscribeSnapshot';
}
