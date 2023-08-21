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
package com.huawei.agconnectcore.viewmodel;

import android.app.Activity;

import com.huawei.agconnect.AGCRoutePolicy;
import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.AGConnectOptions;
import com.huawei.agconnect.core.service.ChannelService;
import com.huawei.agconnectcore.presenter.AGConnectCoreContract;
import com.huawei.agconnectcore.utils.AGConnectCoreUtils;

import java.util.Map;
import java.util.logging.Logger;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGConnectCoreViewModel implements AGConnectCoreContract.Presenter {
    private final Activity mActivity;
    private static AGConnectInstance agConnectInstance;

    public AGConnectCoreViewModel(Activity activity) {
        this.mActivity = activity;
        initAGConnectInstance();
    }

    private void initAGConnectInstance() {
        if (AGConnectInstance.getInstance() == null) {
            AGConnectInstance.initialize(mActivity.getApplicationContext());
        }
    }

    @Override
    public void buildInstance(AGConnectOptions agConnectOptions, AGConnectCoreContract.ResultListener<AGConnectInstance> resultListener) {
        agConnectInstance = AGConnectInstance.buildInstance(agConnectOptions);
        if (agConnectInstance != null) {
            resultListener.onSuccess(null);
        } else {
            resultListener.onFail(new NullPointerException("agConnectInstance is null."));
        }

    }

    @Override
    public void getRoutePolicy(AGConnectCoreContract.ResultListener<Map<String, Object>> resultListener) {
        checkAGCInstance();
        AGCRoutePolicy agcRoutePolicy = agConnectInstance.getOptions().getRoutePolicy();
        Map<String, Object> mapRoutePolicy = AGConnectCoreUtils.mapFromRoutePolicy(agcRoutePolicy);
        if (agcRoutePolicy != null) {
            resultListener.onSuccess(mapRoutePolicy);
        } else {
            resultListener.onFail(new NullPointerException("agcRoutePolicy is null."));
        }
    }

    @Override
    public void getPackageName(AGConnectCoreContract.ResultListener<String> resultListener) {
        checkAGCInstance();
        AGConnectOptions agConnectOptions = agConnectInstance.getOptions();
        if (agConnectOptions != null) {
            String packageName = agConnectOptions.getPackageName();
            resultListener.onSuccess(packageName);
        } else {
            resultListener.onFail(new NullPointerException("agConnectOptions is null"));
        }
    }

    @Override
    public void getString(String path, String def, AGConnectCoreContract.ResultListener<String> resultListener) {
        checkAGCInstance();
        AGConnectOptions agConnectOptions = agConnectInstance.getOptions();
        if (agConnectOptions != null) {
            String param = agConnectOptions.getString(path, def);
            resultListener.onSuccess(param);
        } else {
            resultListener.onFail(new NullPointerException("agconnectOptions or path null."));
        }

    }

    private void checkAGCInstance(){
        if(agConnectInstance == null){
            agConnectInstance = AGConnectInstance.getInstance();
        }
    }
}
