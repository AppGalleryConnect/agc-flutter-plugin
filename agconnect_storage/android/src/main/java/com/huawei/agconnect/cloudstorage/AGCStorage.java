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

import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.cloud.storage.core.AGCStorageManagement;
import com.huawei.agconnect.cloud.storage.core.StorageReference;

import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGCStorage {
    private static volatile AGCStorage instance;
    private final FlutterPluginBinding flutterPluginBinding;

    private AGCStorage(FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    public static AGCStorage getInstance(@NonNull FlutterPluginBinding flutterPluginBinding) {
        if (instance == null) {
            instance = new AGCStorage(flutterPluginBinding);
        }
        return instance;
    }

    public void innerMethodHandler(@NonNull MethodCall call, @NonNull Result result) throws AGCStorageException {
        try {
            final AGCStorageManagement storage = AGCStorageUtil.getAGCStorageManagement(
                    flutterPluginBinding.getApplicationContext(),
                    call.argument("bucket"),
                    call.argument("policyIndex"));

            switch (call.method.split("#")[1]) {
                case "referenceFromUrl": {
                    final AGConnectInstance agConnectInstance = AGCStorageUtil.getAGCInstance(flutterPluginBinding.getApplicationContext(), storage.getArea());
                    final StorageReference reference = storage.getReferenceFromUrl(agConnectInstance, Objects.requireNonNull(call.argument("url")));
                    result.success(reference.getPath());
                    break;
                }
                case "getArea": {
                    result.success(storage.getArea());
                    break;
                }
                case "setRetryTimes": {
                    storage.setRetryTimes(Objects.requireNonNull(call.argument("retryTimes")));
                    result.success(true);
                    break;
                }
                case "getRetryTimes": {
                    result.success(storage.getRetryTimes());
                    break;
                }
                case "setMaxRequestTimeout": {
                    storage.setMaxRequestTimeout(Long.parseLong(Objects.requireNonNull(call.argument("maxRequestTimeout")).toString()));
                    result.success(true);
                    break;
                }
                case "getMaxRequestTimeout": {
                    result.success(storage.getMaxRequestTimeout());
                    break;
                }
                case "setMaxUploadTimeout": {
                    storage.setMaxUploadTimeout(Long.parseLong(Objects.requireNonNull(call.argument("maxUploadTimeout")).toString()));
                    result.success(true);
                    break;
                }
                case "getMaxUploadTimeout": {
                    result.success(storage.getMaxUploadTimeout());
                    break;
                }
                case "setMaxDownloadTimeout": {
                    storage.setMaxDownloadTimeout(Long.parseLong(Objects.requireNonNull(call.argument("maxDownloadTimeout")).toString()));
                    result.success(true);
                    break;
                }
                case "getMaxDownloadTimeout": {
                    result.success(storage.getMaxDownloadTimeout());
                    break;
                }
                default: {
                    result.notImplemented();
                }
            }
        } catch (RuntimeException storageInnerHandlerException) {
            throw AGCStorageException.from(storageInnerHandlerException);
        }
    }
}
