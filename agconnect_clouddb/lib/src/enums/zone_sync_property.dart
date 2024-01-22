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

/// Synchronization property of the Cloud DB zone, which specifies
/// whether to synchronize data of Cloud DB zone between
/// the device and the cloud and the synchronization mode.
enum AGConnectCloudDBZoneSyncProperty {
  /// Local mode.
  ///
  /// Data is stored only on the device and is not synchronized to the cloud.
  CLOUDDBZONE_LOCAL_ONLY,

  /// Cache mode.
  ///
  /// Data is stored on the cloud, and data on the device is a subset of data on the cloud.
  /// If persistent cache is allowed, Cloud DB supports
  /// the automatic caching of query results on the device.
  /// After a listener is registered on the device to listen on the data on the cloud,
  /// the device is notified only when the data on the cloud changes.
  CLOUDDBZONE_CLOUD_CACHE,
}
