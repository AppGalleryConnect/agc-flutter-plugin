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

/// Query policy, which specifies the data source to be queried.
enum AGConnectCloudDBZoneQueryPolicy {
  /// Data is queried from local cache.
  POLICY_QUERY_FROM_LOCAL_ONLY,

  /// Data is queried from Cloud DB zone on the cloud.
  POLICY_QUERY_FROM_CLOUD_ONLY,

  /// Data is queried from both Cloud DB zone on the cloud and local cache.
  ///
  /// * When a device is offline, data is queried from local cache.
  /// * When a device is online, data is queried from both Cloud DB zone on the cloud and local cache.
  POLICY_QUERY_DEFAULT,
}
