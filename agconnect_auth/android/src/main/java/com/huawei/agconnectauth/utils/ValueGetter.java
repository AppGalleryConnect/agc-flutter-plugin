/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

package com.huawei.agconnectauth.utils;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;

public final class ValueGetter {

    private ValueGetter() {
    }

    public static String getString(final String key, final MethodCall call) {
        final Object value = call.argument(key);
        if (value instanceof String) {
            return (String) value;
        } else {
            throw new IllegalArgumentException("String argument null or empty");
        }
    }

    public static String getString(final String key, final Map<String, Object> args) {
        final Object value = args.get(key);
        if (value instanceof String) {
            return (String) value;
        } else {
            throw new IllegalArgumentException("String argument " + key + " is null or empty.");
        }
    }

    public static boolean getBoolean(final String key, final Map<String, Object> args) {
        final Object value = args.get(key);
        if (value instanceof Boolean) {
            return (Boolean) value;
        }
        return false;
    }

    public static Integer getInteger(final String key, final Map<String, Object> args) {
        final Object value = args.get(key);
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        throw new IllegalArgumentException("Integer argument " + key + " is null or empty.");
    }
}
