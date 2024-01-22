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

abstract class _TransactionConstants {
  static const String OPERATION = 'operation';
  static const String ZONE_OBJECT_TYPE_NAME = 'zoneObjectTypeName';
  static const String ZONE_OBJECT_DATA_ENTRIES = 'zoneObjectDataEntries';

  static const String EXECUTE_UPSERT = 'executeUpsert';
  static const String EXECUTE_DELETE = 'executeDelete';
}
