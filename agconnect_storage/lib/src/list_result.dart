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

class AGCStorageListResult {
  /// References to all files in the list.
  final List<AGCStorageReference> fileList;

  /// References to all directories in the list.
  final List<AGCStorageReference> dirList;

  /// Pagination identifier for pagination query.
  final String? pageMarker;

  AGCStorageListResult._(AGCStorage storage, Map<String, dynamic> map)
      : fileList = List<String>.from(map['fileList'] ?? <String>[])
            .map((String path) => AGCStorageReference._(storage, path))
            .toList(growable: false),
        dirList = List<String>.from(map['dirList'] ?? <String>[])
            .map((String path) => AGCStorageReference._(storage, path))
            .toList(growable: false),
        pageMarker = map['pageMarker'];

  @override
  String toString() {
    return '$AGCStorageListResult(fileList: $fileList, dirList: $dirList, pageMarker: $pageMarker)';
  }
}
