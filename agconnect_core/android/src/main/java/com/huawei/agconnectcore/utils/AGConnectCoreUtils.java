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

import com.huawei.agconnect.AGCRoutePolicy;

import java.util.HashMap;
import java.util.Map;

public class AGConnectCoreUtils {
    public static Map<String, Object> mapFromRoutePolicy(AGCRoutePolicy routePolicy) {
        if (routePolicy != null) {
            Map<String, Object> res = new HashMap<>();
            res.put("routeName", routePolicy.getRouteName());
            return res;
        } else {
            return null;
        }
    }
}
