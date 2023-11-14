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

package com.huawei.agc.flutter.applinking.utils;

import com.huawei.agconnect.applinking.AppLinking;
import com.huawei.agconnect.applinking.ResolvedLinkData;
import com.huawei.agconnect.applinking.ShortAppLinking;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;

public interface Utils {
    /**
     * Converts a ResolvedLinkData into a map.
     *
     * @param resolvedLinkData: ResolvedLinkData to be converted.
     * @return map
     */
    static Map<String, Object> fromResolvedLinkDataToMap(ResolvedLinkData resolvedLinkData) {
        if (resolvedLinkData == null) {
            return Collections.emptyMap();
        }

        final Map<String, Object> map = new HashMap<>();

        map.put("deepLink", resolvedLinkData.getDeepLink().toString());
        map.put("clickTimeStamp", resolvedLinkData.getClickTimestamp());
        map.put("socialTitle", resolvedLinkData.getSocialTitle());
        map.put("socialDescription", resolvedLinkData.getSocialDescription());
        map.put("socialImageUrl", resolvedLinkData.getSocialImageUrl());
        map.put("campaignName", resolvedLinkData.getCampaignName());
        map.put("campaignMedium", resolvedLinkData.getCampaignMedium());
        map.put("campaignSource", resolvedLinkData.getCampaignSource());
        map.put("installSource", resolvedLinkData.getInstallSource());
        map.put("linkType", resolvedLinkData.getLinkType().ordinal());

        return map;
    }

    /**
     * Converts a ShortAppLinking into a map.
     *
     * @param shortAppLinking: ShortAppLinking to be converted.
     * @return map
     */
    static Map<String, Object> fromShortAppLinkingToMap(ShortAppLinking shortAppLinking) {
        if (shortAppLinking == null) {
            return Collections.emptyMap();
        }

        final Map<String, Object> map = new HashMap<>();

        map.put("shortLink", shortAppLinking.getShortUrl().toString());
        map.put("testUrl", shortAppLinking.getTestUrl().toString());
        Log.d("shortLink", shortAppLinking.getShortUrl().toString() + " " + shortAppLinking.getTestUrl().toString());
        return map;
    }

    /**
     * Converts a AppLinking into a map.
     *
     * @param appLinking: AppLinking to be converted.
     * @return map
     */
    static Map<String, Object> fromAppLinkingToMap(AppLinking appLinking) {
        if (appLinking == null) {
            return Collections.emptyMap();
        }

        final Map<String, Object> map = new HashMap<>();

        map.put("longLink", appLinking.getUri().toString());
        return map;
    }
}
