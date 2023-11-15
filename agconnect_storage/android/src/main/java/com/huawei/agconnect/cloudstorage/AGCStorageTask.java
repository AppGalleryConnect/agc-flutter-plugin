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

package com.huawei.agconnect.cloudstorage;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.huawei.agconnect.cloud.storage.core.DownloadTask;
import com.huawei.agconnect.cloud.storage.core.UploadTask;

import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class AGCStorageTask {
    private static volatile AGCStorageTask instance;
    public final Map<String, UploadTask> uploadTasks = new HashMap<>();
    public final Map<String, DownloadTask> downloadTasks = new HashMap<>();

    public static AGCStorageTask getInstance() {
        if (instance == null) {
            instance = new AGCStorageTask();
        }
        return instance;
    }

    public void innerMethodHandler(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final String taskId = Objects.requireNonNull(call.argument("taskId"));
            switch (call.method.split("#")[1]) {
                case "uploadTask/pause": {
                    result.success(Objects.requireNonNull(uploadTasks.get(taskId)).pause());
                    break;
                }
                case "uploadTask/resume": {
                    result.success(Objects.requireNonNull(uploadTasks.get(taskId)).resume());
                    break;
                }
                case "uploadTask/cancel": {
                    result.success(Objects.requireNonNull(uploadTasks.get(taskId)).cancel());
                    break;
                }
                case "downloadTask/pause": {
                    result.success(Objects.requireNonNull(downloadTasks.get(taskId)).pause());
                    break;
                }
                case "downloadTask/resume": {
                    result.success(Objects.requireNonNull(downloadTasks.get(taskId)).resume());
                    break;
                }
                case "downloadTask/cancel": {
                    result.success(Objects.requireNonNull(downloadTasks.get(taskId)).cancel());
                    break;
                }
                default: {
                    result.notImplemented();
                }
            }
        } catch (RuntimeException storageTaskInnerHandlerException) {
            throw AGCStorageException.from(storageTaskInnerHandlerException);
        }
    }


    public String getUniqueUploadTaskId() {
        while (true) {
            final String taskId = String.valueOf(new SecureRandom().nextInt(1000000));
            if (!uploadTasks.containsKey(taskId)) {
                uploadTasks.put(taskId, null);
                return taskId;
            }
        }
    }

    public String getUniqueDownloadTaskId() {
        while (true) {
            final String taskId = String.valueOf(new SecureRandom().nextInt(1000000));
            if (!downloadTasks.containsKey(taskId)) {
                downloadTasks.put(taskId, null);
                return taskId;
            }
        }
    }

    private void listenUploadTask(@NonNull EventChannel.EventSink eventSink, @NonNull String taskId, @NonNull UploadTask uploadTask) {
        uploadTasks.put(taskId, uploadTask);
        uploadTask.addOnSuccessListener(uploadResult -> eventSink.success(uploadResultToMap("success", uploadResult, null)))
                .addOnProgressListener(uploadResult -> eventSink.success(uploadResultToMap("progress", uploadResult, null)))
                .addOnPausedListener(uploadResult -> eventSink.success(uploadResultToMap("paused", uploadResult, null)))
                .addOnCanceledListener(() -> eventSink.success(uploadResultToMap("canceled", null, null)))
                .addOnFailureListener((e) -> eventSink.success(uploadResultToMap("failure", null, e)));
    }

    private void listenDownloadTask(@NonNull EventChannel.EventSink eventSink, @NonNull String taskId, @NonNull DownloadTask downloadTask) {
        downloadTasks.put(taskId, downloadTask);
        downloadTask.addOnSuccessListener(downloadResult -> eventSink.success(downloadResultToMap("success", downloadResult, null)))
                .addOnProgressListener(downloadResult -> eventSink.success(downloadResultToMap("progress", downloadResult, null)))
                .addOnPausedListener(downloadResult -> eventSink.success(downloadResultToMap("paused", downloadResult, null)))
                .addOnCanceledListener(() -> eventSink.success(downloadResultToMap("canceled", null, null)))
                .addOnFailureListener((e) -> eventSink.success(downloadResultToMap("failure", null, e)));
    }

    private Map<String, Object> uploadResultToMap(@NonNull String taskState, @Nullable UploadTask.UploadResult uploadResult, @Nullable Exception e) {
        final Map<String, Object> map = new HashMap<>();
        map.put("taskState", taskState);
        if (e != null) {
            final AGCStorageException exception = AGCStorageException.from(e);
            map.put("errorCode", exception.getErrorCode());
            map.put("errorMessage", exception.getErrorMessage());
            map.put("errorDetails", exception.getErrorDetails());
        } else if (uploadResult != null) {
            map.put("metadata", AGCStorageUtil.fileMetadataToMap(uploadResult.getMetadata()));
            map.put("bytesTransferred", uploadResult.getBytesTransferred());
            map.put("totalByteCount", uploadResult.getTotalByteCount());
        }
        return map;
    }

    private Map<String, Object> downloadResultToMap(@NonNull String taskState, @Nullable DownloadTask.DownloadResult downloadResult, @Nullable Exception e) {
        final Map<String, Object> map = new HashMap<>();
        map.put("taskState", taskState);
        if (e != null) {
            final AGCStorageException exception = AGCStorageException.from(e);
            map.put("errorCode", exception.getErrorCode());
            map.put("errorMessage", exception.getErrorMessage());
            map.put("errorDetails", exception.getErrorDetails());
        } else if (downloadResult != null) {
            map.put("bytesTransferred", downloadResult.getBytesTransferred());
            map.put("totalByteCount", downloadResult.getTotalByteCount());
        }
        return map;
    }

    static class AGCStorageUploadTaskStreamHandler implements EventChannel.StreamHandler {
        final String taskId;
        final UploadTask uploadTask;

        AGCStorageUploadTaskStreamHandler(String taskId, UploadTask uploadTask) {
            this.taskId = taskId;
            this.uploadTask = uploadTask;
        }

        @Override
        public void onListen(Object arguments, EventChannel.EventSink eventSink) {
            AGCStorageTask.getInstance().listenUploadTask(eventSink, taskId, uploadTask);
        }

        @Override
        public void onCancel(Object arguments) {
        }
    }

    static class AGCStorageDownloadTaskStreamHandler implements EventChannel.StreamHandler {
        final String taskId;
        final DownloadTask downloadTask;

        AGCStorageDownloadTaskStreamHandler(String taskId, DownloadTask downloadTask) {
            this.taskId = taskId;
            this.downloadTask = downloadTask;
        }

        @Override
        public void onListen(Object arguments, EventChannel.EventSink eventSink) {
            AGCStorageTask.getInstance().listenDownloadTask(eventSink, taskId, downloadTask);
        }

        @Override
        public void onCancel(Object arguments) {
        }
    }
}
