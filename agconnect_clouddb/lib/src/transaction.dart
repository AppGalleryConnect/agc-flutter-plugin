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

/// Transaction class describes a transaction.
/// The transaction provides **executeUpsert()**, and **executeDelete()**
/// methods to add, delete, and modify, data in the Cloud DB zone on the cloud.
///
/// * A transaction is performed only when the network is connected.
/// * Multiple data operations can be performed in a transaction.
/// * The written and deleted object records contained in a transaction
///   must be less than or equal to 1000. The data size of multiple
///   write and delete operations in a transaction must be less than or equal to 2 MB.
class AGConnectCloudDBTransaction {
  final List<Map<String, dynamic>> _transactionElements =
      <Map<String, dynamic>>[];

  List<Map<String, dynamic>> get transactionElements => _transactionElements;

  /// This method is used to write a group of objects in a transaction
  /// to the Cloud DB zone on the cloud in batches. A transaction is atomic.
  /// All operations in a transaction will either be successful or fail.
  ///
  /// **Comply with the following rules when calling this method:**
  ///
  /// * The write operation in a transaction must be performed after the query operation.
  /// * This method can be called to write data only when the network is properly connected.
  /// * The synchronization property of Cloud DB zone is cache mode.
  /// * The data size of multiple write and delete operations in a transaction
  ///   must be less than or equal to 2 MB. Otherwise, the transaction fails.
  void executeUpsert({
    required String objectTypeName,
    required List<Map<String, dynamic>> entries,
  }) {
    if (objectTypeName.isEmpty) {
      throw FormatException(
          'objectTypeName cannot be an empty string.', objectTypeName);
    }
    if (entries.isEmpty) {
      throw FormatException('entries cannot be an empty list.', entries);
    }
    _transactionElements.add(
      <String, dynamic>{
        _TransactionConstants.OPERATION: _TransactionConstants.EXECUTE_UPSERT,
        _TransactionConstants.ZONE_OBJECT_TYPE_NAME: objectTypeName,
        _TransactionConstants.ZONE_OBJECT_DATA_ENTRIES: entries,
      },
    );
  }

  /// This method is called to delete a group of objects from a Cloud DB zone
  /// on the cloud in a transaction in batches. A transaction is atomic.
  /// All operations in a transaction will either be successful or fail.
  /// The delete operation focuses only on whether the primary key of the object is consistent,
  /// regardless of whether other attributes of the object match the stored data.
  ///
  /// **Comply with the following rules when calling this method:**
  ///
  /// * This method can be called to delete data only when the network is properly connected.
  /// * The synchronization property of Cloud DB zone is cache mode.
  /// * The data size of multiple write and delete operations in a transaction
  ///   must be less than or equal to 2 MB. Otherwise, the transaction fails.
  void executeDelete({
    required String objectTypeName,
    required List<Map<String, dynamic>> entries,
  }) {
    if (objectTypeName.isEmpty) {
      throw FormatException(
          'objectTypeName cannot be an empty string.', objectTypeName);
    }
    if (entries.isEmpty) {
      throw FormatException('entries cannot be an empty list.', entries);
    }
    _transactionElements.add(
      <String, dynamic>{
        _TransactionConstants.OPERATION: _TransactionConstants.EXECUTE_DELETE,
        _TransactionConstants.ZONE_OBJECT_TYPE_NAME: objectTypeName,
        _TransactionConstants.ZONE_OBJECT_DATA_ENTRIES: entries,
      },
    );
  }
}
