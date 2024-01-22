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

class AGConnectCloudDBZone {
  final String _id;
  final List<String> _activeSnapshotSubscriptionIds = <String>[];

  AGConnectCloudDBZone._(this._id);

  /// You can invoke this method to obtain the current Cloud DB zone configuration information,
  /// including the Cloud DB zone name, synchronization attributes, and access attributes.
  Future<AGConnectCloudDBZoneConfig> getCloudDBZoneConfig() async {
    try {
      final Map<dynamic, dynamic>? result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        _MethodConstants.GET_CLOUD_DB_ZONE_CONFIG,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
        },
      );
      return AGConnectCloudDBZoneConfig._fromMap(
          Map<String, dynamic>.from(result!));
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can invoke this method to write a group of objects to the current Cloud DB zone in batches.
  /// The write operation is atomic. That is, the input objects are either
  /// all successfully written or all fail to be written.
  /// If an object with the same primary key exists in the Cloud DB zone,
  /// the existing object data will be updated. Otherwise, a new object is written.
  ///
  /// Returns the number of objects that are successfully written.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * You can invoke this method to write object data only when Cloud DB zone is opened.
  ///   Otherwise, the write operation will fail.
  /// * The data size of each object in the list must be less than or equal to 2 MB.
  ///   Otherwise, the object data fails to be written.
  /// * The total number of data records in the list must be less than or equal to 1000.
  ///   Otherwise, the write operation fails.
  /// * The data size of all objects in the list must be less than or equal to 2 MB
  ///   only when the data synchronization attribute is cache and
  ///   the data persistency attribute is non-persistent.
  Future<int> executeUpsert({
    required String objectTypeName,
    required List<Map<String, dynamic>> entries,
  }) async {
    if (objectTypeName.isEmpty) {
      throw FormatException(
          'objectTypeName cannot be an empty string.', objectTypeName);
    }
    if (entries.isEmpty) {
      throw FormatException('entries cannot be an empty list.', entries);
    }
    try {
      final int? result = await _methodChannel.invokeMethod<int?>(
        _MethodConstants.EXECUTE_UPSERT,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.ZONE_OBJECT_TYPE_NAME: objectTypeName,
          _KeyConstants.ZONE_OBJECT_DATA_ENTRIES: entries,
        },
      );
      return result!;
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can call this method to delete a group of Cloud DB zone objects
  /// whose primary key values are the same as those of the input object list in batches.
  /// The delete operation focuses only on whether the primary key of the object is consistent,
  /// regardless of whether other attributes of the object match the stored data.
  /// The delete operation is atomic. That is, the input object list is
  /// either all deleted successfully or all fails to be deleted.
  ///
  /// Returns the number of objects that are successfully deleted.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * You can call this method to delete objects only when Cloud DB zone is opened.
  ///   Otherwise, the delete operation fails.
  /// * When a group of objects is deleted, the total number of data records in the list
  ///   must be less than or equal to 1000. Otherwise, the delete operation fails.
  /// * The data size of all objects in the list must be less than or equal to 2 MB.
  ///   Otherwise, the delete operation fails.
  /// * The data size of all objects in the list must be less than or equal to 2 MB
  ///   only when the data synchronization attribute is cache and
  ///   the data persistency attribute is non-persistent.
  Future<int> executeDelete({
    required String objectTypeName,
    required List<Map<String, dynamic>> entries,
  }) async {
    if (objectTypeName.isEmpty) {
      throw FormatException(
          'objectTypeName cannot be an empty string.', objectTypeName);
    }
    if (entries.isEmpty) {
      throw FormatException('entries cannot be an empty list.', entries);
    }
    try {
      final int? result = await _methodChannel.invokeMethod<int?>(
        _MethodConstants.EXECUTE_DELETE,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.ZONE_OBJECT_TYPE_NAME: objectTypeName,
          _KeyConstants.ZONE_OBJECT_DATA_ENTRIES: entries,
        },
      );
      return result!;
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can invoke this method to query object data that meets
  /// specific conditions from the Cloud DB zone.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * You can invoke this method to query object data only when Cloud DB zone is opened.
  ///   Otherwise, the query will fail.
  /// * When querying data, ensure that the size of each query result is
  ///   less than or equal to 5 MB. Otherwise, the query fails.
  /// * It is recommended that the number of data records in the query result be
  ///   less than or equal to 100. Otherwise, the performance deteriorates.
  ///   The number of data records in the query result cannot exceed 1000. Otherwise, the query fails.
  Future<AGConnectCloudDBZoneSnapshot> executeQuery({
    required AGConnectCloudDBQuery query,
    required AGConnectCloudDBZoneQueryPolicy policy,
  }) async {
    try {
      final Map<dynamic, dynamic>? result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        _MethodConstants.EXECUTE_QUERY,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.QUERY: query.query,
          _KeyConstants.POLICY_INDEX: policy.index,
        },
      );
      return AGConnectCloudDBZoneSnapshot._fromMap(
          Map<String, dynamic>.from(result!));
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can invoke this method to query Cloud DB zone object data that
  /// meets specified conditions and return the average value of specified fields.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * You can invoke this method to query the average value of specified fields
  ///   only when Cloud DB zone is opened. Otherwise, the query will fail.
  /// * Supports the following data types:
  ///   * **int** for Short, Integer, and Long.
  ///   * **double** for Double, and Float.
  Future<num?> executeAverageQuery({
    required String field,
    required AGConnectCloudDBQuery query,
    required AGConnectCloudDBZoneQueryPolicy policy,
  }) async {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    try {
      return await _methodChannel.invokeMethod<num?>(
        _MethodConstants.EXECUTE_AVERAGE_QUERY,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.FIELD: field,
          _KeyConstants.QUERY: query.query,
          _KeyConstants.POLICY_INDEX: policy.index,
        },
      );
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can call this method to search for Cloud DB zone objects that meet
  /// the specified conditions and return the sum of the data record values of the designated fields.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * This method is called to query the sum of the specified fields
  ///   only when Cloud DB zone is opened. Otherwise, the query will fail.
  /// * The startAt(), startAfter(), endAt(), and endBefore() methods cannot be used as query conditions.
  /// * Supports the following data types:
  ///   * **int** for Byte, Short, Integer, and Long.
  ///   * **double** for Double, and Float.
  Future<num?> executeSumQuery({
    required String field,
    required AGConnectCloudDBQuery query,
    required AGConnectCloudDBZoneQueryPolicy policy,
  }) async {
    if (field.isEmpty) {
      throw FormatException('Value of field cannot be an empty string.', field);
    }
    try {
      return await _methodChannel.invokeMethod<num?>(
        _MethodConstants.EXECUTE_SUM_QUERY,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.FIELD: field,
          _KeyConstants.QUERY: query.query,
          _KeyConstants.POLICY_INDEX: policy.index,
        },
      );
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can call this method to search for Cloud DB zone objects that meet
  /// the specified conditions and return the maximum value of the data record of the specified fields.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * This method is called to query the maximum value of the specified fields
  ///   only when Cloud DB zone is opened. Otherwise, the query will fail.
  /// * The startAt(), startAfter(), endAt(), and endBefore() methods cannot be used as query conditions.
  /// * Supports the following data types:
  ///   * **int** for Byte, Short, Integer, and Long.
  ///   * **double** for Double, and Float.
  Future<num?> executeMaximumQuery({
    required String field,
    required AGConnectCloudDBQuery query,
    required AGConnectCloudDBZoneQueryPolicy policy,
  }) async {
    if (field.isEmpty) {
      throw FormatException('Value of field cannot be an empty string.', field);
    }
    try {
      return await _methodChannel.invokeMethod<num?>(
        _MethodConstants.EXECUTE_MAXIMUM_QUERY,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.FIELD: field,
          _KeyConstants.QUERY: query.query,
          _KeyConstants.POLICY_INDEX: policy.index,
        },
      );
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can call this method to search for Cloud DB zone objects that meet
  /// the specified conditions and return the minimum value of the data record of the specified fields.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * This method is called to query the minimum value of the specified fields
  ///   only when Cloud DB zone is opened. Otherwise, the query will fail.
  /// * The startAt(), startAfter(), endAt(), and endBefore() methods cannot be used as query conditions.
  /// * Supports the following data types:
  ///   * **int** for Byte, Short, Integer, and Long.
  ///   * **double** for Double, and Float.
  Future<num?> executeMinimalQuery({
    required String field,
    required AGConnectCloudDBQuery query,
    required AGConnectCloudDBZoneQueryPolicy policy,
  }) async {
    if (field.isEmpty) {
      throw FormatException('Value of field cannot be an empty string.', field);
    }
    try {
      return await _methodChannel.invokeMethod<num?>(
        _MethodConstants.EXECUTE_MINIMAL_QUERY,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.FIELD: field,
          _KeyConstants.QUERY: query.query,
          _KeyConstants.POLICY_INDEX: policy.index,
        },
      );
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can call this method to search for Cloud DB zone objects that meet
  /// specified conditions and return the number of data records in a specified field.
  /// During statistics collection, if the value of this field is not empty, count 1. Otherwise, count 0.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * This method is called to query the number of the specified fields
  ///   only when Cloud DB zone is opened. Otherwise, the query will fail.
  /// * The startAt(), startAfter(), endAt(), and endBefore() methods cannot be used as query conditions.
  Future<int> executeCountQuery({
    required String field,
    required AGConnectCloudDBQuery query,
    required AGConnectCloudDBZoneQueryPolicy policy,
  }) async {
    if (field.isEmpty) {
      throw FormatException('field cannot be an empty string.', field);
    }
    try {
      final int? result = await _methodChannel.invokeMethod<int>(
        _MethodConstants.EXECUTE_COUNT_QUERY,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.FIELD: field,
          _KeyConstants.QUERY: query.query,
          _KeyConstants.POLICY_INDEX: policy.index,
        },
      );
      return result!;
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can call this method to query all Cloud DB objects that meet
  /// specified conditions but has not been synchronized to the cloud.
  /// The query result set contains the objects that are added or modified locally,
  /// but does not contain the deleted objects.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * You can call this method to query objects that are not synchronized to the cloud
  ///   only when Cloud DB zone is opened. Otherwise, the query will fail.
  /// * You can call this method to obtain objects that are not synchronized to the cloud
  ///   only when the data synchronization mode is cache mode.
  /// * The startAt(), startAfter(), endAt(), and endBefore() methods cannot be used as query conditions.
  Future<AGConnectCloudDBZoneSnapshot> executeQueryUnsynced({
    required AGConnectCloudDBQuery query,
  }) async {
    try {
      final Map<dynamic, dynamic>? result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        _MethodConstants.EXECUTE_QUERY_UNSYNCED,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.QUERY: query.query,
        },
      );
      return AGConnectCloudDBZoneSnapshot._fromMap(
          Map<String, dynamic>.from(result!));
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// Queries the current server status from Cloud DB zone, and encapsulates the queried server status into a ServerStatus object.
  /// Currently, the ServerStatus object contains the server timestamp.
  ///
  /// Comply with the following rules when calling this method:
  ///
  /// * The Cloud DB zone is opened.
  /// * The data synchronization attribute is set to cache.
  Future<AGCServerStatus> executeServerStatusQuery() async {
    try {
      final Map<dynamic, dynamic>? result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        _MethodConstants.EXECUTE_SERVER_STATUS_QUERY,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
        },
      );
      return AGCServerStatus._fromMap(Map<String, dynamic>.from(result!));
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// This method is called to perform a specified transaction operation.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * You can call this method to perform transaction operations
  ///   only when Cloud DB zone is opened. Otherwise, the transaction fails to be executed.
  /// * You can call this method to perform transaction operations
  ///   only when the Cloud DB zone synchronization mode is cache mode.
  /// * Multiple data operations can be performed in a transaction.
  /// * The written and deleted object records contained in a transaction
  ///   must be less than or equal to 1000. Otherwise, the transaction fails to be executed.
  Future<void> runTransaction({
    required AGConnectCloudDBTransaction transaction,
  }) async {
    try {
      return await _methodChannel.invokeMethod<void>(
        _MethodConstants.RUN_TRANSACTION,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.TRANSACTION_ELEMENTS: transaction.transactionElements,
        },
      );
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }

  /// You can call this method to register a listener for a specified object.
  ///
  /// When the object that is listened on is changed, the stream is triggered.
  /// After a snapshot listener is registered, the snapshot listener
  /// takes effect after a certain period of time (limited by network status).
  /// Therefore, a snapshot before the listener takes effect is not sent to the device.
  /// After the listener takes effect, the device can receive the snapshot.
  /// If the size of the snapshot exceeds 5 MB or the number of data records
  /// contained in the snapshot exceeds 1000, the snapshot cannot be sent to the device.
  ///
  /// **Comply with the following rules when invoking this method:**
  ///
  /// * You can call this method to register a listener only when Cloud DB zone is opened.
  ///   Otherwise, the listener fails to be registered.
  /// * You can call this method to register a listener only when
  ///   the Cloud DB zone synchronization mode is cache mode.
  /// * When registering a listener, equalTo() supports the following field data types:
  ///   * **bool** for Boolean.
  ///   * **int** for Byte, Short, Integer, Long, and Date.
  ///   * **double** for Double, and Float.
  ///   * **String** for String.
  ///
  ///
  /// **query**
  /// * Only the equal-value subscription, that is, the equalTo() method
  ///   can be used to construct query conditions.
  ///   The query conditions must contain at least one field and at most five fields.
  ///   The AND operation is used between multiple query conditions.
  ///
  /// **policy**
  /// * Query policy, which specifies the data source to be queried.
  ///   When a query policy is specified, the data source can only be
  ///   *POLICY_QUERY_FROM_CLOUD_ONLY* or *POLICY_QUERY_DEFAULT*.
  Future<Stream<AGConnectCloudDBZoneSnapshot?>> subscribeSnapshot({
    required AGConnectCloudDBQuery query,
    required AGConnectCloudDBZoneQueryPolicy policy,
  }) async {
    try {
      String channelId;
      do {
        channelId = '';
        for (int i = 0; i < 8; i++) {
          channelId += Random.secure().nextInt(10).toString();
        }
      } while (_activeSnapshotSubscriptionIds.contains(channelId));
      _activeSnapshotSubscriptionIds.add(channelId);

      final String eventChannelName =
          'com.huawei.agconnectclouddb/eventChannel/subscribeSnapshot/$channelId';
      final EventChannel eventChannel = EventChannel(eventChannelName);

      await _methodChannel.invokeMethod<void>(
        _MethodConstants.SUBSCRIBE_SNAPSHOT,
        <String, dynamic>{
          _KeyConstants.ZONE_ID: _id,
          _KeyConstants.QUERY: query.query,
          _KeyConstants.POLICY_INDEX: policy.index,
          _KeyConstants.EVENT_CHANNEL_NAME: eventChannelName,
        },
      );
      return eventChannel.receiveBroadcastStream().map((dynamic s) {
        return s is Map<dynamic, dynamic>
            ? AGConnectCloudDBZoneSnapshot._fromMap(
                Map<String, dynamic>.from(s))
            : null;
      });
    } catch (e) {
      throw AGConnectCloudDBException._from(e);
    }
  }
}
