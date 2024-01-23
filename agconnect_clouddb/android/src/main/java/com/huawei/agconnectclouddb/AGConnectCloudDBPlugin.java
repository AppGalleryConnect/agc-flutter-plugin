/*
 * Copyright (c) 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

package com.huawei.agconnectclouddb;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.cloud.database.AGConnectCloudDB;
import com.huawei.agconnectclouddb.constants.ChannelConstants;
import com.huawei.agconnectclouddb.handlers.MethodHandler;
import com.huawei.agconnectclouddb.handlers.OnDataEncryptionKeyChangeStreamHandler;
import com.huawei.agconnectclouddb.handlers.OnEventStreamHandler;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class AGConnectCloudDBPlugin implements FlutterPlugin, ActivityAware {
    private FlutterPluginBinding flutterPluginBinding;
    private MethodChannel methodChannel;
    private EventChannel onDataEncryptionKeyChangeEventChannel;
    private EventChannel onEventEventChannel;
    private MethodCallHandler methodCallHandler;
    private StreamHandler onDataEncryptionKeyChangeStreamHandler;
    private StreamHandler onEventStreamHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        if (flutterPluginBinding != null) {
            if (AGConnectInstance.getInstance() == null) {
                AGConnectInstance.initialize(binding.getActivity().getApplicationContext());
            }
            initChannels(flutterPluginBinding.getBinaryMessenger());
            initHandlers(flutterPluginBinding.getBinaryMessenger(), binding.getActivity());
            setHandlers();
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
        resetHandlers();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = null;
        removeChannels();
        removeHandlers();
    }

    private void initChannels(BinaryMessenger binaryMessenger) {
        methodChannel = new MethodChannel(binaryMessenger, ChannelConstants.METHOD_CHANNEL);
        onDataEncryptionKeyChangeEventChannel = new EventChannel(binaryMessenger, ChannelConstants.ON_DATA_ENCRYPTION_KEY_CHANGE_EVENT_CHANNEL);
        onEventEventChannel = new EventChannel(binaryMessenger, ChannelConstants.ON_EVENT_EVENT_CHANNEL);
    }

    private void removeChannels() {
        methodChannel = null;
        onDataEncryptionKeyChangeEventChannel = null;
        onEventEventChannel = null;
    }

    private void initHandlers(BinaryMessenger binaryMessenger, Activity activity) {
        if (AGConnectInstance.getInstance() == null) {
            AGConnectInstance.initialize(activity.getApplicationContext());
        }

        methodCallHandler = new MethodHandler(binaryMessenger, activity);
        onDataEncryptionKeyChangeStreamHandler = new OnDataEncryptionKeyChangeStreamHandler();
        onEventStreamHandler = new OnEventStreamHandler();
    }

    private void removeHandlers() {
        methodCallHandler = null;
        onDataEncryptionKeyChangeStreamHandler = null;
        onEventStreamHandler = null;
    }

    private void setHandlers() {
        methodChannel.setMethodCallHandler(methodCallHandler);
        onDataEncryptionKeyChangeEventChannel.setStreamHandler(onDataEncryptionKeyChangeStreamHandler);
        onEventEventChannel.setStreamHandler(onEventStreamHandler);
    }

    private void resetHandlers() {
        methodChannel.setMethodCallHandler(null);
        onDataEncryptionKeyChangeEventChannel.setStreamHandler(null);
        onEventEventChannel.setStreamHandler(null);
    }
}
