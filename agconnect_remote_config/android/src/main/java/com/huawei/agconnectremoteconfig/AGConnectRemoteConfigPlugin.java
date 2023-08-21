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

package com.huawei.agconnectremoteconfig;

import android.content.Context;

import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.exception.AGCException;
import com.huawei.agconnect.remoteconfig.AGCConfigException;
import com.huawei.agconnect.remoteconfig.AGConnectConfig;
import com.huawei.agconnect.remoteconfig.ConfigValues;
import com.huawei.hmf.tasks.OnFailureListener;
import com.huawei.hmf.tasks.OnSuccessListener;
import com.huawei.hmf.tasks.Task;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class AGConnectRemoteConfigPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        initAGConnectSDK(flutterPluginBinding.getApplicationContext());
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),
                "com.huawei.flutter/agconnect_remote_config");
        channel.setMethodCallHandler(this);
    }

    public static void registerWith(Registrar registrar) {
        initAGConnectSDK(registrar.context().getApplicationContext());
        final MethodChannel channel = new MethodChannel(registrar.messenger(),
                "com.huawei.flutter/agconnect_remote_config");
        channel.setMethodCallHandler(new AGConnectRemoteConfigPlugin());
    }

    static void initAGConnectSDK(Context context) {
        if (AGConnectInstance.getInstance() == null) {
            AGConnectInstance.initialize(context);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        if (call.method.equals("applyDefaults")) {
            Map<String, Map<String, Object>> arguments = call.arguments();
            Map<String, Object> defaults = arguments.get("defaults");
            AGConnectConfig.getInstance().applyDefault(defaults);
            result.success(null);

        } else if (call.method.equals("applyLastFetched")) {
            ConfigValues values = AGConnectConfig.getInstance().loadLastFetched();
            AGConnectConfig.getInstance().apply(values);
            result.success(null);

        } else if (call.method.equals("fetch")) {
            Map<String, Object> arguments = call.arguments();
            Integer intervalSeconds = (Integer) arguments.get("intervalSeconds");
            Task<ConfigValues> task;
            if (intervalSeconds != null) {
                task = AGConnectConfig.getInstance().fetch(intervalSeconds.intValue());
            } else {
                task = AGConnectConfig.getInstance().fetch();
            }
            task.addOnSuccessListener(new OnSuccessListener<ConfigValues>() {
                @Override
                public void onSuccess(ConfigValues configValues) {
                    result.success(null);
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(Exception e) {
                    if (e instanceof AGCConfigException) {
                        AGCConfigException exception = (AGCConfigException) e;
                        HashMap<String, Object> detail = new HashMap<>();
                        detail.put(
                                "throttleEndTime",
                                exception.getThrottleEndTimeMillis());
                        result.error(String.valueOf(exception.getCode()), exception.getErrMsg(), detail);
                    } else if (e instanceof AGCException) {
                        AGCException exception = (AGCException) e;
                        result.error(String.valueOf(exception.getCode()), exception.getErrMsg(), null);
                    } else {
                        result.error("", e.getMessage(), null);
                    }
                }
            });
        } else if (call.method.equals("getValue")) {
            Map<String, Object> arguments = call.arguments();
            String key = arguments.get("key").toString();
            String value = AGConnectConfig.getInstance().getValueAsString(key);
            result.success(value);
        } else if (call.method.equals("getSource")) {
            Map<String, Object> arguments = call.arguments();
            String key = arguments.get("key").toString();
            AGConnectConfig.SOURCE value = AGConnectConfig.getInstance().getSource(key);
            result.success(value.ordinal());
        } else if (call.method.equals("getMergedAll")) {
            Map value = AGConnectConfig.getInstance().getMergedAll();
            result.success(value);
        } else if (call.method.equals("clearAll")) {
            AGConnectConfig.getInstance().clearAll();
            result.success(null);
        } else if (call.method.equals("setDeveloperMode")) {
            Map<String, Object> arguments = call.arguments();
            Boolean mode = (Boolean) arguments.get("mode");
            boolean isDeveloperMode = mode != null ? mode.booleanValue() : false;
            AGConnectConfig.getInstance().setDeveloperMode(isDeveloperMode);
            result.success(null);
        } else if (call.method.equals("setCustomAttributes")) {
            Map<String, Map<String, String>> arguments = call.arguments();
            Map<String, String> map = arguments.get("customAttributes");
            AGConnectConfig.getInstance().setCustomAttributes(map);
            result.success(null);
        } else if (call.method.equals("getCustomAttributes")) {
            Map value = AGConnectConfig.getInstance().getCustomAttributes();
            result.success(value);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
