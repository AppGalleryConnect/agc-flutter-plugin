/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2023. All rights reserved.
 */

package com.huawei.agconnectclouddb.modules;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.cloud.database.AGConnectCloudDB;
import com.huawei.agconnect.cloud.database.CloudDBZone;
import com.huawei.agconnect.cloud.database.CloudDBZoneConfig;
import com.huawei.agconnect.cloud.database.CloudDBZoneObject;
import com.huawei.agconnect.cloud.database.CloudDBZoneObjectList;
import com.huawei.agconnect.cloud.database.CloudDBZoneQuery;
import com.huawei.agconnect.cloud.database.CloudDBZoneQuery.CloudDBZoneQueryPolicy;
import com.huawei.agconnect.cloud.database.CloudDBZoneSnapshot;
import com.huawei.agconnect.cloud.database.ListenerHandler;
import com.huawei.agconnect.cloud.database.ServerStatus;
import com.huawei.agconnect.cloud.database.exceptions.AGConnectCloudDBException;
import com.huawei.agconnectclouddb.constants.KeyConstants;
import com.huawei.agconnectclouddb.constants.TransactionConstants;
import com.huawei.agconnectclouddb.exception.AGCCloudDBException;
import com.huawei.agconnectclouddb.objecttypes.ObjectTypeInfoHelper;
import com.huawei.agconnectclouddb.utils.AGCCloudDBQueryBuilder;
import com.huawei.agconnectclouddb.utils.AGCCloudDBZoneConfigUtil;
import com.huawei.agconnectclouddb.utils.AGCCloudDBZoneObjectUtil;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGCCloudDBModule {
    private static volatile AGCCloudDBModule instance;
    private final BinaryMessenger binaryMessenger;
    private final Map<String, CloudDBZone> cloudDBZones = new HashMap<>();

    private AGCCloudDBModule(BinaryMessenger binaryMessenger) {
        this.binaryMessenger = binaryMessenger;
    }

    public static AGCCloudDBModule getInstance(BinaryMessenger binaryMessenger, Activity activity) throws AGCCloudDBException {
        if (instance == null) {
            try {
                instance = new AGCCloudDBModule(binaryMessenger);
            } catch (RuntimeException e) {
                throw AGCCloudDBException.from(e);
            }
        }
        return instance;
    }

    public void initialize(@NonNull Result result, Activity activity) {
        AGConnectCloudDB.initialize(activity.getApplicationContext());
        result.success(true);
    }

    public void createObjectType(@NonNull Result result) throws AGCCloudDBException {
        try {
            AGConnectCloudDB.getInstance().createObjectType(ObjectTypeInfoHelper.getObjectTypeInfo());
            result.success(true);
        } catch (RuntimeException | AGConnectCloudDBException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void getCloudDBZoneConfigs(@NonNull Result result) throws AGCCloudDBException {
        try {
            final List<CloudDBZoneConfig> zoneConfigList = AGConnectCloudDB.getInstance().getCloudDBZoneConfigs();

            final List<Map<String, Object>> resultList = new ArrayList<>();
            for (CloudDBZoneConfig zoneConfig : zoneConfigList) {
                resultList.add(AGCCloudDBZoneConfigUtil.toMap(zoneConfig));
            }
            result.success(resultList);
        } catch (Exception e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void openCloudDBZone(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final Map<String, Object> zoneConfigMap = Objects.requireNonNull(call.argument(KeyConstants.ZONE_CONFIG));
            final boolean isAllowToCreate = Objects.requireNonNull(call.argument(KeyConstants.IS_ALLOW_TO_CREATE));

            final CloudDBZoneConfig cloudDBZoneConfig = AGCCloudDBZoneConfigUtil.fromMap(zoneConfigMap);

            final CloudDBZone zone = AGConnectCloudDB.getInstance().openCloudDBZone(cloudDBZoneConfig, isAllowToCreate);
            final String zoneId = getUniqueZoneId();
            cloudDBZones.put(zoneId, zone);
            result.success(Collections.singletonMap(KeyConstants.ZONE_ID, zoneId));
        } catch (RuntimeException | AGConnectCloudDBException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void openCloudDBZone2(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final Map<String, Object> zoneConfigMap = Objects.requireNonNull(call.argument(KeyConstants.ZONE_CONFIG));
            final boolean isAllowToCreate = Objects.requireNonNull(call.argument(KeyConstants.IS_ALLOW_TO_CREATE));

            final CloudDBZoneConfig cloudDBZoneConfig = AGCCloudDBZoneConfigUtil.fromMap(zoneConfigMap);

            AGConnectCloudDB.getInstance().openCloudDBZone2(cloudDBZoneConfig, isAllowToCreate)
                    .addOnSuccessListener(zone -> {
                        final String zoneId = getUniqueZoneId();
                        cloudDBZones.put(zoneId, zone);
                        result.success(Collections.singletonMap(KeyConstants.ZONE_ID, zoneId));
                    })
                    .addOnFailureListener(e -> returnException(result, e));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void closeCloudDBZone(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final String zoneId = Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID));

            AGConnectCloudDB.getInstance().closeCloudDBZone(getCloudDBZone(zoneId));
            cloudDBZones.remove(zoneId);
            result.success(true);
        } catch (RuntimeException | AGConnectCloudDBException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void deleteCloudDBZone(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final String zoneName = Objects.requireNonNull(call.argument(KeyConstants.ZONE_NAME));

            AGConnectCloudDB.getInstance().deleteCloudDBZone(zoneName);
            result.success(true);
        } catch (Exception e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void enableNetwork(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final String zoneName = Objects.requireNonNull(call.argument(KeyConstants.ZONE_NAME));

            AGConnectCloudDB.getInstance().enableNetwork(zoneName);
            result.success(true);
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void disableNetwork(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final String zoneName = Objects.requireNonNull(call.argument(KeyConstants.ZONE_NAME));

            AGConnectCloudDB.getInstance().disableNetwork(zoneName);
            result.success(true);
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void setUserKey(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final String userKey = Objects.requireNonNull(call.argument(KeyConstants.USER_KEY));
            final @Nullable String userReKey = call.argument(KeyConstants.USER_RE_KEY);
            final @Nullable boolean needStrongCheck = call.argument(KeyConstants.NEED_STRONG_CHECK);

            AGConnectCloudDB.getInstance().setUserKey(userKey, userReKey,needStrongCheck)
                    .addOnSuccessListener(aBoolean -> result.success(true))
                    .addOnFailureListener(e -> returnException(result, e));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void updateDataEncryptionKey(@NonNull Result result) throws AGCCloudDBException {
        try {
            AGConnectCloudDB.getInstance().updateDataEncryptionKey()
                    .addOnSuccessListener(aBoolean -> result.success(true))
                    .addOnFailureListener(e -> returnException(result, e));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void getCloudDBZoneConfig(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            result.success(AGCCloudDBZoneConfigUtil.toMap(zone.getCloudDBZoneConfig()));
        } catch (Exception e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeUpsert(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final String zoneObjectTypeName = Objects.requireNonNull(call.argument(KeyConstants.ZONE_OBJECT_TYPE_NAME));
            final List<Map<String, Object>> zoneObjectMapList = Objects.requireNonNull(call.argument(KeyConstants.ZONE_OBJECT_DATA_ENTRIES));

            final List<CloudDBZoneObject> zoneObjectList = new ArrayList<>();
            for (Map<String, Object> zoneObjectMap : zoneObjectMapList) {
                zoneObjectList.add(AGCCloudDBZoneObjectUtil.fromMap(zoneObjectTypeName, zoneObjectMap));
            }
            zone.executeUpsert(zoneObjectList)
                    .addOnSuccessListener(result::success)
                    .addOnFailureListener(e -> returnException(result, e));
        } catch (RuntimeException | IllegalAccessException | InstantiationException | ClassNotFoundException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeDelete(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final String zoneObjectTypeName = Objects.requireNonNull(call.argument(KeyConstants.ZONE_OBJECT_TYPE_NAME));
            final List<Map<String, Object>> zoneObjectMapList = Objects.requireNonNull(call.argument(KeyConstants.ZONE_OBJECT_DATA_ENTRIES));

            final List<CloudDBZoneObject> zoneObjectList = new ArrayList<>();
            for (Map<String, Object> zoneObjectMap : zoneObjectMapList) {
                zoneObjectList.add(AGCCloudDBZoneObjectUtil.fromMap(zoneObjectTypeName, zoneObjectMap));
            }
            zone.executeDelete(zoneObjectList)
                    .addOnSuccessListener(result::success)
                    .addOnFailureListener(e -> returnException(result, e));
        } catch (RuntimeException | IllegalAccessException | InstantiationException | ClassNotFoundException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeQuery(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final CloudDBZoneQuery<CloudDBZoneObject> query = AGCCloudDBQueryBuilder.build(Objects.requireNonNull(call.argument(KeyConstants.QUERY)));
            final CloudDBZoneQueryPolicy policy = CloudDBZoneQueryPolicy.values()[(int) Objects.requireNonNull(call.argument(KeyConstants.POLICY_INDEX))];

            zone.executeQuery(query, policy)
                    .addOnSuccessListener(snapshot -> {
                        try {
                            final Map<String, Object> queryResultMap = resolveSnapshot(snapshot);
                            result.success(queryResultMap);
                        } catch (RuntimeException | AGConnectCloudDBException | IllegalAccessException e) {
                            returnException(result, e);
                        } finally {
                            snapshot.release();
                        }
                    })
                    .addOnFailureListener(e -> returnException(result, e));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeAverageQuery(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final String field = Objects.requireNonNull(call.argument(KeyConstants.FIELD));
            final CloudDBZoneQuery<CloudDBZoneObject> query = AGCCloudDBQueryBuilder.build(Objects.requireNonNull(call.argument(KeyConstants.QUERY)));
            final CloudDBZoneQueryPolicy policy = CloudDBZoneQueryPolicy.values()[(int) Objects.requireNonNull(call.argument(KeyConstants.POLICY_INDEX))];

            zone.executeAverageQuery(query, field, policy)
                    .addOnSuccessListener(result::success)
                    .addOnFailureListener(averageException -> returnException(result, averageException));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeSumQuery(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final String field = Objects.requireNonNull(call.argument(KeyConstants.FIELD));
            final CloudDBZoneQuery<CloudDBZoneObject> query = AGCCloudDBQueryBuilder.build(Objects.requireNonNull(call.argument(KeyConstants.QUERY)));
            final CloudDBZoneQueryPolicy policy = CloudDBZoneQueryPolicy.values()[(int) Objects.requireNonNull(call.argument(KeyConstants.POLICY_INDEX))];

            zone.executeSumQuery(query, field, policy)
                    .addOnSuccessListener(result::success)
                    .addOnFailureListener(sumException -> returnException(result, sumException));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeMaximumQuery(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final String field = Objects.requireNonNull(call.argument(KeyConstants.FIELD));
            final CloudDBZoneQuery<CloudDBZoneObject> query = AGCCloudDBQueryBuilder.build(Objects.requireNonNull(call.argument(KeyConstants.QUERY)));
            final CloudDBZoneQueryPolicy policy = CloudDBZoneQueryPolicy.values()[(int) Objects.requireNonNull(call.argument(KeyConstants.POLICY_INDEX))];

            zone.executeMaximumQuery(query, field, policy)
                    .addOnSuccessListener(result::success)
                    .addOnFailureListener(maximumException -> returnException(result, maximumException));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeMinimalQuery(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final String field = Objects.requireNonNull(call.argument(KeyConstants.FIELD));
            final CloudDBZoneQuery<CloudDBZoneObject> query = AGCCloudDBQueryBuilder.build(Objects.requireNonNull(call.argument(KeyConstants.QUERY)));
            final CloudDBZoneQueryPolicy policy = CloudDBZoneQueryPolicy.values()[(int) Objects.requireNonNull(call.argument(KeyConstants.POLICY_INDEX))];

            zone.executeMinimalQuery(query, field, policy)
                    .addOnSuccessListener(result::success)
                    .addOnFailureListener(minimalException -> returnException(result, minimalException));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeCountQuery(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final String field = Objects.requireNonNull(call.argument(KeyConstants.FIELD));
            final CloudDBZoneQuery<CloudDBZoneObject> query = AGCCloudDBQueryBuilder.build(Objects.requireNonNull(call.argument(KeyConstants.QUERY)));
            final CloudDBZoneQueryPolicy policy = CloudDBZoneQueryPolicy.values()[(int) Objects.requireNonNull(call.argument(KeyConstants.POLICY_INDEX))];

            zone.executeCountQuery(query, field, policy)
                    .addOnSuccessListener(result::success)
                    .addOnFailureListener(countException -> returnException(result, countException));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeQueryUnsynced(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final CloudDBZoneQuery<CloudDBZoneObject> query = AGCCloudDBQueryBuilder.build(Objects.requireNonNull(call.argument(KeyConstants.QUERY)));

            zone.executeQueryUnsynced(query)
                    .addOnSuccessListener(snapshot -> {
                        try {
                            final Map<String, Object> queryUnsyncResultMap = resolveSnapshot(snapshot);
                            result.success(queryUnsyncResultMap);
                        } catch (RuntimeException | AGConnectCloudDBException | IllegalAccessException e2) {
                            returnException(result, e2);
                        } finally {
                            snapshot.release();
                        }
                    })
                    .addOnFailureListener(e1 -> returnException(result, e1));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void executeServerStatusQuery(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            zone.executeServerStatusQuery()
                    .addOnSuccessListener(serverStatus -> {
                        final Map<String, Object> serverStatusQueryResultMap = resolveServerStatus(serverStatus);
                        result.success(serverStatusQueryResultMap);
                    })
                    .addOnFailureListener(e1 -> returnException(result, e1));
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void runTransaction(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final List<Map<String, Object>> transactionElements = Objects.requireNonNull(call.argument(KeyConstants.TRANSACTION_ELEMENTS));

            zone.runTransaction(transaction -> {
                try {
                    for (Map<String, Object> transactionElement : transactionElements) {
                        final String operation = (String) Objects.requireNonNull(transactionElement.get(TransactionConstants.OPERATION));
                        final String objectTypeName = (String) Objects.requireNonNull(transactionElement.get(TransactionConstants.ZONE_OBJECT_TYPE_NAME));
                        final List<Map<String, Object>> zoneObjectMapList = (List<Map<String, Object>>) Objects.requireNonNull(transactionElement.get(TransactionConstants.ZONE_OBJECT_DATA_ENTRIES));

                        final List<CloudDBZoneObject> zoneObjectList = new ArrayList<>();
                        for (Map<String, Object> zoneObjectMap : zoneObjectMapList) {
                            zoneObjectList.add(AGCCloudDBZoneObjectUtil.fromMap(objectTypeName, zoneObjectMap));
                        }
                        switch (operation) {
                            case TransactionConstants.EXECUTE_UPSERT: {
                                transaction.executeUpsert(zoneObjectList);
                                break;
                            }
                            case TransactionConstants.EXECUTE_DELETE: {
                                transaction.executeDelete(zoneObjectList);
                                break;
                            }
                            default: {
                                break;
                            }
                        }
                    }
                    new Handler(Looper.getMainLooper()).post(() -> result.success(true));
                    return true;
                } catch (RuntimeException | IllegalAccessException | InstantiationException | ClassNotFoundException e) {
                    new Handler(Looper.getMainLooper()).post(() -> returnException(result, e));
                    return false;
                }
            });
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    public void subscribeSnapshot(@NonNull MethodCall call, @NonNull Result result) throws AGCCloudDBException {
        try {
            final CloudDBZone zone = getCloudDBZone(Objects.requireNonNull(call.argument(KeyConstants.ZONE_ID)));
            final CloudDBZoneQuery<CloudDBZoneObject> query = AGCCloudDBQueryBuilder.build(Objects.requireNonNull(call.argument(KeyConstants.QUERY)));
            final CloudDBZoneQueryPolicy policy = CloudDBZoneQueryPolicy.values()[(int) Objects.requireNonNull(call.argument(KeyConstants.POLICY_INDEX))];
            final String eventChannelName = Objects.requireNonNull(call.argument(KeyConstants.EVENT_CHANNEL_NAME));

            final EventChannel eventChannel = new EventChannel(this.binaryMessenger, eventChannelName);
            result.success(true);

            final ListenerHandler[] handler = new ListenerHandler[1];
            eventChannel.setStreamHandler(new StreamHandler() {
                @Override
                public void onListen(Object arguments, EventSink eventSink) {
                    try {
                        handler[0] = zone.subscribeSnapshot(query, policy, (snapshot, e2) -> {
                            if (snapshot != null) {
                                try {
                                    final Map<String, Object> resultMap = resolveSnapshot(snapshot);
                                    new Handler(Looper.getMainLooper()).post(() -> eventSink.success(resultMap));
                                } catch (RuntimeException | AGConnectCloudDBException | IllegalAccessException e) {
                                    new Handler(Looper.getMainLooper()).post(() -> returnException(eventSink, e));
                                } finally {
                                    snapshot.release();
                                }
                            } else {
                                new Handler(Looper.getMainLooper()).post(() -> returnException(eventSink, e2));
                            }
                        });
                    } catch (RuntimeException | AGConnectCloudDBException e) {
                        returnException(eventSink, e);
                    }
                }

                @Override
                public void onCancel(Object arguments) {
                    if (handler[0] != null) {
                        handler[0].remove();
                    }
                }
            });
        } catch (RuntimeException e) {
            throw AGCCloudDBException.from(e);
        }
    }

    
    private void returnException(@NonNull Result result, Exception e) {
        final AGCCloudDBException exception = AGCCloudDBException.from(e);
        result.error(exception.getErrorCode(), exception.getErrorMessage(), exception.getErrorDetails());
    }

    private void returnException(@NonNull EventSink eventSink, Exception e) {
        final AGCCloudDBException exception = AGCCloudDBException.from(e);
        eventSink.error(exception.getErrorCode(), exception.getErrorMessage(), exception.getErrorDetails());
    }

    private CloudDBZone getCloudDBZone(String zoneId) throws AGCCloudDBException {
        if (cloudDBZones.containsKey(zoneId)) {
            return cloudDBZones.get(zoneId);
        } else {
            throw new AGCCloudDBException("ZONE_NOT_FOUND", String.format(Locale.ENGLISH, "CloudDBZone (id:%s) not found, first try to open it.", zoneId));
        }
    }

    private String getUniqueZoneId() {
        while (true) {
            final int randomZoneId = new SecureRandom().nextInt(1000000);
            if (!cloudDBZones.containsKey(String.valueOf(randomZoneId))) {
                return String.valueOf(randomZoneId);
            }
        }
    }

    private Map<String, Object> resolveServerStatus(ServerStatus serverStatus){
        final Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("serverTimeStamp",serverStatus.getServerTimestamp());
        return resultMap;
    }

    private Map<String, Object> resolveSnapshot(CloudDBZoneSnapshot<CloudDBZoneObject> snapshot) throws AGConnectCloudDBException, IllegalAccessException {
        final Map<String, Object> resultMap = new HashMap<>();

        resultMap.put(KeyConstants.IS_FROM_CLOUD, snapshot.isFromCloud());
        resultMap.put(KeyConstants.HAS_PENDING_WRITES, snapshot.hasPendingWrites());

        final List<Map<String, Object>> snapshotObjectsResult = new ArrayList<>();
        final CloudDBZoneObjectList<CloudDBZoneObject> snapshotObjects = snapshot.getSnapshotObjects();
        if (snapshotObjects != null) {
            while (snapshotObjects.hasNext()) {
                snapshotObjectsResult.add(AGCCloudDBZoneObjectUtil.toMap(snapshotObjects.next()));
            }
        }
        resultMap.put(KeyConstants.SNAPSHOT_OBJECTS, snapshotObjectsResult);

        final List<Map<String, Object>> upsertedObjectsResult = new ArrayList<>();
        final CloudDBZoneObjectList<CloudDBZoneObject> upsertedObjects = snapshot.getUpsertedObjects();
        if (upsertedObjects != null) {
            while (upsertedObjects.hasNext()) {
                upsertedObjectsResult.add(AGCCloudDBZoneObjectUtil.toMap(upsertedObjects.next()));
            }
        }
        resultMap.put(KeyConstants.UPSERTED_OBJECTS, upsertedObjectsResult);

        final List<Map<String, Object>> deletedObjectsResult = new ArrayList<>();
        final CloudDBZoneObjectList<CloudDBZoneObject> deletedObjects = snapshot.getDeletedObjects();
        if (deletedObjects != null) {
            while (deletedObjects.hasNext()) {
                deletedObjectsResult.add(AGCCloudDBZoneObjectUtil.toMap(deletedObjects.next()));
            }
        }
        resultMap.put(KeyConstants.DELETED_OBJECTS, deletedObjectsResult);

        return resultMap;
    }
}
