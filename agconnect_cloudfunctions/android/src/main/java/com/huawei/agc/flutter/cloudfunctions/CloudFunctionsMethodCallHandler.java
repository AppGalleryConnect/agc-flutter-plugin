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

import com.huawei.agconnect.function.AGConnectFunction;
import com.huawei.agconnect.function.FunctionCallable;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

final class CloudFunctionsMethodCallHandler implements MethodCallHandler {
    private final AGConnectFunction agConnectFunction;

    CloudFunctionsMethodCallHandler(@NonNull final AGConnectFunction agConnectFunction) {
        this.agConnectFunction = agConnectFunction;
    }

    private void callFunction(@NonNull final MethodCall methodCall, @NonNull final Result result) {
        final FunctionCallable functionCallable = FunctionUtils.getFunctionCallable(methodCall, agConnectFunction);
        final Object functionParameters = methodCall.argument("functionParameters");

        functionCallable.call(functionParameters)
                .addOnSuccessListener(functionResult -> FunctionUtils.sendSuccess(result, functionResult))
                .addOnFailureListener(e -> FunctionUtils.sendError(result, e));
    }

    @Override
    public void onMethodCall(@NonNull final MethodCall methodCall, @NonNull final Result result) {
        if (methodCall.method.equals("callFunction")) {
            callFunction(methodCall, result);
        } else {
            result.notImplemented();
        }
    }
}
