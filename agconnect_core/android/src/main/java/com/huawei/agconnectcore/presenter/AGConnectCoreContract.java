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
package com.huawei.agconnectcore.presenter;

import com.huawei.agconnect.AGCRoutePolicy;
import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.AGConnectOptions;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public interface AGConnectCoreContract {
    interface Presenter{

        void buildInstance(AGConnectOptions agConnectOptions,final AGConnectCoreContract.ResultListener<AGConnectInstance> resultListener);

        void getRoutePolicy(final AGConnectCoreContract.ResultListener<Map<String,Object>> resultListener);

        void getPackageName(final AGConnectCoreContract.ResultListener<String> resultListener);

        void getString(String path, String def ,final AGConnectCoreContract.ResultListener<String> resultListener);
    }

    interface ResultListener<T> {
        /**
         * Presents the success scenario, Generic result instance is returned.
         *
         * @param result: Result instance.
         */
        void onSuccess(T result);

        /**
         * Presents the failure scenario, Exception instance is returned.
         *
         * @param exception: Exception instance.
         */
        void onFail(Exception exception);
    }
}
