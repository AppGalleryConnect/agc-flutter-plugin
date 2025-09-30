/*
 * Copyright 2020-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

package com.huawei.agconnectcore;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.huawei.agconnect.AGConnectApp;
import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnectcore.handlers.AGConnectCoreMethodHandler;

import java.lang.ref.WeakReference;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGConnectCorePlugin implements FlutterPlugin, ActivityAware {
    private MethodChannel channel;
    private FlutterPluginBinding flutterPluginBinding;
    private AGConnectCoreMethodHandler agConnectCoreMethodHandler;
    private AGConnectCoreModule agConnectCoreModule;

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
            initChannels(flutterPluginBinding.getBinaryMessenger());
            setHandlers(activityPluginBinding.getActivity());
        }
    }

    private void initChannels(BinaryMessenger binaryMessenger) {
        channel = new MethodChannel(binaryMessenger, "com.huawei.flutter/agconnect_core");
    }

    private void setHandlers(Activity activity) {
        agConnectCoreModule = new AGConnectCoreModule(activity);
        agConnectCoreMethodHandler = new AGConnectCoreMethodHandler(agConnectCoreModule,activity.getApplicationContext());
        channel.setMethodCallHandler(agConnectCoreMethodHandler);
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
        channel.setMethodCallHandler(null);
    }
    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        agConnectCoreModule = null;
        channel = null;
        agConnectCoreMethodHandler = null;
    }
}
