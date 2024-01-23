/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2023. All rights reserved.
 */

package com.huawei.agconnectclouddb.handlers;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.huawei.agconnectclouddb.constants.MethodConstants;
import com.huawei.agconnectclouddb.exception.AGCCloudDBException;
import com.huawei.agconnectclouddb.modules.AGCCloudDBModule;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MethodHandler implements MethodCallHandler {
    private final BinaryMessenger binaryMessenger;
    private final Activity activity;

    public MethodHandler(BinaryMessenger binaryMessenger, Activity activity) {
        this.binaryMessenger = binaryMessenger;
        this.activity = activity;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            final AGCCloudDBModule module = AGCCloudDBModule.getInstance(binaryMessenger, activity);
            switch (call.method) {
                case MethodConstants.INITIALIZE:
                   module.initialize(result,activity);
                    break;
                case MethodConstants.CREATE_OBJECT_TYPE:
                    module.createObjectType(result);
                    break;
                case MethodConstants.GET_CLOUD_DB_ZONE_CONFIGS:
                    module.getCloudDBZoneConfigs(result);
                    break;
                case MethodConstants.OPEN_CLOUD_DB_ZONE:
                    module.openCloudDBZone(call, result);
                    break;
                case MethodConstants.OPEN_CLOUD_DB_ZONE_2:
                    module.openCloudDBZone2(call, result);
                    break;
                case MethodConstants.CLOSE_CLOUD_DB_ZONE:
                    module.closeCloudDBZone(call, result);
                    break;
                case MethodConstants.DELETE_CLOUD_DB_ZONE:
                    module.deleteCloudDBZone(call, result);
                    break;
                case MethodConstants.ENABLE_NETWORK:
                    module.enableNetwork(call, result);
                    break;
                case MethodConstants.DISABLE_NETWORK:
                    module.disableNetwork(call, result);
                    break;
                case MethodConstants.SET_USER_KEY:
                    module.setUserKey(call, result);
                    break;
                case MethodConstants.UPDATE_DATA_ENCRYPTION_KEY:
                    module.updateDataEncryptionKey(result);
                    break;
                case MethodConstants.GET_CLOUD_DB_ZONE_CONFIG:
                    module.getCloudDBZoneConfig(call, result);
                    break;
                case MethodConstants.EXECUTE_UPSERT:
                    module.executeUpsert(call, result);
                    break;
                case MethodConstants.EXECUTE_DELETE:
                    module.executeDelete(call, result);
                    break;
                case MethodConstants.EXECUTE_QUERY:
                    module.executeQuery(call, result);
                    break;
                case MethodConstants.EXECUTE_AVERAGE_QUERY:
                    module.executeAverageQuery(call, result);
                    break;
                case MethodConstants.EXECUTE_SUM_QUERY:
                    module.executeSumQuery(call, result);
                    break;
                case MethodConstants.EXECUTE_MAXIMUM_QUERY:
                    module.executeMaximumQuery(call, result);
                    break;
                case MethodConstants.EXECUTE_MINIMAL_QUERY:
                    module.executeMinimalQuery(call, result);
                    break;
                case MethodConstants.EXECUTE_COUNT_QUERY:
                    module.executeCountQuery(call, result);
                    break;
                case MethodConstants.EXECUTE_QUERY_UNSYNCED:
                    module.executeQueryUnsynced(call, result);
                    break;
                case MethodConstants.EXECUTE_SERVER_STATUS_QUERY:
                    module.executeServerStatusQuery(call, result);
                    break;
                case MethodConstants.RUN_TRANSACTION:
                    module.runTransaction(call, result);
                    break;
                case MethodConstants.SUBSCRIBE_SNAPSHOT:
                    module.subscribeSnapshot(call, result);
                    break;
                default:
                    result.notImplemented();
            }
        } catch (RuntimeException | AGCCloudDBException e) {
            final AGCCloudDBException exception = AGCCloudDBException.from(e);
            result.error(exception.getErrorCode(), exception.getErrorMessage(), exception.getErrorDetails());
        }
    }
}
