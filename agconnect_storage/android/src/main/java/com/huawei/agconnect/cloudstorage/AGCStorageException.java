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

package com.huawei.agconnect.cloudstorage;

import com.huawei.agconnect.cloud.storage.core.StorageException;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import io.flutter.Log;

public class AGCStorageException extends Exception {
    private final String errorCode;
    private final String errorMessage;
    private final Map<String, Object> errorDetails = new HashMap<>();

    public AGCStorageException(String code, String message) {
        this(code, message, "PluginException");
    }

    private AGCStorageException(String code, String message, String exceptionType) {
        this.errorCode = code;
        this.errorMessage = message;
        this.errorDetails.put("exceptionType", exceptionType);

        Log.e("AGCStorageException", String.format(Locale.ENGLISH, "(%s) %s: %s", exceptionType, this.errorCode, this.errorMessage));
    }

    public static AGCStorageException from(Exception e) {
        if (e instanceof AGCStorageException) {
            return (AGCStorageException) e;
        } else {
            if (e instanceof StorageException) {
                return new AGCStorageException(((StorageException) e).getErrorCode() + "", ((StorageException) e).getErrMsg(), "SDKException");
            } else {
                return new AGCStorageException("UNKNOWN", e.getMessage(), "SDKException");
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
