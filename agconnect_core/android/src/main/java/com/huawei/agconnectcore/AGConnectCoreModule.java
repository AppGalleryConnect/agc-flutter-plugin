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
package com.huawei.agconnectcore;

import android.app.Activity;

import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.AGConnectOptions;
import com.huawei.agconnectcore.presenter.AGConnectCoreContract;
import com.huawei.agconnectcore.viewmodel.AGConnectCoreViewModel;

import io.flutter.plugin.common.MethodChannel;

public class AGConnectCoreModule {
    private final AGConnectCoreContract.Presenter viewModel;

    public AGConnectCoreModule(Activity activity){
        viewModel = new AGConnectCoreViewModel(activity);
    }

    public void buildInstance(AGConnectOptions agConnectOptions, final MethodChannel.Result result) {
        viewModel.buildInstance(agConnectOptions,new AGConnectCoreResultHandler(result));
    }

    public void getRoutePolicy(final MethodChannel.Result result){
        viewModel.getRoutePolicy(new AGConnectCoreResultHandler(result));
    }

    public void getPackageName(final MethodChannel.Result result){
        viewModel.getPackageName(new AGConnectCoreResultHandler(result));
    }

    public void getString(String path, String def,final MethodChannel.Result result){
        viewModel.getString(path,def,new AGConnectCoreResultHandler(result));
    }

    private class AGConnectCoreResultHandler implements AGConnectCoreContract.ResultListener{
        private MethodChannel.Result mResult;
        AGConnectCoreResultHandler(final MethodChannel.Result result){this.mResult = result;}
        @Override
        public void onSuccess(Object result) {
            mResult.success(result);
        }

        @Override
        public void onFail(Exception exception) {
            mResult.error("",exception.getMessage(),exception.getLocalizedMessage());
        }
    }
}
