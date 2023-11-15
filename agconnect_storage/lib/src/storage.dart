/*
 * Copyright 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

part of agconnect_cloudstorage;

enum AGCStorageRoutePolicy { china, germany, russia, singapore }

/// Management class provided for apps to support file upload and download.
class AGCStorage {
  /// If value is null, it means that default bucket is used.
  final String? bucket;

  /// If policy is null, it means that default region is used.
  final AGCStorageRoutePolicy? policy;

  AGCStorage.getInstance([String? bucket, this.policy])
      : bucket = bucket?.toLowerCase();

  /// Creates a reference to a file or directory in the specified file path.
  ///
  /// The value can contain up to 1024 characters.
  AGCStorageReference reference([String? path]) =>
      AGCStorageReference._(this, path);

  /// Creates a reference to a file or directory in the specified path on the cloud.
  Future<AGCStorageReference> referenceFromUrl(String url) async {
    try {
      final String? result = await _methodChannel.invokeMethod<String?>(
        'AGCStorage#referenceFromUrl',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
          'url': url,
        },
      );
      return AGCStorageReference._(this, result);
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the current storage location.
  ///
  /// Only supported on Android.
  Future<String> getArea() async {
    try {
      final String? result = await _methodChannel.invokeMethod<String?>(
        'AGCStorage#getArea',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
        },
      );
      return result!;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Sets the maximum number of retries.
  Future<void> setRetryTimes([int retryTimes = 3]) async {
    try {
      assert(retryTimes > 0);
      return await _methodChannel.invokeMethod<void>(
        'AGCStorage#setRetryTimes',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
          'retryTimes': retryTimes,
        },
      );
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the maximum number of retries.
  Future<int> getRetryTimes() async {
    try {
      final int? result = await _methodChannel.invokeMethod<int?>(
        'AGCStorage#getRetryTimes',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
        },
      );
      return result!;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Sets the maximum request timeout interval.
  Future<void> setMaxRequestTimeout([int maxRequestTimeout = 20]) async {
    try {
      assert(maxRequestTimeout > 0);
      return await _methodChannel.invokeMethod<void>(
        'AGCStorage#setMaxRequestTimeout',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
          'maxRequestTimeout': maxRequestTimeout,
        },
      );
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the maximum request timeout interval.
  Future<int> getMaxRequestTimeout() async {
    try {
      final int? result = await _methodChannel.invokeMethod<int?>(
        'AGCStorage#getMaxRequestTimeout',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
        },
      );
      return result! ~/ 1000;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Sets the maximum upload timeout interval.
  ///
  /// It takes longer for a large uploaded file to be verified.
  /// Set this parameter to a proper value based on the sizes of uploaded files.
  Future<void> setMaxUploadTimeout([int maxUploadTimeout = 120]) async {
    try {
      assert(maxUploadTimeout > 0);
      return await _methodChannel.invokeMethod<void>(
        'AGCStorage#setMaxUploadTimeout',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
          'maxUploadTimeout': maxUploadTimeout,
        },
      );
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the maximum upload timeout interval.
  Future<int> getMaxUploadTimeout() async {
    try {
      final int? result = await _methodChannel.invokeMethod<int?>(
        'AGCStorage#getMaxUploadTimeout',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
        },
      );
      return result! ~/ 1000;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Sets the maximum download timeout interval.
  Future<void> setMaxDownloadTimeout([int maxDownloadTimeout = 60]) async {
    try {
      assert(maxDownloadTimeout > 0);
      return await _methodChannel.invokeMethod<void>(
        'AGCStorage#setMaxDownloadTimeout',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
          'maxDownloadTimeout': maxDownloadTimeout,
        },
      );
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the maximum download timeout interval.
  Future<int> getMaxDownloadTimeout() async {
    try {
      final int? result = await _methodChannel.invokeMethod<int?>(
        'AGCStorage#getMaxDownloadTimeout',
        <String, dynamic>{
          'bucket': bucket,
          'policyIndex': policy?.index,
        },
      );
      return result! ~/ 1000;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  @override
  String toString() {
    return '$AGCStorage(bucket: $bucket, policy: $policy)';
  }
}
