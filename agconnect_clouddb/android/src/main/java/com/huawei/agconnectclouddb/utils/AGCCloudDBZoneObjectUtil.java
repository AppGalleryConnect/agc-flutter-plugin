/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2023. All rights reserved.
 */

package com.huawei.agconnectclouddb.utils;

import androidx.annotation.NonNull;

import com.huawei.agconnect.cloud.database.CloudDBZoneObject;
import com.huawei.agconnect.cloud.database.Text;

import java.lang.reflect.Field;
import java.security.AccessController;
import java.security.PrivilegedAction;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public abstract class AGCCloudDBZoneObjectUtil {
    public static Map<String, Object> toMap(@NonNull CloudDBZoneObject instance) throws IllegalAccessException {
        final Map<String, Object> map = new HashMap<>();

        for (Field field : instance.getClass().getDeclaredFields()) {
            AccessController.doPrivileged((PrivilegedAction<Object>) () -> {
                field.setAccessible(true);
                return new Object[0];
            });

            final String fieldName = field.getName();
            final Object fieldValue = field.get(instance);

            if (fieldValue == null) {
                map.put(fieldName, null);
            } else {
                final Class<?> fieldType = field.getType();

                if (fieldType.equals(String.class)) {
                    map.put(fieldName, fieldValue.toString());
                } else if (fieldType.equals(Boolean.class)) {
                    map.put(fieldName, Boolean.parseBoolean(fieldValue.toString()));
                } else if (fieldType.equals(Integer.class)) {
                    map.put(fieldName, Integer.parseInt(fieldValue.toString()));
                } else if (fieldType.equals(Double.class) || fieldType.equals(Float.class)) {
                    map.put(fieldName, Double.parseDouble(fieldValue.toString()));
                } else if (fieldType.equals(Short.class)) {
                    map.put(fieldName, Short.parseShort(fieldValue.toString()));
                } else if (fieldType.equals(Long.class)) {
                    map.put(fieldName, Long.parseLong(fieldValue.toString()));
                } else if (fieldType.equals(Text.class)) {
                    map.put(fieldName, ((Text) field.get(instance)).get());
                } else if (fieldType.equals(Date.class)) {
                    map.put(fieldName, ((Date) field.get(instance)).getTime());
                } else if (fieldType.equals(Byte.class)) {
                    map.put(fieldName, ((Byte) field.get(instance)).intValue());
                } else if (fieldType.equals(byte[].class)) {
                    final List<Integer> result = new ArrayList<>();
                    for (Byte byteValue : (byte[]) field.get(instance)) {
                        result.add(byteValue.intValue());
                    }
                    map.put(fieldName, result);
                }
            }
        }
        return map;
    }

    public static CloudDBZoneObject fromMap(String className, Map<String, Object> valueMap) throws InstantiationException, IllegalAccessException, ClassNotFoundException {
        final CloudDBZoneObject instance = Objects.requireNonNull(AGCCloudDBUtil.getClass(className)).newInstance();

        for (Field field : instance.getClass().getDeclaredFields()) {
            final Object value = valueMap.get(field.getName());

            if (value != null) {
                AccessController.doPrivileged((PrivilegedAction<Object>) () -> {
                    field.setAccessible(true);
                    return new Object[0];
                });
                final Class<?> fieldType = field.getType();

                if (fieldType.equals(String.class)) {
                    field.set(instance, value.toString());
                } else if (fieldType.equals(Boolean.class)) {
                    field.set(instance, Boolean.parseBoolean(value.toString()));
                } else if (fieldType.equals(Integer.class)) {
                    field.set(instance, Integer.parseInt(value.toString()));
                } else if (fieldType.equals(Double.class)) {
                    field.set(instance, Double.parseDouble(value.toString()));
                } else if (fieldType.equals(Float.class)) {
                    field.set(instance, Float.parseFloat(value.toString()));
                } else if (fieldType.equals(Short.class)) {
                    field.set(instance, Short.parseShort(value.toString()));
                } else if (fieldType.equals(Long.class)) {
                    field.set(instance, Long.parseLong(value.toString()));
                } else if (fieldType.equals(Text.class)) {
                    field.set(instance, new Text(value.toString()));
                } else if (fieldType.equals(Date.class)) {
                    field.set(instance, new Date(Long.parseLong(value.toString())));
                } else if (fieldType.equals(Byte.class)) {
                    field.set(instance, Byte.parseByte(value.toString()));
                } else if (fieldType.equals(byte[].class)) {
                    final List<Integer> intList = (List<Integer>) value;
                    final byte[] byteArr = new byte[intList.size()];
                    for (int i = 0; i < byteArr.length; i++) {
                        byteArr[i] = Byte.parseByte(intList.get(i).toString());
                    }
                    field.set(instance, byteArr);
                }
            }
        }
        return instance;
    }
}
