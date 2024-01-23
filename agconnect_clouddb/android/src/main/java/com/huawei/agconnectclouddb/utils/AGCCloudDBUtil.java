/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2023. All rights reserved.
 */

package com.huawei.agconnectclouddb.utils;

import com.huawei.agconnect.cloud.database.CloudDBZoneObject;
import com.huawei.agconnectclouddb.objecttypes.ObjectTypeInfoHelper;

import java.util.Locale;

public abstract class AGCCloudDBUtil {
    public static Class<CloudDBZoneObject> getClass(String className) throws ClassNotFoundException {
        for (Class<? extends CloudDBZoneObject> clazz : ObjectTypeInfoHelper.getObjectTypeInfo().getObjectTypes()) {
            if (clazz.getSimpleName().equals(className)) {
                return (Class<CloudDBZoneObject>) clazz;
            }
        }
        throw new ClassNotFoundException(String.format(Locale.ENGLISH, "%s not found.", className));
    }
}
