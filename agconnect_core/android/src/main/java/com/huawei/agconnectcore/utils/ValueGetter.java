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
package com.huawei.agconnectcore.utils;
import android.content.Context;
import android.util.Pair;

import com.huawei.agconnect.AGCRoutePolicy;
import com.huawei.agconnect.AGConnectOptions;
import com.huawei.agconnect.AGConnectOptionsBuilder;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;

public class ValueGetter {
    static String tag = ValueGetter.class.getName();

    /**
     * Converts a Object into a String.
     *
     * @param key:   String key.
     * @param value: Object value.
     * @return map
     */
    public static String getString(String key, Object value) {
        if (!(value instanceof String)) {
            Log.w(tag, "toString | String value expected for " + key + ". ");
            return "";
        }
        return (String) value;
    }

    /**
     * Converts a Object into a Boolean.
     *
     * @param value: Object value.
     * @return map
     */
    public static AGConnectOptions toAGConnectOptions(Map value, Context context) {
            Map<String,Object> map = (Map<String, Object>) value;
            String productId = (String) map.get("productId");
            String appId = (String) map.get("appId");
            String cpId = (String) map.get("cpId");
            String clientId = (String) map.get("clientId");
            String clientSecret = (String) map.get("clientSecret");
            String apiKey = (String) map.get("apiKey");
            int routePolicy = (int) map.get("routePolicy");
            String packageName = (String) map.get("packageName");
            AGConnectOptionsBuilder builder = new AGConnectOptionsBuilder()
                    .setProductId(productId)
                    .setAppId(appId)
                    .setCPId(cpId)
                    .setClientId(clientId)
                    .setClientSecret(clientSecret)
                    .setApiKey(apiKey)
                    .setRoutePolicy(toRoutePolicy(routePolicy))
                    .setPackageName(packageName);
            return builder.build(context);
    }

    private static AGCRoutePolicy toRoutePolicy(int value){
        switch (value){
            case 0:
                return AGCRoutePolicy.UNKNOWN;
            case 1:
                return AGCRoutePolicy.CHINA;
            case 2:
                return AGCRoutePolicy.GERMANY;
            case 3:
                return AGCRoutePolicy.RUSSIA;
            case 4:
                return AGCRoutePolicy.SINGAPORE;
            default:
                return null;
        }
    }
}

