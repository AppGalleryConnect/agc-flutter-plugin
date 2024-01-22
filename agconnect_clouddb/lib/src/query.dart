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

part of agconnect_clouddb;

/// **These methods are called as range query:**
///
/// * **startAt()**
/// * **startAfter()**
/// * **endAt()**
/// * **endBefore()**
///
/// In a query, only one of the **range query** method can be used and can be called only once.
///
/// When constructing query conditions, **range query** method can be used independently
/// or used together with the equalTo(), orderBy(), or limit() method.
///
/// The combination of range query methods and the equalTo(), or orderBy() method
/// must be performed **after** the equalTo(), or orderBy() method and **before** limit().
///
/// * If **range query** method is not used with orderBy(), data records are sorted in
///   ascending order of the primary key by default, and data records after
///   the specified start position are returned.
/// * When **range query** method is used together with equalTo(), the query field
///   specified by equalTo() cannot be a primary key field.
/// * When **range query** method is used together with orderBy(),
///   only one of them can be used (ascending or descending).
///   The value of the field specified by orderBy() cannot be empty.
/// * When **range query** method is used together with equalTo() and orderBy()
///   either ascending or descending, the field specified by equalTo() cannot be
///   the same as that by orderBy().
class AGConnectCloudDBQuery {
  final String _objectTypeName;
  final List<Map<String, dynamic>> _queryElements = <Map<String, dynamic>>[];

  AGConnectCloudDBQuery(String objectTypeName)
      : _objectTypeName = objectTypeName {
    if (objectTypeName.isEmpty) {
      throw FormatException(
          'objectTypeName cannot be an empty string.', objectTypeName);
    }
  }

