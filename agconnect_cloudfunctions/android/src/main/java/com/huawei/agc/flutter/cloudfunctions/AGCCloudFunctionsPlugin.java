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

package com.huawei.agc.flutter.cloudfunctions;

import androidx.annotation.NonNull;

import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.function.AGConnectFunction;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class AGCCloudFunctionsPlugin implements FlutterPlugin {
    private MethodChannel methodChannel;
    private AGConnectFunction agConnectFunction;

    @Override
    public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
        if (AGConnectInstance.getInstance() == null) {
            AGConnectInstance.initialize(binding.getApplicationContext());
        }
        agConnectFunction = AGConnectFunction.getInstance();
        methodChannel = new MethodChannel(binding.getBinaryMessenger(), "com.huawei.agc.flutter.cloudfunctions/MethodChannel");
        methodChannel.setMethodCallHandler(new CloudFunctionsMethodCallHandler(agConnectFunction));
    }

    @Override
    public void onDetachedFromEngine(@NonNull final FlutterPluginBinding binding) {
        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }
        agConnectFunction = null;
    }
}
