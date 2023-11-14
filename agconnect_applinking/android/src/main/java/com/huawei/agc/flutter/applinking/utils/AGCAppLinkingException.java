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

import com.huawei.agconnect.applinking.AppLinkingException;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import io.flutter.Log;

public class AGCAppLinkingException extends Exception {
    private final String errorCode;
    private final String errorMessage;
    private final Map<String, Object> errorDetails = new HashMap<>();

    public AGCAppLinkingException(String code, String message) {
        this(code, message, "PluginException");
    }

    private AGCAppLinkingException(String code, String message, String exceptionType) {
        this.errorCode = code;
        this.errorMessage = message;
        this.errorDetails.put("exceptionType", exceptionType);

        Log.e("AGCAppLinkingException", String.format(Locale.ENGLISH, "(%s) %s: %s", exceptionType, this.errorCode, this.errorMessage));
    }

    public static AGCAppLinkingException from(Exception e) {
        if (e instanceof AGCAppLinkingException) {
            return (AGCAppLinkingException) e;
        } else {
            if (e instanceof AppLinkingException) {
                return new AGCAppLinkingException("UNKNOWN", e.getMessage(), "SDKException");
            } else {
                return new AGCAppLinkingException("UNKNOWN", e.getMessage());
            }
        }
    }

    public String getErrorCode() {
        return this.errorCode;
    }

    public String getErrorMessage() {
        return this.errorMessage;
    }

    public Map<String, Object> getErrorDetails() {
        return this.errorDetails;
    }
}
