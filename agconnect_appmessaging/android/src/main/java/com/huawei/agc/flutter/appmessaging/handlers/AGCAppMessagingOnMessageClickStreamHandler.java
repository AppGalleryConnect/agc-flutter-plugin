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

package com.huawei.agc.flutter.appmessaging.handlers;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.huawei.agc.flutter.appmessaging.utils.Utils;
import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.appmessaging.AGConnectAppMessaging;
import com.huawei.agconnect.appmessaging.AGConnectAppMessagingOnClickListener;
import com.huawei.agconnect.appmessaging.model.Action;
import com.huawei.agconnect.appmessaging.model.AppMessage;

import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;

public class AGCAppMessagingOnMessageClickStreamHandler implements StreamHandler {

    public AGCAppMessagingOnMessageClickStreamHandler(final Activity activity) {
        if (AGConnectInstance.getInstance() == null) {
            AGConnectInstance.initialize(activity.getApplicationContext());
        }
    }

    @Override
    public void onListen(final Object arguments, final EventSink eventSink) {
        AGConnectAppMessaging.getInstance().addOnClickListener(new AGConnectAppMessagingOnClickListener() {
            @Override
            public void onMessageClick(@NonNull AppMessage appMessage, @NonNull Action action) {
                eventSink.success(Utils.fromAppMessageToMap(appMessage));
            }
        });
    }

    @Override
    public void onCancel(final Object arguments) {
    }
}
