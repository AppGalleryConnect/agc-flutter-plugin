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

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.huawei.agconnect.AGCRoutePolicy;
import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.AGConnectOptionsBuilder;
import com.huawei.agconnect.cloud.storage.core.AGCStorageManagement;
import com.huawei.agconnect.cloud.storage.core.FileMetadata;
import com.huawei.agconnect.cloud.storage.core.ListResult;
import com.huawei.agconnect.cloud.storage.core.StorageReference;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public abstract class AGCStorageUtil {
    private static AGConnectInstance getAGCInstance(@NonNull Context context, @NonNull Integer policyIndex) throws AGCStorageException {
        try {
            final AGConnectOptionsBuilder builder = new AGConnectOptionsBuilder();
            switch (policyIndex) {
                case 0: {
                    builder.setRoutePolicy(AGCRoutePolicy.CHINA);
                    break;
                }
                case 1: {
                    builder.setRoutePolicy(AGCRoutePolicy.GERMANY);
                    break;
                }
                case 2: {
                    builder.setRoutePolicy(AGCRoutePolicy.RUSSIA);
                    break;
                }
                case 3: {
                    builder.setRoutePolicy(AGCRoutePolicy.SINGAPORE);
                    break;
                }
                default: {
                    builder.setRoutePolicy(AGCRoutePolicy.UNKNOWN);
                    break;
                }
            }
            return AGConnectInstance.buildInstance(builder.build(context));
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    public static AGConnectInstance getAGCInstance(@NonNull Context context, @NonNull String area) throws AGCStorageException {
        switch (area) {
            case "CN": {
                return getAGCInstance(context, 0);
            }
            case "DE": {
                return getAGCInstance(context, 1);
            }
            case "RU": {
                return getAGCInstance(context, 2);
            }
            case "SG": {
                return getAGCInstance(context, 3);
            }
            default: {
                return getAGCInstance(context, -1);
            }
        }
    }

    public static AGCStorageManagement getAGCStorageManagement(@NonNull Context context, @Nullable String bucket, @Nullable Integer policyIndex) throws AGCStorageException {
        try {
            if (bucket == null) {
                return AGCStorageManagement.getInstance();
            } else {
                if (policyIndex == null) {
                    return AGCStorageManagement.getInstance(bucket);
                } else {
                    return AGCStorageManagement.getInstance(getAGCInstance(context, policyIndex), bucket);
                }
            }
        } catch (Exception e) {
            throw AGCStorageException.from(e);
        }
    }

    public static Map<String, Object> listResultToMap(ListResult listResult) {
        final Map<String, Object> map = new HashMap<>();
        final ArrayList<String> fileList = new ArrayList<>();
        for (StorageReference fileRef : listResult.getFileList()) {
            fileList.add(fileRef.getPath());
        }
        map.put("fileList", fileList);
        final ArrayList<String> dirList = new ArrayList<>();
        for (StorageReference dirRef : listResult.getDirList()) {
            dirList.add(dirRef.getPath());
        }
        map.put("dirList", dirList);
        map.put("pageMarker", listResult.getPageMarker());
        return map;
    }

    public static Map<String, Object> fileMetadataToMap(@Nullable FileMetadata fileMetadata) {
        final Map<String, Object> map = new HashMap<>();
        if (fileMetadata != null) {
            map.put("bucket", fileMetadata.getBucket());
            map.put("creationTimeMillis", fileMetadata.getCTime());
            map.put("updatedTimeMillis", fileMetadata.getMTime());
            map.put("name", fileMetadata.getName());
            map.put("path", fileMetadata.getPath());
            map.put("size", fileMetadata.getSize());
            map.put("sha256Hash", fileMetadata.getSHA256Hash());
            map.put("contentType", fileMetadata.getContentType());
            map.put("cacheControl", fileMetadata.getCacheControl());
            map.put("contentDisposition", fileMetadata.getContentDisposition());
            map.put("contentEncoding", fileMetadata.getContentEncoding());
            map.put("contentLanguage", fileMetadata.getContentLanguage());
            map.put("customMetadata", fileMetadata.getCustomMetadata());
        }
        return map;
    }

    public static FileMetadata fileMetadataFromMap(@Nullable Map<String, Object> map) {
        final FileMetadata fileMetadata = new FileMetadata();
        if (map != null) {
            if (map.get("cacheControl") != null) {
                fileMetadata.setCacheControl((String) map.get("cacheControl"));
            }
            if (map.get("contentType") != null) {
                fileMetadata.setContentType((String) map.get("contentType"));
            }
            if (map.get("contentDisposition") != null) {
                fileMetadata.setContentDisposition((String) map.get("contentDisposition"));
            }
            if (map.get("contentEncoding") != null) {
                fileMetadata.setContentEncoding((String) map.get("contentEncoding"));
            }
            if (map.get("contentLanguage") != null) {
                fileMetadata.setContentLanguage((String) map.get("contentLanguage"));
            }
            if (map.get("sha256Hash") != null) {
                fileMetadata.setSHA256Hash((String) map.get("sha256Hash"));
            }
            if (map.get("customMetadata") != null) {
                fileMetadata.setCustomMetadata((Map<String, String>) map.get("customMetadata"));
            }
        }
        return fileMetadata;
    }
}
