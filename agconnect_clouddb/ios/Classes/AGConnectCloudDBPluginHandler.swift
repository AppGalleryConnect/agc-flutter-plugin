/*
 * Copyright (c) 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

import Flutter
import UIKit
import AGConnectCore

public class AGConnectCloudDBPluginHandler: NSObject, FlutterPlugin {
    
    let agconnectCloud = AGConnectCloudDBFlutter.init()
    let method = Methods.init()
    var methodChannel: FlutterMethodChannel?
    var binaryMessenger: FlutterBinaryMessenger?
    let dataEncryptionKeyEventChannelHandler = AddDataEncryptionKeyEventHandler.init()
    let onEventEventChannelHandler = AddEventListenerEventHandler.init()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "com.huawei.agconnectclouddb/methodChannel/", binaryMessenger: registrar.messenger())
        
        let instance = AGConnectCloudDBPluginHandler()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        instance.binaryMessenger = registrar.messenger()
        
        let dataEncryptionKeyEventChannel = FlutterEventChannel(name: "com.huawei.agconnectclouddb/eventChannel/onDataEncryptionKeyChange", binaryMessenger:
                                                                    registrar.messenger())
        let onEventEventChannel = FlutterEventChannel(name: "com.huawei.agconnectclouddb/eventChannel/onEvent", binaryMessenger:
                                                        registrar.messenger())
        dataEncryptionKeyEventChannel.setStreamHandler(instance.dataEncryptionKeyEventChannelHandler)
        onEventEventChannel.setStreamHandler(instance.onEventEventChannelHandler)
        registrar.addApplicationDelegate(instance)
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        AGCInstance.startUp()
        
        return true
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            return
        }
        print(call.method)
        switch call.method {
        case method.INITIALIZE:
            
            agconnectCloud.initialize({ (response) in
                result(response)
            })
        case method.GET_CLOUD_DB_ZONE_CONFIGS:
            
            agconnectCloud.getCloudDBZoneConfigs({ (response) in
                result(response)
            })
        case method.CREATE_OBJECT_TYPE:
            
            agconnectCloud.createObjectType({ (response) in
                result(response)
            })
        case method.OPEN_CLOUD_DB_ZONE:
            guard let isAllowToCreate = args["isAllowToCreate"] as? Bool else { return  }
            guard let map = args["zoneConfig"] as? [String: Any] else { return  }
            agconnectCloud.openCloudDBZone(map, isAllowToCreate: isAllowToCreate, resolve: { (response) in
                result(response)
            })
        case method.OPEN_CLOUD_DB_ZONE2:
            
            guard let isAllowToCreate = args["isAllowToCreate"] as? Bool else { return  }
            guard let map = args["zoneConfig"] as? [String: Any] else { return  }
            agconnectCloud.openCloudDBZone2(map, isAllowToCreate: isAllowToCreate, resolve: { (response) in
                result(response)
            })
        case method.CLOSE_CLOUD_DB_ZONE:
            guard let zoneId = args["zoneId"] as? String else {
                return
            }
            agconnectCloud.closeCloudDB(zoneId, resolve: { (response) in
                result(response)
            })
        case method.DELETE_CLOUD_DB_ZONE:
            guard let zoneName = args["zoneName"] as? String else {
                return
            }
            agconnectCloud.deleteCloudDB(zoneName: zoneName, resolve: { (response) in
                result(response)
            })
        case method.ENABLE_NETWORK:
            guard let zoneName = args["zoneName"] as? String else {
                return
            }
            agconnectCloud.enableNetwork(zoneName, resolve: { (response) in
                result(response)
            })
        case method.DISABLE_NETWORK:
            guard let zoneName = args["zoneName"] as? String else {
                return
            }
            agconnectCloud.disableNetwork(zoneName, resolve: { (response) in
                result(response)
            })
        case method.SET_USER_KEY:
            guard let userReKey = args["userReKey"] as? String else { return  }
            guard let userKey = args["userKey"] as? String else { return  }
            agconnectCloud.setUserKey(userKey: userKey, userReKey: userReKey, resolve: { (response) in
                result(response)
            })
        case method.UPDATE_DATA_ENCRYPTION_KEY:
            agconnectCloud.updateDataEncryptionKey({ (response) in
                result(response)
            })
        case method.EXECUTE_UPSERT:
            guard let className = args["zoneObjectTypeName"] as? String else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            guard let objectArray = args["zoneObjectDataEntries"] as? [Any] else { return  }
            agconnectCloud.executeUpsert(className, objectArray: objectArray, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_DELETE:
            guard let className = args["zoneObjectTypeName"] as? String else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            guard let objectArray = args["zoneObjectDataEntries"] as? [Any] else { return  }
            agconnectCloud.executeDelete(className, objectArray: objectArray, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_QUERY:
            guard let query = args["query"] as? [String: Any] else { return  }
            guard let policy = args["policyIndex"] as? Int else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            agconnectCloud.executeQuery(query, policy: policy+1, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_AVERAGE_QUERY:
            guard let query = args["query"] as? [String: Any] else { return  }
            guard let policy = args["policyIndex"] as? Int else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            guard let field = args["field"] as? String else { return  }
            agconnectCloud.executeAverageQuery(query, withFieldName: field, policy: policy+1, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_SUM_QUERY:
            guard let query = args["query"] as? [String: Any] else { return  }
            guard let policy = args["policyIndex"] as? Int else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            guard let field = args["field"] as? String else { return  }
            agconnectCloud.executeSumQuery(query, withFieldName: field, policy: policy+1, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_MAXIMUM_QUERY:
            guard let query = args["query"] as? [String: Any] else { return  }
            guard let policy = args["policyIndex"] as? Int else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            guard let field = args["field"] as? String else { return  }
            agconnectCloud.executeMaximumQuery(query, withFieldName: field, policy: policy+1, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_MINIMAL_QUERY:
            guard let query = args["query"] as? [String: Any] else { return  }
            guard let policy = args["policyIndex"] as? Int else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            guard let field = args["field"] as? String else { return  }
            agconnectCloud.executeMinimalQuery(query, withFieldName: field, policy: policy+1, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_COUNT_QUERY:
            guard let query = args["query"] as? [String: Any] else { return  }
            guard let policy = args["policyIndex"] as? Int else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            guard let field = args["field"] as? String else { return  }
            agconnectCloud.executeCountQuery(query, withFieldName: field, policy: policy+1, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_QUERY_UNSYNCED:
            guard let query = args["query"] as? [String: Any] else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            agconnectCloud.executeQueryUnsynced(query, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.EXECUTE_SERVER_STATUS_QUERY:
            guard let zoneId = args["zoneId"] as? String else { return  }
            agconnectCloud.executeServerStatusQuery(zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.RUN_TRANSACTION:
            guard let transactions = args["transactionElements"] as? NSMutableArray else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            agconnectCloud.runTransaction(transactions, zoneId: zoneId, resolve: { (response) in
                result(response)
            })
        case method.SUBSCRIBE_SNAPSHOT:
            guard let query = args["query"] as? [String: Any] else { return  }
            guard let zoneId = args["zoneId"] as? String else { return  }
            guard let eventChannelName = args["eventChannelName"] as? String else { return  }
            guard let policy = args["policyIndex"] as? Int else { return  }
            guard let binaryMessenger = binaryMessenger  else {
                return  }
            let eventChannelHandler = SubscribeSnapshotEventHandler.init()
            let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger:
                                                    binaryMessenger)
            eventChannel.setStreamHandler(eventChannelHandler)
            agconnectCloud.subscribeSnapshot(query, zoneId: zoneId, policy: policy+1, handler: eventChannelHandler, resolve: { (response) in
                result(response)
            })
            
        default:
            result(FlutterError(code: "platformError", message: "Not supported on iOS platform", details: nil))
        }
    }
    struct Methods {
        let INITIALIZE = "initialize"
        let CREATE_OBJECT_TYPE = "createObjectType"
        let GET_CLOUD_DB_ZONE_CONFIGS = "getCloudDBZoneConfigs"
        let OPEN_CLOUD_DB_ZONE = "openCloudDBZone"
        let OPEN_CLOUD_DB_ZONE2 = "openCloudDBZone2"
        let CLOSE_CLOUD_DB_ZONE = "closeCloudDBZone"
        let DELETE_CLOUD_DB_ZONE = "deleteCloudDBZone"
        let ENABLE_NETWORK = "enableNetwork"
        let DISABLE_NETWORK = "disableNetwork"
        let SET_USER_KEY = "setUserKey"
        let UPDATE_DATA_ENCRYPTION_KEY = "updateDataEncryptionKey"
        let EXECUTE_UPSERT = "executeUpsert"
        let EXECUTE_DELETE = "executeDelete"
        let EXECUTE_QUERY = "executeQuery"
        let EXECUTE_AVERAGE_QUERY = "executeAverageQuery"
        let EXECUTE_SUM_QUERY = "executeSumQuery"
        let EXECUTE_MAXIMUM_QUERY = "executeMaximumQuery"
        let EXECUTE_MINIMAL_QUERY = "executeMinimalQuery"
        let EXECUTE_COUNT_QUERY = "executeCountQuery"
        let EXECUTE_QUERY_UNSYNCED = "executeQueryUnsynced"
        let EXECUTE_SERVER_STATUS_QUERY = "executeServerStatusQuery"
        let RUN_TRANSACTION = "runTransaction"
        let SUBSCRIBE_SNAPSHOT = "subscribeSnapshot"
    }   
}
