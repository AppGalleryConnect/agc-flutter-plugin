/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2023. All rights reserved.
 */

package com.huawei.agconnectclouddb.constants;

public abstract class ChannelConstants {
    private static final String PACKAGE = "com.huawei.agconnectclouddb/";
    private static final String METHOD_PREFIX = PACKAGE.concat("methodChannel/");
    private static final String EVENT_PREFIX = PACKAGE.concat("eventChannel/");

    public static final String METHOD_CHANNEL = METHOD_PREFIX.concat("");
    public static final String ON_DATA_ENCRYPTION_KEY_CHANGE_EVENT_CHANNEL = EVENT_PREFIX.concat("onDataEncryptionKeyChange");
    public static final String ON_EVENT_EVENT_CHANNEL = EVENT_PREFIX.concat("onEvent");
}
