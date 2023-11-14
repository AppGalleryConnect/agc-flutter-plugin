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

import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGCStorageMethodHandler implements MethodCallHandler {
    private final FlutterPluginBinding flutterPluginBinding;

    public AGCStorageMethodHandler(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            if (call.method.startsWith("AGCStorage#")) {
                AGCStorage.getInstance(flutterPluginBinding).innerMethodHandler(call, result);
            } else if (call.method.startsWith("AGCStorageReference#")) {
                AGCStorageReference.getInstance(flutterPluginBinding).innerMethodHandler(call, result);
            } else if (call.method.startsWith("AGCStorageTask#")) {
                AGCStorageTask.getInstance().innerMethodHandler(call, result);
            } else {
                result.notImplemented();
            }
        } catch (RuntimeException | AGCStorageException e) {
            final AGCStorageException exception = AGCStorageException.from(e);
            result.error(exception.getErrorCode(), exception.getErrorMessage(), exception.getErrorDetails());
        }
    }
}
