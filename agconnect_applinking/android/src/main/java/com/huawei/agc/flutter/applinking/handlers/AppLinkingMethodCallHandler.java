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

package com.huawei.agc.flutter.applinking.handlers;

import androidx.annotation.NonNull;

import com.huawei.agc.flutter.applinking.constants.Method;
import com.huawei.agc.flutter.applinking.utils.AGCAppLinkingException;
import com.huawei.agc.flutter.applinking.services.AppLinkingViewModel;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class AppLinkingMethodCallHandler implements MethodCallHandler {
    private final AppLinkingViewModel appLinkingViewModel;

    public AppLinkingMethodCallHandler(AppLinkingViewModel service) {
        this.appLinkingViewModel = service;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        appLinkingViewModel.setCall(call);
        appLinkingViewModel.setResult(result);
        try {
            switch (call.method) {
                case Method.BUILD_APP_LINKING:
                    appLinkingViewModel.buildLongAppLinking();
                    break;
                case Method.BUILD_SHORT_APP_LINKING:
                    appLinkingViewModel.buildShortAppLinking();
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        } catch (RuntimeException | AGCAppLinkingException e) {
            final AGCAppLinkingException exception = AGCAppLinkingException.from(e);
            result.error(exception.getErrorCode(), exception.getErrorMessage(), exception.getErrorDetails());
        }
    }
}
