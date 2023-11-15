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

/// References to cloud files.
/// It encapsulates operations such as listing, uploading, downloading, and deleting files, and updating metadata.
class AGCStorageReference {
  /// AGCStorage instance to which the reference belongs.
  final AGCStorage storage;

  /// Name of a storage instance to which the reference belongs.
  /// If value is null, it means that default bucket is used.
  final String? bucket;

  /// Path to a file or directory on the cloud.
  final String path;

  /// Name of a file or directory on the cloud.
  final String name;

  AGCStorageReference._(this.storage, [String? path])
      : bucket = storage.bucket,
        path = (path == null || path.isEmpty)
            ? '/'
            : ((path = path.replaceAll(RegExp(r'//+'), '/')).startsWith('/')
                ? path
                : '/$path'),
        name = (path == null || path.isEmpty)
            ? ''
            : ((path = path.replaceAll(RegExp(r'//+'), '/')).startsWith('/')
                    ? path
                    : '/$path')
                .replaceAll(RegExp(r'/$'), '')
                .split('/')
                .last;

  /// Obtains the reference to the root directory.
  AGCStorageReference get root => AGCStorageReference._(storage);

  /// Obtains the reference to the parent directory.
  /// If the current directory is the root directory, null will return.
  AGCStorageReference? get parent => (this != root)
      ? AGCStorageReference._(
          storage,
          (path.replaceAll(RegExp(r'/$'), '').split('/')..removeLast())
                  .join('/') +
              '/')
      : null;

  /// Obtains the reference to a subdirectory.
  ///
  /// * path: Path to a subdirectory.
  AGCStorageReference child(String path) =>
      AGCStorageReference._(storage, '${this.path}/$path');

  /// Obtains metadata of a file or directory.
  Future<AGCStorageMetadata> getMetadata() async {
    try {
      final Map<dynamic, dynamic>? result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'AGCStorageReference#getMetadata',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
        },
      );
      return AGCStorageMetadata._(this, Map<String, dynamic>.from(result!));
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Updates file metadata in overwrite mode.
  Future<AGCStorageMetadata> updateMetadata(
      AGCStorageSettableMetadata metadata) async {
    try {
      final Map<dynamic, dynamic>? result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'AGCStorageReference#updateMetadata',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
          'metadata': metadata._toMap(),
        },
      );
      return AGCStorageMetadata._(this, Map<String, dynamic>.from(result!));
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Deletes a file from the cloud.
  Future<void> deleteFile() async {
    try {
      return await _methodChannel.invokeMethod<void>(
        'AGCStorageReference#deleteFile',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
        },
      );
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Uploads file to the cloud.
  /// You must set sha256 value to metadata for resumable uploads.
  ///
  /// * file: File size cannot exceed 50 GB.
  Future<AGCStorageUploadTask> uploadFile(
    File file, {
    AGCStorageSettableMetadata? metadata,
    int offset = 0,
  }) async {
    try {
      final String? taskId = await _methodChannel.invokeMethod<String?>(
        'AGCStorageReference#uploadFile',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
          'filePath': file.path,
          'metadata': metadata?._toMap(),
          'offset': offset,
        },
      );
      return AGCStorageUploadTask._(taskId!, this);
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Uploads data to the cloud.
  /// You must set sha256 value to metadata for resumable uploads.
  ///
  /// * data: Data size cannot exceed 5 GB.
  /// * offset: Resumable upload position of data.
  Future<AGCStorageUploadTask> uploadData(
    Uint8List data, {
    AGCStorageSettableMetadata? metadata,
    int offset = 0,
  }) async {
    try {
      final String? taskId = await _methodChannel.invokeMethod<String?>(
        'AGCStorageReference#uploadData',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
          'bytes': data,
          'metadata': metadata?._toMap(),
          'offset': offset,
        },
      );
      return AGCStorageUploadTask._(taskId!, this);
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Downloads a file from the cloud to a local path and specifies the file name.
  /// The file is managed by your app.
  /// When the local file is not 0 KB, the API uses the downloaded file size as the
  /// resumable download position to proceed with download from the cloud.
  ///
  /// * destinationFile: Destination file where a downloaded file will be stored, which must be created in advance.
  Future<AGCStorageDownloadTask> downloadToFile(File destinationFile) async {
    try {
      final String? taskId = await _methodChannel.invokeMethod<String?>(
        'AGCStorageReference#downloadToFile',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
          'filePath': destinationFile.path,
        },
      );
      return AGCStorageDownloadTask._(taskId!, this);
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Downloads specified data from the cloud to a Uint8List object.
  ///
  /// * maxSize: Maximum size of the data to be downloaded.
  Future<Uint8List?> downloadData([int maxSize = 10485760]) async {
    try {
      return await _methodChannel.invokeMethod<Uint8List?>(
        'AGCStorageReference#downloadData',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
          'maxSize': maxSize,
        },
      );
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the sharing URL of a cloud file.
  Future<String> getDownloadUrl() async {
    try {
      final String? result = await _methodChannel.invokeMethod<String?>(
        'AGCStorageReference#getDownloadUrl',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
        },
      );
      return result!;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the list of files and subdirectories with a specified number in a directory.
  ///
  /// * max: Total number of files and subdirectories to be obtained. Value of max ranges from 1 to 1000.
  /// * pageMarker: Pagination marker.
  Future<AGCStorageListResult> list(int max, [String? pageMarker]) async {
    try {
      final Map<dynamic, dynamic>? result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'AGCStorageReference#list',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
          'max': max,
          'pageMarker': pageMarker,
        },
      );
      return AGCStorageListResult._(
          storage, Map<String, dynamic>.from(result!));
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains all objects in a directory, including files and subdirectories.
  Future<AGCStorageListResult> listAll() async {
    try {
      final Map<dynamic, dynamic>? result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'AGCStorageReference#listAll',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
        },
      );
      return AGCStorageListResult._(
          storage, Map<String, dynamic>.from(result!));
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the ongoing upload task list under the current reference.
  Future<List<AGCStorageUploadTask>> getActiveUploadTasks() async {
    try {
      final List<dynamic>? result =
          await _methodChannel.invokeMethod<List<dynamic>?>(
        'AGCStorageReference#getActiveUploadTasks',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
        },
      );
      return (result ?? <String>[])
          .cast<String>()
          .map((String taskId) => AGCStorageUploadTask._(taskId, this))
          .toList(growable: false);
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Obtains the ongoing download task list under the current reference.
  Future<List<AGCStorageDownloadTask>> getActiveDownloadTasks() async {
    try {
      final List<dynamic>? result =
          await _methodChannel.invokeMethod<List<dynamic>?>(
        'AGCStorageReference#getActiveDownloadTasks',
        <String, dynamic>{
          'bucket': storage.bucket,
          'policyIndex': storage.policy?.index,
          'objectPath': path,
        },
      );
      return (result ?? <String>[])
          .cast<String>()
          .map((String taskId) => AGCStorageDownloadTask._(taskId, this))
          .toList(growable: false);
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  @override
  bool operator ==(Object other) =>
      other is AGCStorageReference &&
      other.storage == storage &&
      other.path == path;

  @override
  int get hashCode => Object.hash(storage, path);

  @override
  String toString() {
    return '$AGCStorageReference(storage: $storage, path: $path)';
  }
}
