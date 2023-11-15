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

enum _AGCStorageTaskState { success, progress, paused, canceled, failure }

abstract class AGCStorageTask<T extends AGCStorageTaskResult> {
  final String _type;
  final String _taskId;
  final AGCStorageReference _storageReference;
  final Stream<Map<String, dynamic>> _onEvent;
  Map<String, dynamic> _event = <String, dynamic>{};
  _AGCStorageTaskState _state = _AGCStorageTaskState.progress;

  /// Current result of the task. Not null when task state is progress, paused or success.
  T? get result;

  /// Task exception. Not null when task state is canceled or failure.
  AGCStorageException? exception;

  AGCStorageTask._(
    this._type,
    this._taskId,
    this._storageReference,
  ) : _onEvent = EventChannel(
                'com.huawei.agconnect.cloudstorage/eventChannel/task/' +
                    _taskId)
            .receiveBroadcastStream()
            .asBroadcastStream()
            .map((dynamic event) => Map<String, dynamic>.from(event)) {
    _onEvent.listen((Map<String, dynamic> event) {
      _event = event;
      _state = _AGCStorageTaskState.values
          .firstWhere((_AGCStorageTaskState taskState) {
        return event['taskState'] == describeEnum(taskState);
      });
      if (_state == _AGCStorageTaskState.failure) {
        exception = AGCStorageException._from(
          PlatformException(
            code: event['errorCode'] ?? 'UNKNOWN',
            message: event['errorMessage'],
            details: event['errorDetails'],
          ),
        );
      }
    });
  }

  /// Indicates whether a task is complete. Task success, failure or cancel are considered as completion.
  bool get isComplete =>
      _state == _AGCStorageTaskState.failure || isSuccessful || isCanceled;

  /// Indicates whether a task is successful.
  bool get isSuccessful => _state == _AGCStorageTaskState.success;

  /// Indicates whether a task is being executed.
  bool get isInProgress => _state == _AGCStorageTaskState.progress;

  /// Indicates whether a task is canceled.
  bool get isCanceled => _state == _AGCStorageTaskState.canceled;

  /// Indicates whether a task is suspended.
  bool get isPaused => _state == _AGCStorageTaskState.paused;

  Stream<void> onEvent() => _onEvent.cast<void>();

  /// Waits until whether a task is completed. Task success, failure or cancel are considered as completion.
  Future<void> whenComplete() async {
    final Future<Map<String, dynamic>> future =
        _onEvent.firstWhere((Map<String, dynamic> event) {
      return <String>[
        describeEnum(_AGCStorageTaskState.failure),
        describeEnum(_AGCStorageTaskState.success),
        describeEnum(_AGCStorageTaskState.canceled)
      ].contains(event['taskState']);
    });
    return Future.sync(() => future);
  }

  /// Suspends the current task.
  Future<bool> pause() async {
    try {
      final bool? result = await _methodChannel.invokeMethod<bool?>(
        'AGCStorageTask#$_type/pause',
        <String, dynamic>{
          'taskId': _taskId,
        },
      );
      return result ?? false;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Continues the current task.
  Future<bool> resume() async {
    try {
      final bool? result = await _methodChannel.invokeMethod<bool?>(
        'AGCStorageTask#$_type/resume',
        <String, dynamic>{
          'taskId': _taskId,
        },
      );
      return result ?? false;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }

  /// Cancels the current task.
  Future<bool> cancel() async {
    try {
      final bool? result = await _methodChannel.invokeMethod<bool?>(
        'AGCStorageTask#$_type/cancel',
        <String, dynamic>{
          'taskId': _taskId,
        },
      );
      return result ?? false;
    } catch (e) {
      throw AGCStorageException._from(e);
    }
  }
}

/// Manages upload tasks and encapsulates operations on storage tasks in various states.
class AGCStorageUploadTask extends AGCStorageTask<AGCStorageUploadResult> {
  AGCStorageUploadTask._(String taskId, AGCStorageReference storageReference)
      : super._('uploadTask', taskId, storageReference);

  @override
  AGCStorageUploadResult? get result {
    if (isInProgress || isPaused || isSuccessful) {
      return AGCStorageUploadResult._(_storageReference, _event);
    }
    return null;
  }
}

/// Manages download tasks and encapsulates operations on storage tasks in various states.
class AGCStorageDownloadTask extends AGCStorageTask<AGCStorageDownloadResult> {
  AGCStorageDownloadTask._(String taskId, AGCStorageReference storageReference)
      : super._('downloadTask', taskId, storageReference);

  @override
  AGCStorageDownloadResult? get result {
    if (isInProgress || isPaused || isSuccessful) {
      return AGCStorageDownloadResult._(_storageReference, _event);
    }
    return null;
  }
}
