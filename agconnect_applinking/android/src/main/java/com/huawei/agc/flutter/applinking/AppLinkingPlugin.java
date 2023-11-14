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

package com.huawei.agc.flutter.applinking;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.huawei.agc.flutter.applinking.handlers.AppLinkingMethodCallHandler;
import com.huawei.agc.flutter.applinking.handlers.AppLinkingStreamHandler;
import com.huawei.agc.flutter.applinking.services.AppLinkingViewModel;
import com.huawei.agconnect.AGConnectInstance;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class AppLinkingPlugin implements FlutterPlugin, ActivityAware {
    private MethodChannel methodChannel;
    private MethodChannel.MethodCallHandler methodCallHandler;
    private AppLinkingViewModel appLinkingViewModel;
    private EventChannel eventChannel;
    private EventChannel.StreamHandler streamHandler;
    private FlutterPluginBinding flutterPluginBinding;

    public static void registerWith(Registrar registrar) {
        AppLinkingPlugin appLinkingPlugin = new AppLinkingPlugin();
        registrar.publish(appLinkingPlugin);
        appLinkingPlugin.onAttachedToEngine(registrar.messenger(), registrar.activity());
    }

    private void onAttachedToEngine(final BinaryMessenger messenger, final Activity activity) {
        if (AGConnectInstance.getInstance() == null) {
            AGConnectInstance.initialize(activity.getApplicationContext());
        }
        initializeChannels(messenger);
        setHandlers(activity);
    }

    private void initializeChannels(final BinaryMessenger messenger) {
        methodChannel = new MethodChannel(messenger, "com.huawei.agc.flutter.applinking_methodchannel");
        eventChannel = new EventChannel(messenger, "com.huawei.agc.flutter.applinking_eventchannel");
    }

    private void setHandlers(Activity activity) {
        appLinkingViewModel = new AppLinkingViewModel();
        methodCallHandler = new AppLinkingMethodCallHandler(appLinkingViewModel);
        methodChannel.setMethodCallHandler(methodCallHandler);
        streamHandler = new AppLinkingStreamHandler(activity);
        eventChannel.setStreamHandler(streamHandler);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
        initializeChannels(flutterPluginBinding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        removeChannels();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        if (this.flutterPluginBinding != null) {
            onAttachedToEngine(this.flutterPluginBinding.getBinaryMessenger(), binding.getActivity());
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
        methodChannel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
    }

    private void removeChannels() {
        streamHandler = null;
        methodCallHandler = null;
        appLinkingViewModel = null;
        methodChannel = null;
        eventChannel = null;
    }
}
