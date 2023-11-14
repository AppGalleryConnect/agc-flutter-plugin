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

import com.huawei.agconnect.cloud.storage.core.AGCStorageManagement;
import com.huawei.agconnect.cloud.storage.core.DownloadTask;
import com.huawei.agconnect.cloud.storage.core.ListResult;
import com.huawei.agconnect.cloud.storage.core.StorageReference;
import com.huawei.agconnect.cloud.storage.core.UploadTask;
import com.huawei.hmf.tasks.Task;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class AGCStorageReference {
    private static volatile AGCStorageReference instance;
    private final FlutterPluginBinding flutterPluginBinding;

    private AGCStorageReference(FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    public static AGCStorageReference getInstance(@NonNull FlutterPluginBinding flutterPluginBinding) {
        if (instance == null) {
            instance = new AGCStorageReference(flutterPluginBinding);
        }
        return instance;
    }

    public void innerMethodHandler(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            switch (call.method.split("#")[1]) {
                case "getMetadata": {
                    getMetadata(call, result);
                    break;
                }
                case "updateMetadata": {
                    updateMetadata(call, result);
                    break;
                }
                case "deleteFile": {
                    deleteFile(call, result);
                    break;
                }
                case "getDownloadUrl": {
                    getDownloadUrl(call, result);
                    break;
                }
                case "list": {
                    list(call, result);
                    break;
                }
                case "listAll": {
                    listAll(call, result);
                    break;
                }
                case "uploadFile": {
                    uploadFile(call, result);
                    break;
                }
                case "uploadData": {
                    uploadData(call, result);
                    break;
                }
                case "downloadToFile": {
                    downloadToFile(call, result);
                    break;
                }
                case "downloadData": {
                    downloadData(call, result);
                    break;
                }
                case "getActiveUploadTasks": {
                    getActiveUploadTasks(call, result);
                    break;
                }
                case "getActiveDownloadTasks": {
                    getActiveDownloadTasks(call, result);
                    break;
                }
                default: {
                    result.notImplemented();
                }
            }
        } catch (RuntimeException storageReferenceInnerHandlerException) {
            throw AGCStorageException.from(storageReferenceInnerHandlerException);
        }
    }

    private void getMetadata(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            getStorageReferenceFromCall(call).getFileMetadata()
                    .addOnSuccessListener(fileMetadata -> returnSuccess(result, AGCStorageUtil.fileMetadataToMap(fileMetadata)))
                    .addOnFailureListener(e -> returnError(result, e));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void updateMetadata(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final Map<String, Object> metadataMap = Objects.requireNonNull(call.argument("metadata"));

            getStorageReferenceFromCall(call).updateFileMetadata(AGCStorageUtil.fileMetadataFromMap(metadataMap))
                    .addOnSuccessListener(fileMetadata -> returnSuccess(result, AGCStorageUtil.fileMetadataToMap(fileMetadata)))
                    .addOnFailureListener(e -> returnError(result, e));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void deleteFile(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            getStorageReferenceFromCall(call).delete()
                    .addOnSuccessListener(unused -> returnSuccess(result, true))
                    .addOnFailureListener(e -> returnError(result, e));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void getDownloadUrl(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            getStorageReferenceFromCall(call).getDownloadUrl()
                    .addOnSuccessListener(uri -> returnSuccess(result, uri == null ? null : uri.toString()))
                    .addOnFailureListener(e -> returnError(result, e));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void list(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final int max = Objects.requireNonNull(call.argument("max"));
            final String pageMarker = call.argument("pageMarker");

            final Task<ListResult> task = pageMarker == null ?
                    getStorageReferenceFromCall(call).list(max) :
                    getStorageReferenceFromCall(call).list(max, pageMarker);

            task.addOnSuccessListener(listResult -> returnSuccess(result, AGCStorageUtil.listResultToMap(listResult)))
                    .addOnFailureListener(e -> returnError(result, e));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void listAll(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            getStorageReferenceFromCall(call).listAll()
                    .addOnSuccessListener(listResult -> returnSuccess(result, AGCStorageUtil.listResultToMap(listResult)))
                    .addOnFailureListener(e -> returnError(result, e));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void uploadFile(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final File file = new File((String) Objects.requireNonNull(call.argument("filePath")));
            final long offset = Long.parseLong(Objects.requireNonNull(call.argument("offset")).toString());

            final UploadTask uploadTask = getStorageReferenceFromCall(call).putFile(
                    file,
                    AGCStorageUtil.fileMetadataFromMap(call.argument("metadata")),
                    offset);

            final String taskId = AGCStorageTask.getInstance().getUniqueUploadTaskId();
            final EventChannel uploadFileEventChannel = new EventChannel(
                    flutterPluginBinding.getBinaryMessenger(),
                    AGCStorageConstants.TASK_EVENT_CHANNEL_PREFIX + taskId);

            returnSuccess(result, taskId);
            uploadFileEventChannel.setStreamHandler(new AGCStorageTask.AGCStorageUploadTaskStreamHandler(taskId, uploadTask));
        } catch (Exception uploadFileException) {
            throw AGCStorageException.from(uploadFileException);
        }
    }

    private void uploadData(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final byte[] bytes = Objects.requireNonNull(call.argument("bytes"));
            final long offset = Long.parseLong(Objects.requireNonNull(call.argument("offset")).toString());

            final UploadTask uploadTask = getStorageReferenceFromCall(call).putBytes(
                    bytes,
                    AGCStorageUtil.fileMetadataFromMap(call.argument("metadata")),
                    offset);

            final String taskId = AGCStorageTask.getInstance().getUniqueUploadTaskId();
            final EventChannel uploadDataEventChannel = new EventChannel(
                    flutterPluginBinding.getBinaryMessenger(),
                    AGCStorageConstants.TASK_EVENT_CHANNEL_PREFIX + taskId);

            returnSuccess(result, taskId);
            uploadDataEventChannel.setStreamHandler(new AGCStorageTask.AGCStorageUploadTaskStreamHandler(taskId, uploadTask));
        } catch (Exception uploadDataException) {
            throw AGCStorageException.from(uploadDataException);
        }
    }

    private void downloadToFile(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final String filePath = Objects.requireNonNull(call.argument("filePath"));

            final DownloadTask downloadTask = getStorageReferenceFromCall(call).getFile(new File(filePath));

            final String taskId = AGCStorageTask.getInstance().getUniqueDownloadTaskId();
            final EventChannel downloadToFileEventChannel = new EventChannel(
                    flutterPluginBinding.getBinaryMessenger(),
                    AGCStorageConstants.TASK_EVENT_CHANNEL_PREFIX + taskId);

            returnSuccess(result, taskId);
            downloadToFileEventChannel.setStreamHandler(new AGCStorageTask.AGCStorageDownloadTaskStreamHandler(taskId, downloadTask));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void downloadData(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final long maxSize = Long.parseLong(Objects.requireNonNull(call.argument("maxSize")).toString());
            getStorageReferenceFromCall(call).getBytes(maxSize)
                    .addOnSuccessListener(bytes -> returnSuccess(result, bytes))
                    .addOnFailureListener(e -> returnError(result, e));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void getActiveUploadTasks(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final List<UploadTask> uploadTaskList = getStorageReferenceFromCall(call).getActiveUploadTasks();

            final List<String> uploadTaskIds = new ArrayList<>();
            for (Map.Entry<String, UploadTask> entry : AGCStorageTask.getInstance().uploadTasks.entrySet()) {
                if (uploadTaskList.contains(entry.getValue())) {
                    uploadTaskIds.add(entry.getKey());
                }
            }
            returnSuccess(result, uploadTaskIds);
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void getActiveDownloadTasks(@NonNull MethodCall call, @NonNull MethodChannel.Result result) throws AGCStorageException {
        try {
            final List<DownloadTask> downloadTaskList = getStorageReferenceFromCall(call).getActiveDownloadTasks();

            final List<String> downloadTaskIds = new ArrayList<>();
            for (Map.Entry<String, DownloadTask> entry : AGCStorageTask.getInstance().downloadTasks.entrySet()) {
                if (downloadTaskList.contains(entry.getValue())) {
                    downloadTaskIds.add(entry.getKey());
                }
            }
            returnSuccess(result, downloadTaskIds);
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    private void returnSuccess(@NonNull MethodChannel.Result result, @Nullable Object data) {
        result.success(data);
    }

    private void returnError(@NonNull MethodChannel.Result result, @NonNull Exception e) {
        final AGCStorageException exception = AGCStorageException.from(e);
        result.error(exception.getErrorCode(), exception.getErrorMessage(), exception.getErrorDetails());
    }

    private StorageReference getStorageReferenceFromCall(@NonNull MethodCall call) throws AGCStorageException {
        try {
            final AGCStorageManagement storage = AGCStorageUtil.getAGCStorageManagement(
                    flutterPluginBinding.getApplicationContext(),
                    call.argument("bucket"),
                    call.argument("policyIndex"));

            final String objectPath = call.argument("objectPath");
            return objectPath == null
                    ? storage.getStorageReference()
                    : storage.getStorageReference(objectPath);
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }
}
