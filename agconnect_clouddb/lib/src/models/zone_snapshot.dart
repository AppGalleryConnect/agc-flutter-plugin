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

class AGConnectCloudDBZoneSnapshot {
  /// Specifies whether the object in the snapshot is obtained from the Cloud DB zone on the cloud.
  ///
  /// **true**: The object is obtained from the Cloud DB zone on the cloud.
  ///
  /// **false**: The object is obtained from the Cloud DB zone on the device.
  final bool isFromCloud;

  /// Determines whether the snapshot contains objects that have not been synchronized to the cloud.
  ///
  /// **true**: There are objects that have not been synchronized to the cloud.
  ///
  /// **false**: All objects have been synchronized to the cloud.
  final bool hasPendingWrites;

  /// This list contains **all** objects from a snapshot.
  final List<Map<String, dynamic>> snapshotObjects;

  /// This list contains **added** or **modified** objects (compared with the previous snapshot)
  /// in a snaphot only after the developer registers a snapshot listener.
  ///
  /// Otherwise, value of this is empty list.
  final List<Map<String, dynamic>> upsertedObjects;

  /// This list contains **newly deleted** objects (compared with the previous snapshot)
  /// from a snapshot only after the developer registers a snapshot listener.
  ///
  /// Otherwise, value of this is empty list.
  final List<Map<String, dynamic>> deletedObjects;

  AGConnectCloudDBZoneSnapshot._fromMap(Map<String, dynamic> map)
      : isFromCloud = map['isFromCloud'],
        hasPendingWrites = map['hasPendingWrites'],
        snapshotObjects = map['snapshotObjects'] == null
            ? const <Map<String, dynamic>>[]
            : (map['snapshotObjects'] as List<dynamic>).map((dynamic i) {
                return Map<String, dynamic>.from(i as Map<dynamic, dynamic>);
              }).toList(),
        upsertedObjects = map['upsertedObjects'] == null
            ? const <Map<String, dynamic>>[]
            : (map['upsertedObjects'] as List<dynamic>).map((dynamic i) {
                return Map<String, dynamic>.from(i as Map<dynamic, dynamic>);
              }).toList(),
        deletedObjects = map['deletedObjects'] == null
            ? const <Map<String, dynamic>>[]
            : (map['deletedObjects'] as List<dynamic>).map((dynamic i) {
                return Map<String, dynamic>.from(i as Map<dynamic, dynamic>);
              }).toList();

  @override
  String toString() {
    return '$AGConnectCloudDBZoneSnapshot('
        'isFromCloud: $isFromCloud, '
        'hasPendingWrites: $hasPendingWrites, '
        'snapshotObjects: $snapshotObjects, '
        'upsertedObjects: $upsertedObjects, '
        'deletedObjects: $deletedObjects)';
  }
}
