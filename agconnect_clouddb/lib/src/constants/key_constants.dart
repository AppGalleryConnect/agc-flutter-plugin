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

abstract class _KeyConstants {
  static const String EVENT_CHANNEL_NAME = 'eventChannelName';

  static const String ZONE_ID = 'zoneId';
  static const String ZONE_NAME = 'zoneName';
  static const String ZONE_CONFIG = 'zoneConfig';
  static const String ZONE_OBJECT_TYPE_NAME = 'zoneObjectTypeName';
  static const String ZONE_OBJECT_DATA_ENTRIES = 'zoneObjectDataEntries';
  static const String FIELD = 'field';
  static const String QUERY = 'query';
  static const String TRANSACTION_ELEMENTS = 'transactionElements';
  static const String POLICY_INDEX = 'policyIndex';
  static const String IS_ALLOW_TO_CREATE = 'isAllowToCreate';
  static const String USER_KEY = 'userKey';
  static const String USER_RE_KEY = 'userReKey';
  static const String NEED_STRONG_CHECK = 'needStrongCheck';
}
