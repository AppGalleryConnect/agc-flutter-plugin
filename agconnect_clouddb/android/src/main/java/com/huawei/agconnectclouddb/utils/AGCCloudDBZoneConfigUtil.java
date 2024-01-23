/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2023. All rights reserved.
 */

package com.huawei.agconnectclouddb.utils;

import androidx.annotation.NonNull;

import com.huawei.agconnect.cloud.database.CloudDBZoneConfig;
import com.huawei.agconnect.cloud.database.CloudDBZoneConfig.CloudDBZoneAccessProperty;
import com.huawei.agconnect.cloud.database.CloudDBZoneConfig.CloudDBZoneSyncProperty;

import java.util.HashMap;
import java.util.Map;

public abstract class AGCCloudDBZoneConfigUtil {
    public static Map<String, Object> toMap(@NonNull CloudDBZoneConfig cloudDBZoneConfig) {
        final Map<String, Object> map = new HashMap<>();
        map.put("zoneName", cloudDBZoneConfig.getCloudDBZoneName());
        map.put("syncProperty", cloudDBZoneConfig.getSyncProperty().name());
        map.put("accessProperty", cloudDBZoneConfig.getAccessProperty().name());
        map.put("capacity", cloudDBZoneConfig.getCapacity());
        map.put("isEncrypted", cloudDBZoneConfig.isEncrypted());
        map.put("isPersistenceEnabled", cloudDBZoneConfig.getPersistenceEnabled());
        return map;
    }

    public static CloudDBZoneConfig fromMap(@NonNull Map<String, Object> map) {
        final String zoneName = (String) map.get("zoneName");
        final CloudDBZoneSyncProperty zoneSyncProperty = CloudDBZoneSyncProperty.values()[(int) map.get("syncProperty")];
        final CloudDBZoneAccessProperty zoneAccessProperty = CloudDBZoneAccessProperty.values()[(int) map.get("accessProperty")];

        final CloudDBZoneConfig config = new CloudDBZoneConfig(zoneName, zoneSyncProperty, zoneAccessProperty);

        final boolean isPersistenceEnabled = (boolean) map.get("isPersistenceEnabled");
        if (isPersistenceEnabled) {
            config.setCapacity((int) map.get("capacity"));
        }
        config.setPersistenceEnabled(isPersistenceEnabled);

        if ((boolean) map.get("isEncrypted")) {
            config.setEncryptedKey((String) map.get("userKey"), (String) map.get("userReKey"));
        }
        return config;
    }
}
