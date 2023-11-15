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

abstract class AGCStorageTaskResult {
  /// AGCStorageReference instance corresponding to the task.
  final AGCStorageReference storageReference;

  /// Number of transferred bytes.
  final int bytesTransferred;

  /// Total number of bytes.
  final int totalByteCount;

  AGCStorageTaskResult._(this.storageReference, Map<String, dynamic> result)
      : bytesTransferred = result['bytesTransferred'] ?? 0,
        totalByteCount = result['totalByteCount'] ?? 1;
}

/// Result of an upload task.
class AGCStorageUploadResult extends AGCStorageTaskResult {
  /// Metadata of an uploaded file.
  final AGCStorageMetadata? metadata;

  AGCStorageUploadResult._(
      AGCStorageReference storageReference, Map<String, dynamic> result)
      : metadata = Map<String, dynamic>.from(result['metadata']).isNotEmpty
            ? AGCStorageMetadata._(
                storageReference, Map<String, dynamic>.from(result['metadata']))
            : null,
        super._(storageReference, result);

  @override
  String toString() {
    return '$AGCStorageUploadResult(bytesTransferred: $bytesTransferred, totalByteCount: $totalByteCount, metadata: $metadata)';
  }
}

/// Result of a download task.
class AGCStorageDownloadResult extends AGCStorageTaskResult {
  AGCStorageDownloadResult._(
      AGCStorageReference storageReference, Map<String, dynamic> result)
      : super._(storageReference, result);

  @override
  String toString() {
    return '$AGCStorageDownloadResult(bytesTransferred: $bytesTransferred, totalByteCount: $totalByteCount)';
  }
}
