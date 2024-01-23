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

abstract class _QueryConstants {
  static const String ZONE_OBJECT_TYPE_NAME = 'zoneObjectTypeName';
  static const String ZONE_OBJECT_DATA_ENTRY = 'zoneObjectDataEntry';
  static const String QUERY_ELEMENTS = 'queryElements';
  static const String FIELD = 'field';
  static const String OPERATION = 'operation';
  static const String VALUE = 'value';
  static const String OFFSET = 'offset';

  static const String EQUAL_TO = 'equalTo';
  static const String NOT_EQUAL_TO = 'notEqualTo';
  static const String BEGINS_WITH = 'beginsWith';
  static const String ENDS_WITH = 'endsWith';
  static const String LESS_THAN = 'lessThan';
  static const String LESS_THAN_OR_EQUAL_TO = 'lessThanOrEqualTo';
  static const String GREATER_THAN = 'greaterThan';
  static const String GREATER_THAN_OR_EQUAL_TO = 'greaterThanOrEqualTo';
  static const String IS_NULL = 'isNull';
  static const String IS_NOT_NULL = 'isNotNull';
  static const String IN = 'in';
  static const String CONTAINS = 'contains';
  static const String ORDER_BY_ASC = 'orderByAsc';
  static const String ORDER_BY_DESC = 'orderByDesc';

  static const String LIMIT = 'limit';
  static const String START_AT = 'startAt';
  static const String START_AFTER = 'startAfter';
  static const String END_AT = 'endAt';
  static const String END_BEFORE = 'endBefore';
}