  Map<String, dynamic> get query {
    return <String, dynamic>{
      _QueryConstants.ZONE_OBJECT_TYPE_NAME: _objectTypeName,
      _QueryConstants.QUERY_ELEMENTS: _queryElements,
    };
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field in an entity class is equal to the specified value.
  ///
  /// **Supports the following data types:**
  ///
  /// * **bool** for Boolean.
  /// * **int** for Byte, Short, Integer, Long, and Date.
  /// * **double** for Double, and Float.
  /// * **String** for String, and Text.
  void equalTo(String field, dynamic value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    if (value == null) {
      throw FormatException('value cannot be null.', value);
    }
    if (!(value is bool ||
        value is int ||
        value is double ||
        value is String)) {
      throw FormatException(
          'value should be bool, int, double or String.', value);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.EQUAL_TO,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field in an entity class is not equal to the specified value.
  ///
  /// **Supports the following data types:**
  ///
  /// * **bool** for Boolean.
  /// * **int** for Byte, Short, Integer, Long, and Date.
  /// * **double** for Double, and Float.
  /// * **String** for String, and Text.
  void notEqualTo(String field, dynamic value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    if (value == null) {
      throw FormatException('value cannot be null.', value);
    }
    if (!(value is bool ||
        value is int ||
        value is double ||
        value is String)) {
      throw FormatException(
          'value should be bool, int, double or String.', value);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.NOT_EQUAL_TO,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field in an entity class is less than the specified value.
  ///
  /// **Supports the following data types:**
  ///
  /// * **int** for Byte, Short, Integer, Long, and Date.
  /// * **double** for Double, and Float.
  /// * **String** for String, and Text.
  void lessThan(String field, dynamic value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    if (value == null) {
      throw FormatException('value cannot be null.', value);
    }
    if (!(value is int || value is double || value is String)) {
      throw FormatException('value should be int, double or String.', value);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.LESS_THAN,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field in an entity class is less than or equal to the specified value.
  ///
  /// **Supports the following data types:**
  ///
  /// * **int** for Byte, Short, Integer, Long, and Date.
  /// * **double** for Double, and Float.
  /// * **String** for String, and Text.
  void lessThanOrEqualTo(String field, dynamic value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    if (value == null) {
      throw FormatException('value cannot be null.', value);
    }
    if (!(value is int || value is double || value is String)) {
      throw FormatException('value should be int, double or String.', value);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.LESS_THAN_OR_EQUAL_TO,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field in an entity class is greater than the specified value.
  ///
  /// **Supports the following data types:**
  ///
  /// * **int** for Byte, Short, Integer, Long, and Date.
  /// * **double** for Double, and Float.
  /// * **String** for String, and Text.
  void greaterThan(String field, dynamic value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    if (value == null) {
      throw FormatException('value cannot be null.', value);
    }
    if (!(value is int || value is double || value is String)) {
      throw FormatException('value should be int, double or String.', value);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.GREATER_THAN,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field in an entity class is greater than or equal to the specified value.
  ///
  /// **Supports the following data types:**
  ///
  /// * **int** for Byte, Short, Integer, Long, and Date.
  /// * **double** for Double, and Float.
  /// * **String** for String, and Text.
  void greaterThanOrEqualTo(String field, dynamic value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    if (value == null) {
      throw FormatException('value cannot be null.', value);
    }
    if (!(value is int || value is double || value is String)) {
      throw FormatException('value should be int, double or String.', value);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.GREATER_THAN_OR_EQUAL_TO,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field in an entity class is included in a specified array.
  ///
  /// **Supports the following data types:**
  ///
  /// * **int** for Byte, Short, Integer, Long, and Date array.
  /// * **double** for Double, and Float array.
  /// * **String** for String, and Text array.
  void whereIn(String field, List<dynamic> value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    if (value.isEmpty) {
      throw FormatException('value cannot be an empty list.', value);
    }
    if (!(value is List<int> ||
        value is List<double> ||
        value is List<String>)) {
      throw FormatException(
          'value should be List<int>, List<double> or List<String>.', value);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.IN,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field of the String or Text type in an entity class starts with a specified substring.
  ///
  /// **Supports the following data types:**
  ///
  /// * **String** for String, and Text.
  void beginsWith(String field, String value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.BEGINS_WITH,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field of the String or Text type in an entity class ends with a specified substring.
  ///
  /// **Supports the following data types:**
  ///
  /// * **String** for String, and Text.
  void endsWith(String field, String value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.ENDS_WITH,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// the value of a field in an entity class contains a specified substring.
  ///
  /// **Supports the following data types:**
  ///
  /// * **String** for String, and Text.
  void contains(String field, String value) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.CONTAINS,
        _QueryConstants.VALUE: value,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// a field in an entity class is null.
  void isNull(String field) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.IS_NULL,
      },
    );
  }

  /// You can invoke this method to add a query condition in which
  /// a field in an entity class is not null.
  void isNotNull(String field) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: _QueryConstants.IS_NOT_NULL,
      },
    );
  }

  /// You can call this method to sort query results by a specified field.
  /// **You are advised to call this method after all the other methods.**
  ///
  /// When using this method to sort fields, you are advised to create indexes for the sorted fields.
  /// Otherwise, when the number of data records of the object type reaches a certain value,
  /// the query may time out or fail due to low query efficiency, affecting user experience.
  void orderBy(String field, {bool ascending = true}) {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.FIELD: field,
        _QueryConstants.OPERATION: ascending
            ? _QueryConstants.ORDER_BY_ASC
            : _QueryConstants.ORDER_BY_DESC,
      },
    );
  }

  /// You can invoke this method to add query conditions to specify
  /// the number of data records in the returned query result set.
  ///
  /// * If you do not set offset, the first count objects are obtained by default.
  ///   If the number of objects in the query result set is less than count, all objects are returned.
  /// * If offset is set, the first count objects **starting from the offset position** are returned.
  ///   If the number of objects starting from the offset position is less than the count value,
  ///   all object data starting from the offset position is returned.
  void limit(int count, {int? offset}) {
    if (count < 1) {
      throw FormatException('count cannot be less than 1.', count);
    }
    if (offset != null && offset < 1) {
      throw FormatException('offset should be greater than 0.', offset);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.OPERATION: _QueryConstants.LIMIT,
        _QueryConstants.VALUE: count,
        _QueryConstants.OFFSET: offset,
      },
    );
  }

  /// This method is used to set the **start position** of the data to be queried,
  /// and return to the data records with the corresponding records at the **start position included**.
  ///
  /// To ensure the query performance of startAt(), you need to create the index
  /// required by the Cloud DB before calling this method to construct the query condition.
  /// If no index is created, you may receive an exception message.
  /// You need to create the missing index based on the exception message.
  void startAt(Map<String, dynamic> dataEntry) {
    if (dataEntry.isEmpty) {
      throw FormatException('dataEntry cannot be empty.', dataEntry);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.OPERATION: _QueryConstants.START_AT,
        _QueryConstants.ZONE_OBJECT_DATA_ENTRY: dataEntry,
      },
    );
  }

  /// This method is used to set the **start position** of the data to be queried,
  /// and return to the data records with the corresponding records at the **start position not included**.
  ///
  /// To ensure the query performance of startAfter(), you need to create the index
  /// required by the Cloud DB before calling this method to construct the query condition.
  /// If no index is created, you may receive an exception message.
  /// You need to create the missing index based on the exception message.
  void startAfter(Map<String, dynamic> dataEntry) {
    if (dataEntry.isEmpty) {
      throw FormatException('dataEntry cannot be empty.', dataEntry);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.OPERATION: _QueryConstants.START_AFTER,
        _QueryConstants.ZONE_OBJECT_DATA_ENTRY: dataEntry,
      },
    );
  }

  /// This method is used to set the **end position** of the data to be queried,
  /// and return to the data records with the corresponding records at the **end position included**.
  ///
  /// To ensure the query performance of endAt(), you need to create the index
  /// required by the Cloud DB before calling this method to construct the query condition.
  /// If no index is created, you may receive an exception message.
  /// You need to create the missing index based on the exception message.
  void endAt(Map<String, dynamic> dataEntry) {
    if (dataEntry.isEmpty) {
      throw FormatException('dataEntry cannot be empty.', dataEntry);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.OPERATION: _QueryConstants.END_AT,
        _QueryConstants.ZONE_OBJECT_DATA_ENTRY: dataEntry,
      },
    );
  }

  /// This method is used to set the **end position** of the data to be queried,
  /// and return to the data records with the corresponding records at the **end position not included**.
  ///
  /// To ensure the query performance of endBefore(), you need to create the index
  /// required by the Cloud DB before calling this method to construct the query condition.
  /// If no index is created, you may receive an exception message.
  /// You need to create the missing index based on the exception message.
  void endBefore(Map<String, dynamic> dataEntry) {
    if (dataEntry.isEmpty) {
      throw FormatException('dataEntry cannot be empty.', dataEntry);
    }
    _queryElements.add(
      <String, dynamic>{
        _QueryConstants.OPERATION: _QueryConstants.END_BEFORE,
        _QueryConstants.ZONE_OBJECT_DATA_ENTRY: dataEntry,
      },
    );
  }
}
