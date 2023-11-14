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

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class AGCStoragePlugin implements FlutterPlugin, ActivityAware {
    private FlutterPluginBinding flutterPluginBinding;
    private MethodChannel methodChannel;
    private MethodCallHandler methodCallHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
        if (flutterPluginBinding != null) {
            if (AGConnectInstance.getInstance() == null) {
                AGConnectInstance.initialize(activityPluginBinding.getActivity().getApplicationContext());
            }
            this.methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), AGCStorageConstants.METHOD_CHANNEL);
            this.methodCallHandler = new AGCStorageMethodHandler(flutterPluginBinding);
            this.methodChannel.setMethodCallHandler(methodCallHandler);
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        if (this.methodChannel != null) {
            this.methodChannel.setMethodCallHandler(null);
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = null;
        this.methodChannel = null;
        this.methodCallHandler = null;
    }
}
