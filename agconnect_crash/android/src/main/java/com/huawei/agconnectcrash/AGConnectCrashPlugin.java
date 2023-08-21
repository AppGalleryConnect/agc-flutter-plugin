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

package com.huawei.agconnectcrash;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.crash.AGConnectCrash;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class AGConnectCrashPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        initAGConnectSDK(flutterPluginBinding.getApplicationContext());
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.huawei.flutter/agconnect_crash");
        channel.setMethodCallHandler(this);
    }

    public static void registerWith(Registrar registrar) {
        initAGConnectSDK(registrar.context().getApplicationContext());
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.huawei.flutter/agconnect_crash");
        channel.setMethodCallHandler(new AGConnectCrashPlugin());
    }

    static void initAGConnectSDK(Context context) {
        if (AGConnectInstance.getInstance() == null) {
            AGConnectInstance.initialize(context);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("testIt")) {
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    Context context = AGConnectInstance.getInstance().getContext();
                    AGConnectCrash.getInstance().testIt(context);
                }
            });

        } else if (call.method.equals("enableCrashCollection")) {
            Map<String, Object> arguments = call.arguments();
            boolean enable = (boolean) arguments.get("enable");
            AGConnectCrash.getInstance().enableCrashCollection(enable);
            result.success(null);

        } else if (call.method.equals("setUserId")) {
            Map<String, Object> arguments = call.arguments();
            String userId = arguments.get("userId").toString();
            AGConnectCrash.getInstance().setUserId(userId);
            result.success(null);

        } else if (call.method.equals("setCustomKey")) {
            Map<String, Object> arguments = call.arguments();
            String key = arguments.get("key").toString();
            String value = arguments.get("value").toString();
            AGConnectCrash.getInstance().setCustomKey(key, value);
            result.success(null);

        } else if (call.method.equals("customLog")) {
            Map<String, Object> arguments = call.arguments();
            int level = (int) arguments.get("level");
            int androidLevel = convertToAndroidLevel(level);
            String message = arguments.get("message").toString();
            AGConnectCrash.getInstance().log(androidLevel, message);
            result.success(null);

        } else if (call.method.equals("recordError")) {
            Map<String, Object> arguments = call.arguments();
            String reason = arguments.get("reason").toString();
            String message = arguments.get("stack").toString();
            boolean isFatal = Boolean.valueOf(arguments.get("fatal").toString());
            FlutterError exception = new FlutterError(reason);
            exception.setStackTrace(generateStackTrace(message));
            if (isFatal) {
                AGConnectCrash.getInstance().recordFatalException(exception);
            } else {
                AGConnectCrash.getInstance().recordException(exception);
            }
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private int convertToAndroidLevel(int level) {
        return level + 3;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private StackTraceElement[] generateStackTrace(String stack) {
        String[] stackList = stack.split("\n");
        StackTraceElement[] stackTraceElements = new StackTraceElement[stackList.length];
        for (int i = 0; i < stackList.length; i++) {
            String fileName = "";
            int lineNumber = 0;
            String className = "";
            String methodName = "";
            String line = stackList[i];
            String[] contents = line.split("\\s\\(|\\s{2,}");
            if (contents.length == 3) {
                String classInfo = contents[1];
                if (classInfo.contains(".")) {
                    methodName = classInfo.substring(classInfo.indexOf(".") + 1);
                    className = classInfo.substring(0, classInfo.indexOf("."));
                } else {
                    methodName = classInfo;
                }
                String[] fileInfo = contents[2].split(":");
                if (fileInfo.length == 4) {
                    lineNumber = Integer.valueOf(fileInfo[2]);
                    fileName = fileInfo[0] + ":" + fileInfo[1];
                }
            }
            StackTraceElement element = new StackTraceElement(className, methodName, fileName, lineNumber);
            stackTraceElements[i] = element;
        }
        return stackTraceElements;
    }

}
