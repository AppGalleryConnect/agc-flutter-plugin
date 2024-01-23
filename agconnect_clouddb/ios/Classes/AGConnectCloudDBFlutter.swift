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

import Foundation
import AGConnectDatabase
import Flutter

@objc(AGConnectCloudDBFlutter)

/// Provides methods to initialize Cloud DB Kit and implement analysis functions.
class AGConnectCloudDBFlutter: NSObject {
    
    private var viewModel: AGConnectCloudDBViewModel = AGConnectCloudDBViewModel()
    
    @objc func initialize(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.initialize(completion: resolve)
    }
    
    @objc func createObjectType(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.createObjectType(completion: resolve)
    }
    
    @objc func getCloudDBZoneConfigs(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getCloudDBZoneConfigs(completion: resolve)
    }
    
    @objc func openCloudDBZone(_ map: [String: Any], isAllowToCreate allowed: Bool, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.openCloudDBZone(map, isAllowToCreate: allowed, completion: resolve)
    }
    
    @objc func openCloudDBZone2(_ map: [String: Any], isAllowToCreate allowed: Bool, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.openCloudDBZone2(map, isAllowToCreate: allowed, completion: resolve)
    }
    
    @objc func deleteCloudDB(zoneName: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.deleteCloudDB(zoneName: zoneName, completion: resolve)
    }
    
    @objc func enableNetwork(_ zoneName: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.enableNetwork(zoneName, completion: resolve)
    }
    
    @objc func disableNetwork(_ zoneName: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.disableNetwork(zoneName, completion: resolve)
    }
    
    @objc func setUserKey(userKey: String, userReKey: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.setUserKey(userKey: userKey, userReKey: userReKey, completion: resolve)
    }
    
    @objc func updateDataEncryptionKey(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.updateDataEncryptionKey(completion: resolve)
    }
    
    @objc func closeCloudDB(_ zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.closeCloudDB(zoneId, completion: resolve)
    }
    
    @objc func executeUpsert(_ className: String, objectArray array: [Any], zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeUpsert(className, objectArray: array, zoneId: zoneId, completion: resolve)
    }
    
    @objc func executeDelete(_ className: String, objectArray array: [Any], zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeDelete(className, objectArray: array, zoneId: zoneId, completion: resolve)
    }
    
    @objc func executeQuery(_ map: [String: Any], policy queryPolicy: Int, zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeQuery(d_: map, policy: queryPolicy, zoneId: zoneId, completion: resolve)
    }
    
    @objc func executeAverageQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeAverageQuery(map, withFieldName: fieldName, policy: queryPolicy, zoneId: zoneId, completion: resolve)
    }
    
    @objc func executeSumQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeSumQuery(map, withFieldName: fieldName, policy: queryPolicy, zoneId: zoneId, completion: resolve)
    }
    
    @objc func executeMaximumQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeMaximumQuery(map, withFieldName: fieldName, policy: queryPolicy, zoneId: zoneId, completion: resolve)
    }
    @objc func executeMinimalQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeMinimalQuery(map, withFieldName: fieldName, policy: queryPolicy, zoneId: zoneId, completion: resolve)
    }
    
    @objc func executeCountQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeCountQuery(map: map, withFieldName: fieldName, policy: queryPolicy, zoneId: zoneId, completion: resolve)
    }
    
    @objc func executeQueryUnsynced(_ map: [String: Any], zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeQueryUnsynced(map, zoneId: zoneId, completion: resolve)
    }
    
    @objc func executeServerStatusQuery(zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.executeServerStatusQuery( zoneId: zoneId, completion: resolve)
    }
    
    @objc func runTransaction(_ map: NSMutableArray, zoneId: String, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.runTransaction(map, zoneId: zoneId, completion: resolve)
    }
    
    @objc func subscribeSnapshot(_ map: [String: Any], zoneId: String, policy queryPolicy: Int, handler: SubscribeSnapshotEventHandler, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.subscribeSnapshot(map, zoneId: zoneId, policy: queryPolicy, handler: handler, completion: resolve)
    }
}
extension AGConnectCloudDBFlutter: ViewModelDelegate {
    func postData(data: Any?, result: (Any?) -> Void) {
        result(data)
    }
    
    func post(result: (Any?) -> Void) {
        result("Success")
    }
    
    func postError(error: Error?, result: FlutterResult) {
        let error = error as NSError?
        if error?.userInfo["PluginException"] != nil {
            result(FlutterError(
                    code: error?.userInfo["PluginException"] as? String ?? "" ,
                    message: error?.localizedDescription,
                    details: [
                        "exceptionType": "PluginException"
                    ]))
        } else {
            result(FlutterError(
                    code: error?.code.description ?? "",
                    message: error?.localizedDescription,
                    details: [
                        "exceptionType": "SDKException"
                    ]))
        }
    }
    
    func postMap(data: [String: Any], result: FlutterResult) {
        result(data)
    }
    
    func postArray(data: NSMutableArray, result: FlutterResult) {
        result(data)
    }
}
