/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2023. All rights reserved.
 */

package com.huawei.agconnectclouddb.utils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.huawei.agconnect.cloud.database.CloudDBZoneObject;
import com.huawei.agconnect.cloud.database.CloudDBZoneQuery;
import com.huawei.agconnect.cloud.database.Text;
import com.huawei.agconnectclouddb.constants.QueryConstants;
import com.huawei.agconnectclouddb.exception.AGCCloudDBException;

import java.lang.reflect.Field;
import java.security.AccessController;
import java.security.PrivilegedAction;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public abstract class AGCCloudDBQueryBuilder {
    public static CloudDBZoneQuery<CloudDBZoneObject> build(@NonNull Map<String, Object> queryMap) throws AGCCloudDBException {
        try {
            final @NonNull String objectTypeName = (String) Objects.requireNonNull(queryMap.get(QueryConstants.ZONE_OBJECT_TYPE_NAME));
            final @NonNull List<Map<String, Object>> queryElements = (List<Map<String, Object>>) Objects.requireNonNull(queryMap.get(QueryConstants.QUERY_ELEMENTS));

            final @NonNull Class<CloudDBZoneObject> clazz = AGCCloudDBUtil.getClass(objectTypeName);
            final @NonNull CloudDBZoneQuery<CloudDBZoneObject> query = CloudDBZoneQuery.where(clazz);

            for (Map<String, Object> queryElement : queryElements) {
                final @NonNull String operation = (String) Objects.requireNonNull(queryElement.get(QueryConstants.OPERATION));
                final @Nullable Object value = queryElement.get(QueryConstants.VALUE);

                switch (operation) {
                    case QueryConstants.START_AT: {
                        startAt(query, objectTypeName, (Map<String, Object>) Objects.requireNonNull(queryElement.get(QueryConstants.ZONE_OBJECT_DATA_ENTRY)));
                        break;
                    }
                    case QueryConstants.START_AFTER: {
                        startAfter(query, objectTypeName, (Map<String, Object>) Objects.requireNonNull(queryElement.get(QueryConstants.ZONE_OBJECT_DATA_ENTRY)));
                        break;
                    }
                    case QueryConstants.END_AT: {
                        endAt(query, objectTypeName, (Map<String, Object>) Objects.requireNonNull(queryElement.get(QueryConstants.ZONE_OBJECT_DATA_ENTRY)));
                        break;
                    }
                    case QueryConstants.END_BEFORE: {
                        endBefore(query, objectTypeName, (Map<String, Object>) Objects.requireNonNull(queryElement.get(QueryConstants.ZONE_OBJECT_DATA_ENTRY)));
                        break;
                    }
                    case QueryConstants.LIMIT: {
                        limit(query, Integer.parseInt(Objects.requireNonNull(value).toString()), queryElement.get(QueryConstants.OFFSET));
                        break;
                    }
                    default: {
                        final @NonNull Field field = clazz.getDeclaredField((String) Objects.requireNonNull(queryElement.get(QueryConstants.FIELD)));
                        AccessController.doPrivileged((PrivilegedAction<Object>) () -> {
                            field.setAccessible(true);
                            return new Object[0];
                        });
                        switch (operation) {
                            case QueryConstants.EQUAL_TO: {
                                equalTo(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.NOT_EQUAL_TO: {
                                notEqualTo(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.LESS_THAN: {
                                lessThan(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.LESS_THAN_OR_EQUAL_TO: {
                                lessThanOrEqualTo(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.GREATER_THAN: {
                                greaterThan(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.GREATER_THAN_OR_EQUAL_TO: {
                                greaterThanOrEqualTo(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.IN: {
                                in(query, field, (List<?>) Objects.requireNonNull(value));
                                break;
                            }
                            case QueryConstants.BEGINS_WITH: {
                                beginsWith(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.ENDS_WITH: {
                                endsWith(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.CONTAINS: {
                                contains(query, field, Objects.requireNonNull(value).toString());
                                break;
                            }
                            case QueryConstants.IS_NULL: {
                                isNull(query, field);
                                break;
                            }
                            case QueryConstants.IS_NOT_NULL: {
                                isNotNull(query, field);
                                break;
                            }
                            case QueryConstants.ORDER_BY_ASC: {
                                orderByAsc(query, field);
                                break;
                            }
                            case QueryConstants.ORDER_BY_DESC: {
                                orderByDesc(query, field);
                                break;
                            }
                            default: {
                                break;
                            }
                        }
                        break;
                    }
                }
            }
            return query;
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw AGCCloudDBException.from(e);
        }
    }

    private static void equalTo(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.equalTo(field.getName(), value);
        } else if (Integer.class.equals(fieldType)) {
            query.equalTo(field.getName(), Integer.parseInt(value));
        } else if (Double.class.equals(fieldType)) {
            query.equalTo(field.getName(), Double.parseDouble(value));
        } else if (Float.class.equals(fieldType)) {
            query.equalTo(field.getName(), Float.parseFloat(value));
        } else if (Short.class.equals(fieldType)) {
            query.equalTo(field.getName(), Short.parseShort(value));
        } else if (Long.class.equals(fieldType)) {
            query.equalTo(field.getName(), Long.parseLong(value));
        } else if (Boolean.class.equals(fieldType)) {
            query.equalTo(field.getName(), Boolean.parseBoolean(value));
        } else if (Text.class.equals(fieldType)) {
            query.equalTo(field.getName(), new Text(value));
        } else if (Date.class.equals(fieldType)) {
            query.equalTo(field.getName(), new Date(Long.parseLong(value)));
        } else if (Byte.class.equals(fieldType)) {
            query.equalTo(field.getName(), Byte.parseByte(value));
        }
    }

    private static void notEqualTo(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), value);
        } else if (Integer.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), Integer.parseInt(value));
        } else if (Double.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), Double.parseDouble(value));
        } else if (Float.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), Float.parseFloat(value));
        } else if (Short.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), Short.parseShort(value));
        } else if (Long.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), Long.parseLong(value));
        } else if (Boolean.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), Boolean.parseBoolean(value));
        } else if (Text.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), new Text(value));
        } else if (Date.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), new Date(Long.parseLong(value)));
        } else if (Byte.class.equals(fieldType)) {
            query.notEqualTo(field.getName(), Byte.parseByte(value));
        }
    }

    private static void lessThan(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.lessThan(field.getName(), value);
        } else if (Integer.class.equals(fieldType)) {
            query.lessThan(field.getName(), Integer.parseInt(value));
        } else if (Double.class.equals(fieldType)) {
            query.lessThan(field.getName(), Double.parseDouble(value));
        } else if (Float.class.equals(fieldType)) {
            query.lessThan(field.getName(), Float.parseFloat(value));
        } else if (Short.class.equals(fieldType)) {
            query.lessThan(field.getName(), Short.parseShort(value));
        } else if (Long.class.equals(fieldType)) {
            query.lessThan(field.getName(), Long.parseLong(value));
        } else if (Text.class.equals(fieldType)) {
            query.lessThan(field.getName(), new Text(value));
        } else if (Date.class.equals(fieldType)) {
            query.lessThan(field.getName(), new Date(Long.parseLong(value)));
        } else if (Byte.class.equals(fieldType)) {
            query.lessThan(field.getName(), Byte.parseByte(value));
        }
    }

    private static void lessThanOrEqualTo(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), value);
        } else if (Integer.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), Integer.parseInt(value));
        } else if (Double.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), Double.parseDouble(value));
        } else if (Float.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), Float.parseFloat(value));
        } else if (Short.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), Short.parseShort(value));
        } else if (Long.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), Long.parseLong(value));
        } else if (Text.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), new Text(value));
        } else if (Date.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), new Date(Long.parseLong(value)));
        } else if (Byte.class.equals(fieldType)) {
            query.lessThanOrEqualTo(field.getName(), Byte.parseByte(value));
        }
    }

    private static void greaterThan(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.greaterThan(field.getName(), value);
        } else if (Integer.class.equals(fieldType)) {
            query.greaterThan(field.getName(), Integer.parseInt(value));
        } else if (Double.class.equals(fieldType)) {
            query.greaterThan(field.getName(), Double.parseDouble(value));
        } else if (Float.class.equals(fieldType)) {
            query.greaterThan(field.getName(), Float.parseFloat(value));
        } else if (Short.class.equals(fieldType)) {
            query.greaterThan(field.getName(), Short.parseShort(value));
        } else if (Long.class.equals(fieldType)) {
            query.greaterThan(field.getName(), Long.parseLong(value));
        } else if (Text.class.equals(fieldType)) {
            query.greaterThan(field.getName(), new Text(value));
        } else if (Date.class.equals(fieldType)) {
            query.greaterThan(field.getName(), new Date(Long.parseLong(value)));
        } else if (Byte.class.equals(fieldType)) {
            query.greaterThan(field.getName(), Byte.parseByte(value));
        }
    }

    private static void greaterThanOrEqualTo(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), value);
        } else if (Integer.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), Integer.parseInt(value));
        } else if (Double.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), Double.parseDouble(value));
        } else if (Float.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), Float.parseFloat(value));
        } else if (Short.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), Short.parseShort(value));
        } else if (Long.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), Long.parseLong(value));
        } else if (Text.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), new Text(value));
        } else if (Date.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), new Date(Long.parseLong(value)));
        } else if (Byte.class.equals(fieldType)) {
            query.greaterThanOrEqualTo(field.getName(), Byte.parseByte(value));
        }
    }

    private static void in(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull List<?> value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            String[] arr = new String[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = value.get(i).toString();
            }
            query.in(field.getName(), arr);
        } else if (Integer.class.equals(fieldType)) {
            Integer[] arr = new Integer[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = Integer.parseInt(value.get(i).toString());
            }
            query.in(field.getName(), arr);
        } else if (Double.class.equals(fieldType)) {
            Double[] arr = new Double[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = Double.parseDouble(value.get(i).toString());
            }
            query.in(field.getName(), arr);
        } else if (Float.class.equals(fieldType)) {
            Float[] arr = new Float[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = Float.parseFloat(value.get(i).toString());
            }
            query.in(field.getName(), arr);
        } else if (Short.class.equals(fieldType)) {
            Short[] arr = new Short[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = Short.parseShort(value.get(i).toString());
            }
            query.in(field.getName(), arr);
        } else if (Long.class.equals(fieldType)) {
            Long[] arr = new Long[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = Long.parseLong(value.get(i).toString());
            }
            query.in(field.getName(), arr);
        } else if (Text.class.equals(fieldType)) {
            Text[] arr = new Text[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = new Text(value.get(i).toString());
            }
            query.in(field.getName(), arr);
        } else if (Date.class.equals(fieldType)) {
            Date[] arr = new Date[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = new Date(Long.parseLong(value.get(i).toString()));
            }
            query.in(field.getName(), arr);
        } else if (Byte.class.equals(fieldType)) {
            Byte[] arr = new Byte[value.size()];
            for (int i = 0; i < arr.length; i++) {
                arr[i] = Byte.parseByte(value.get(i).toString());
            }
            query.in(field.getName(), arr);
        }
    }

    private static void beginsWith(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.beginsWith(field.getName(), value);
        } else if (Text.class.equals(fieldType)) {
            query.beginsWith(field.getName(), new Text(value));
        }
    }

    private static void endsWith(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.endsWith(field.getName(), value);
        } else if (Text.class.equals(fieldType)) {
            query.endsWith(field.getName(), new Text(value));
        }
    }

    private static void contains(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field, @NonNull String value) {
        final Class<?> fieldType = field.getType();

        if (String.class.equals(fieldType)) {
            query.contains(field.getName(), value);
        } else if (Text.class.equals(fieldType)) {
            query.contains(field.getName(), new Text(value));
        }
    }

    private static void isNull(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field) {
        query.isNull(field.getName());
    }

    private static void isNotNull(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field) {
        query.isNotNull(field.getName());
    }

    private static void orderByAsc(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field) {
        query.orderByAsc(field.getName());
    }

    private static void orderByDesc(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Field field) {
        query.orderByDesc(field.getName());
    }

    private static void startAt(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull String zoneObjectTypeName, @NonNull Map<String, Object> zoneObjectDataEntry)
            throws InstantiationException, IllegalAccessException, ClassNotFoundException {
        query.startAt(AGCCloudDBZoneObjectUtil.fromMap(zoneObjectTypeName, zoneObjectDataEntry));
    }

    private static void startAfter(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull String zoneObjectTypeName, @NonNull Map<String, Object> zoneObjectDataEntry)
            throws InstantiationException, IllegalAccessException, ClassNotFoundException {
        query.startAfter(AGCCloudDBZoneObjectUtil.fromMap(zoneObjectTypeName, zoneObjectDataEntry));
    }

    private static void endAt(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull String zoneObjectTypeName, @NonNull Map<String, Object> zoneObjectDataEntry)
            throws InstantiationException, IllegalAccessException, ClassNotFoundException {
        query.endAt(AGCCloudDBZoneObjectUtil.fromMap(zoneObjectTypeName, zoneObjectDataEntry));
    }

    private static void endBefore(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull String zoneObjectTypeName, @NonNull Map<String, Object> zoneObjectDataEntry)
            throws InstantiationException, IllegalAccessException, ClassNotFoundException {
        query.endBefore(AGCCloudDBZoneObjectUtil.fromMap(zoneObjectTypeName, zoneObjectDataEntry));
    }

    private static void limit(@NonNull CloudDBZoneQuery<CloudDBZoneObject> query, @NonNull Integer value, @Nullable Object offset) {
        if (offset == null) {
            query.limit(value);
        } else {
            query.limit(value, Integer.parseInt(offset.toString()));
        }
    }
}
