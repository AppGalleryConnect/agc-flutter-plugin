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
package com.huawei.agconnectcore.handlers;

import android.content.Context;

import androidx.annotation.NonNull;

import com.huawei.agconnect.AGCRoutePolicy;
import com.huawei.agconnect.AGConnectOptions;
import com.huawei.agconnect.AGConnectOptionsBuilder;
import com.huawei.agconnectcore.AGConnectCoreModule;
import com.huawei.agconnectcore.constants.Method;
import com.huawei.agconnectcore.utils.ValueGetter;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGConnectCoreMethodHandler implements MethodCallHandler{
    private final AGConnectCoreModule agConnectCoreModule;
    private Context context;

    public AGConnectCoreMethodHandler(AGConnectCoreModule module,Context context){
        this.agConnectCoreModule = module;
        this.context = context;
    }
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method){
            case Method.BUILD_INSTANCE:
                Map map = (Map) call.arguments;
                AGConnectOptions agConnectOptions = ValueGetter.toAGConnectOptions(map,context);
                agConnectCoreModule.buildInstance(agConnectOptions,result);
                break;
            case Method.GET_PACKAGE_NAME:
                agConnectCoreModule.getPackageName(result);
                break;
            case Method.GET_ROUTE_POLICY:
                agConnectCoreModule.getRoutePolicy(result);
                break;
            case Method.GET_STRING:
                String path = call.argument("path");
                String def = call.argument("def");
                agConnectCoreModule.getString(path,def,result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
