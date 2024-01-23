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

public protocol ViewModelDelegate: AnyObject {
    func post(result: FlutterResult)
    func postMap(data: [String: Any], result: FlutterResult)
    func postArray(data: NSMutableArray, result: FlutterResult)
    func postError(error: Error?, result: FlutterResult)
    func postData(data: Any?, result: FlutterResult)
}

public class AGConnectCloudDBViewModel: NSObject {
    weak var delegate: ViewModelDelegate?
    
    private var dbZoneList = [String: AGCCloudDBZone]()
    private var dbZone: AGCCloudDBZone?
    private var agcCloudDB: AGConnectCloudDB?
    private var _eventSink: FlutterEventSink?
    
    private let cloudDBClassError = NSError.init(domain: "Class cannot be found.", code: 9, userInfo: ["PluginException": "CLASS_NOT_FOUND"])
    private let cloudDBNullError = NSError.init(domain: "CloudDB is null", code: 10, userInfo: ["PluginException": "ZONE_NOT_FOUND"])
    private let dbZoneNullError = NSError.init(domain: "CloudDBZone is null, try re-open it", code: 11, userInfo: ["PluginException": "ZONE_NOT_FOUND"])
    private let queryNullError = NSError.init(domain: "AGConnectCloudDBQuery object failure", code: 12, userInfo: ["PluginException": "QUERY_NOT_FOUND"])
    private let objectError = NSError.init(domain: "Object Failed", code: 13, userInfo: ["PluginException": "OBJECT_ERROR"])
    private let enableNetworkError = NSError.init(domain: "Failed to enable naturalStore network", code: 14, userInfo: ["PluginException": "Network_ERROR"])
    private let disableNetworkError = NSError.init(domain: "Failed to disable naturalStore network", code: 14, userInfo: ["PluginException": "Network_ERROR"])
    
    func initialize(completion: @escaping FlutterResult) {
        var errorPointer: NSError?
        AGConnectCloudDB.initEnvironment(&errorPointer)
        self.agcCloudDB = AGConnectCloudDB.shareInstance()
        if let error = errorPointer {
            self.delegate?.postError(error: error, result: completion)
        } else {
            self.delegate?.post(result: completion)
        }
    }
    
    func createObjectType(completion: @escaping FlutterResult) {
        var errorPointer: NSError?
        self.agcCloudDB?.createObjectType(AGCCloudDBObjectTypeInfoHelper.obtainObjectTypeInfo(), error: &errorPointer)
        if let error = errorPointer {
            self.delegate?.postError(error: error, result: completion)
        } else {
            self.delegate?.post(result: completion)
        }
    }
    
    func getCloudDBZoneConfigs(completion: @escaping FlutterResult) {
        guard let agcCloudDB = agcCloudDB else {
            self.delegate?.postError(error: cloudDBNullError, result: completion)
            return
        }
        
        let array: NSMutableArray = []
        for zoneConfig in agcCloudDB.zoneConfigs() {
            var map: [String: Any] = [String: Any]()
            map["accessProperty"] = zoneConfig.accessMode.rawValue == 0 ? "CLOUDDBZONE_PUBLIC": ""
            map["capacity"] = zoneConfig.capacity
            map["zoneName"] = zoneConfig.zoneName
            map["isPersistenceEnabled"] = zoneConfig.persistence
            map["syncProperty"] = zoneConfig.syncMode.rawValue == 0 ? "CLOUDDBZONE_LOCAL_ONLY":"CLOUDDBZONE_CLOUD_CACHE"
            map["isEncrypted"] = zoneConfig.encrypted
            array.add(map)
        }
        self.delegate?.postArray(data: array, result: completion)
    }
    
    func openCloudDBZone2(_ map: [String: Any], isAllowToCreate allowed: Bool, completion: @escaping FlutterResult) {
        
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return }
        
        if let zoneConfig = FlutterCloudDBUtils.handleConfig(map: map) {
            var id = ""
            while true {
                id = FlutterCloudDBUtils.randomId(5)
                if dbZoneList[id] == nil {
                    break
                }
            }
            agcCloudDB.openZone2(zoneConfig, allowCreate: allowed) { [weak self] (dbZone, error) in
                guard let strongSelf = self else { return }
                if let error = error as NSError? {
                    strongSelf.delegate?.postError(error: error, result: completion)
                }
                if let dbZone =  dbZone {
                    strongSelf.dbZoneList[id] = dbZone
                    self?.delegate?.postMap(data: ["zoneId": id],result: completion)
                }
            }
        } else {
            self.delegate?.postError(error: cloudDBClassError, result: completion)
        }
    }
    
    func openCloudDBZone(_ map: [String: Any], isAllowToCreate allowed: Bool, completion: @escaping FlutterResult) {
        
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return }
        
        if let zoneConfig = FlutterCloudDBUtils.handleConfig(map: map) {
            do {
                var id = ""
                while true {
                    id = FlutterCloudDBUtils.randomId(5)
                    if dbZoneList[id] == nil {
                        break
                    }
                }
                dbZone = try agcCloudDB.openZone(zoneConfig, allowCreate: allowed)
                self.dbZoneList[id] = dbZone
                self.delegate?.postMap(data: ["zoneId": id],result: completion)
                
            } catch {
                self.delegate?.postError(error: error, result: completion)
            }
        } else {
            self.delegate?.postError(error: cloudDBClassError, result: completion)
        }
    }
    
    func closeCloudDB(_ zoneId: String, completion: @escaping FlutterResult) {
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return }
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        var errorPointer: NSError?
        agcCloudDB.close(dbZone, error: &errorPointer)
        if let error = errorPointer {
            self.delegate?.postError(error: error, result: completion)
        } else {
            self.dbZoneList.removeValue(forKey: zoneId)
            self.delegate?.post(result: completion)
        }
    }
    
    func deleteCloudDB(zoneName: String, completion: @escaping FlutterResult) {
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return }
        var errorPointer: NSError?
        agcCloudDB.deleteZone(zoneName, error: &errorPointer)
        if let error = errorPointer {
            self.delegate?.postError(error: error, result: completion)
        } else {
            self.dbZoneList.removeValue(forKey: zoneName)
            self.delegate?.post(result: completion)
        }
    }
    
    func enableNetwork(_ zoneName: String, completion: @escaping FlutterResult) {
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return }
        let result = agcCloudDB.enableNetwork(zoneName)
        if result {
            self.delegate?.post(result: completion)
        } else {
            self.delegate?.postError(error: enableNetworkError, result: completion)
        }
    }
    
    func disableNetwork(_ zoneName: String, completion: @escaping FlutterResult) {
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return }
        let result = agcCloudDB.disableNetwork(zoneName)
        if result {
            self.delegate?.post(result: completion)
        } else {
            self.delegate?.postError(error: enableNetworkError, result: completion)
        }
    }
    
    func setUserKey(userKey: String, userReKey: String,needStrongCheck: Bool, completion: @escaping FlutterResult) {
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return }
        agcCloudDB.setUserKey(userKey, userRekey: userReKey,needStrongCheck: needStrongCheck) { [weak self]  error   in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                strongSelf.delegate?.postError(error: error, result: completion)
            } else {
                strongSelf.delegate?.post(result: completion)
            }
        }
    }
    
    func setUserKey(userKey: String, userReKey: String, completion: @escaping FlutterResult) {
        
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return }
        agcCloudDB.setUserKey(userKey, userRekey: userReKey) { [weak self]  error   in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                strongSelf.delegate?.postError(error: error, result: completion)
            } else {
                strongSelf.delegate?.post(result: completion)
            }
        }
    }
    
    func updateDataEncryptionKey(completion: @escaping FlutterResult) {
        
        guard let agcCloudDB = agcCloudDB else { self.delegate?.postError(error: cloudDBNullError, result: completion)
            return  }
        agcCloudDB.updateDataEncryptionKey { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                strongSelf.delegate?.postError(error: error, result: completion)
            } else {
                strongSelf.delegate?.post(result: completion)
            }
        }
    }
    
    func executeUpsert(_ className: String, objectArray array: [Any], zoneId: String, completion: @escaping FlutterResult) {
        
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        if let clazz = FlutterCloudDBUtils.classFromString(className: className) as? AGCCloudDBObject.Type {
            var instanceArray = [AGCCloudDBObject]()
            for case let object in array {
                guard let object = object as? [String: Any] else { return }
                guard let instance = FlutterCloudDBUtils.mapToObject(clazz: clazz, map: object) else {
                    self.delegate?.postError(error: objectError, result: completion)
                    return }
                instanceArray.append(instance)
            }
            dbZone.executeUpsert(instanceArray) { [weak self] (result, error) in
                guard let strongSelf = self else { return }
                if let error = error as NSError? {
                    strongSelf.delegate?.postError(error: error, result: completion)
                } else {
                    strongSelf.delegate?.postData(data: result, result: completion)
                }
            }
        } else {
            self.delegate?.postError(error: cloudDBClassError, result: completion)
        }
    }
    
    func executeDelete(_ className: String, objectArray array: [Any], zoneId: String, completion: @escaping FlutterResult) {
        
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return}
        if let clazz = FlutterCloudDBUtils.classFromString(className: className) as? AGCCloudDBObject.Type {
            var instanceArray = [AGCCloudDBObject]()
            for case let object in array {
                guard let object = object as? [String: Any] else { return }
                guard let instance = FlutterCloudDBUtils.mapToObject(clazz: clazz, map: object) else {
                    self.delegate?.postError(error: objectError, result: completion)
                    return }
                instanceArray.append(instance)
            }
            dbZone.executeDelete(instanceArray) { [weak self] (result, error) in
                guard let strongSelf = self else { return }
                if let error = error as NSError? {
                    strongSelf.delegate?.postError(error: error, result: completion)
                } else {
                    strongSelf.delegate?.postData(data: result, result: completion)
                }
            }
        } else {
            self.delegate?.postError(error: cloudDBClassError, result: completion)
        }
    }
    
    func executeQuery(d_ map: [String: Any], policy queryPolicy: Int, zoneId: String, completion: @escaping FlutterResult) {
        
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        guard let query = queryBuilder(map: map, completion: completion) as AGCCloudDBQuery? else {
            self.delegate?.postError(error: queryNullError, result: completion)
            return }
        guard let policy = AGCCloudDBQueryPolicy.init(rawValue: queryPolicy) else { return }
        dbZone.execute(query, policy: policy) { [weak self] (snapshot, error) in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                strongSelf.delegate?.postError(error: error, result: completion)
            }
            if let snapshot = snapshot {
                var dictionary = [String: Any]()
                dictionary["isFromCloud"] = snapshot.isFromCloud()
                dictionary["hasPendingWrites"] = snapshot.hasPendingWrites()
                if let snapshotObjects = FlutterCloudDBUtils.resolveSnapshot(array: snapshot.snapshotObjects()) {
                    dictionary["snapshotObjects"] = snapshotObjects
                }
                if let deletedObjects = FlutterCloudDBUtils.resolveSnapshot(array: snapshot.deletedObjects()) {
                    dictionary["deletedObjects"] = deletedObjects
                }
                if let upsertedObjects = FlutterCloudDBUtils.resolveSnapshot(array: snapshot.upsertedObjects()) {
                    dictionary["upsertedObjects"] = upsertedObjects
                }
                strongSelf.delegate?.postMap(data: dictionary, result: completion)
            }
        }
    }
    
    func executeAverageQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, completion: @escaping FlutterResult) {
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        guard let query = queryBuilder(map: map, completion: completion) as AGCCloudDBQuery? else { return }
        guard let policy = AGCCloudDBQueryPolicy.init(rawValue: queryPolicy) else {
            self.delegate?.postError(error: queryNullError, result: completion)
            return }
        dbZone.executeQueryAverage(query, policy: policy, field: fieldName) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                strongSelf.delegate?.postError(error: error, result: completion)
            } else {
                strongSelf.delegate?.postData(data: result, result: completion)
            }
        }
    }
    
    func executeSumQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, completion: @escaping FlutterResult) {
        
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        guard let query = queryBuilder(map: map, completion: completion) as AGCCloudDBQuery? else {
            self.delegate?.postError(error: queryNullError, result: completion)
            return }
        guard let policy = AGCCloudDBQueryPolicy.init(rawValue: queryPolicy) else { return }
        dbZone.executeQuerySum(query, policy: policy, field: fieldName) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                strongSelf.delegate?.postError(error: error, result: completion)
            } else {
                strongSelf.delegate?.postData(data: result, result: completion)
            }
        }
    }
    
    func executeMaximumQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, completion: @escaping FlutterResult) {
        
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        guard let query = queryBuilder(map: map, completion: completion) as AGCCloudDBQuery? else {
            self.delegate?.postError(error: queryNullError, result: completion)
            return }
        guard let policy = AGCCloudDBQueryPolicy.init(rawValue: queryPolicy) else { return }
        dbZone.executeQueryMaximum(query, policy: policy, field: fieldName) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if (error as NSError?) != nil {
                strongSelf.delegate?.postError(error: error, result: completion)
            } else {
                strongSelf.delegate?.postData(data: result, result: completion)
            }
        }
    }
    
    func executeMinimalQuery(_ map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, completion: @escaping FlutterResult) {
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        guard let query = queryBuilder(map: map, completion: completion) as AGCCloudDBQuery? else {
            self.delegate?.postError(error: queryNullError, result: completion)
            return }
        guard let policy = AGCCloudDBQueryPolicy.init(rawValue: queryPolicy) else { return }
        dbZone.executeQueryMinimum(query, policy: policy, field: fieldName) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if (error as NSError?) != nil {
                strongSelf.delegate?.postError(error: error, result: completion)
            } else {
                strongSelf.delegate?.postData(data: result, result: completion)
            }
        }
    }
    
    func executeCountQuery( map: [String: Any], withFieldName fieldName: String, policy queryPolicy: Int, zoneId: String, completion: @escaping FlutterResult) {
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        guard let query = queryBuilder(map: map, completion: completion) as AGCCloudDBQuery? else {
            self.delegate?.postError(error: queryNullError, result: completion)
            return }
        guard let policy = AGCCloudDBQueryPolicy.init(rawValue: queryPolicy) else { return }
        dbZone.executeQueryCount(query, policy: policy, field: fieldName) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if (error as NSError?) != nil {
                strongSelf.delegate?.postError(error: error, result: completion)
            } else {
                strongSelf.delegate?.postData(data: result, result: completion)
            }
        }
    }
    
    func executeQueryUnsynced(_ map: [String: Any], zoneId: String, completion: @escaping FlutterResult) {
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        guard let query = queryBuilder(map: map, completion: completion) as AGCCloudDBQuery? else {
            self.delegate?.postError(error: queryNullError, result: completion)
            return }
        dbZone.executeQueryUnsynced(query) { [weak self] (snapshot, error) in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                strongSelf.delegate?.postError(error: error, result: completion)
            }
            if let snapshot = snapshot {
                var dictionary = [String: Any]()
                dictionary["isFromCloud"] = snapshot.isFromCloud()
                dictionary["hasPendingWrites"] = snapshot.hasPendingWrites()
                if let snapshotObjects = FlutterCloudDBUtils.resolveSnapshot(array: snapshot.snapshotObjects()) {
                    dictionary["snapshotObjects"] = snapshotObjects
                }
                if let deletedObjects = FlutterCloudDBUtils.resolveSnapshot(array: snapshot.deletedObjects()) {
                    dictionary["deletedObjects"] = deletedObjects
                }
                if let upsertedObjects = FlutterCloudDBUtils.resolveSnapshot(array: snapshot.upsertedObjects()) {
                    dictionary["upsertedObjects"] = upsertedObjects
                }
                strongSelf.delegate?.postMap(data: dictionary, result: completion)
            }
        }
    }
    
    func executeServerStatusQuery(zoneId: String, completion: @escaping FlutterResult) {
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        dbZone.executeServerStatusQuery() { [weak self] (serverStatus, error) in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                strongSelf.delegate?.postError(error: error, result: completion)
            }
            if let serverStatus = serverStatus {
                var dictionary = [String: Any]()
                dictionary["serverTimeStamp"] = serverStatus.serverTimestamp
                strongSelf.delegate?.postMap(data: dictionary, result: completion)
            }
        }
    }
    
    
    func runTransaction(_ transactionsArray: NSMutableArray, zoneId: String, completion: @escaping FlutterResult) {
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        dbZone.runTransaction {(function) -> Bool in
            guard let function = function else { return false }
            for case let transactions in transactionsArray {
                var instanceArray = [AGCCloudDBObject]()
                guard let transactions = transactions as? [String: Any] else { return false }
                guard let operation = transactions["operation"] as? String else { return false }
                guard let className = transactions["zoneObjectTypeName"] as? String else { return false }
                guard let array = transactions["zoneObjectDataEntries"] as? NSMutableArray else { return false }
                
                if let clazz = FlutterCloudDBUtils.classFromString(className: className) as? AGCCloudDBObject.Type {
                    for case let object in array {
                        guard let object = object as? [String: Any] else { return false }
                        guard let instance = FlutterCloudDBUtils.mapToObject(clazz: clazz, map: object) else {
                            return false }
                        instanceArray.append(instance)
                    }
                }
                switch operation {
                case "executeUpsert":
                    function.executeUpsert(instanceArray)
                    break
                case "executeDelete":
                    function.executeDelete(instanceArray)
                    break
                default:
                    break
                }
            }
            return true
        }onCompleted: { (error) in
            if error != nil {
                self.delegate?.postError(error: error, result: completion)
                return
            } else {
                self.delegate?.post( result: completion)
            }
        }
    }
    
    func subscribeSnapshot(_ map: [String: Any], zoneId: String, policy queryPolicy: Int, handler: SubscribeSnapshotEventHandler , completion: @escaping FlutterResult)  {
        
        guard let dbZone = FlutterCloudDBUtils.getZoneFromList(name: zoneId, dbZoneList: self.dbZoneList) else { self.delegate?.postError(error: dbZoneNullError, result: completion)
            return }
        guard let query =  queryBuilder(map: map, completion: completion) as AGCCloudDBQuery? else {
            self.delegate?.postError(error: queryNullError, result: completion)
            return }
        guard let policy = AGCCloudDBQueryPolicy.init(rawValue: queryPolicy) else { return }
        
        handler.SubscribeSnapshotEventHandler(dbZone: dbZone, policy: policy, query: query)
        self.delegate?.post(result: completion)
    }
    
    func queryBuilder(map: [String: Any], completion: @escaping FlutterResult) -> AGCCloudDBQuery? {
        guard let className = map["zoneObjectTypeName"] as? String else { return nil }
        guard let clazz = FlutterCloudDBUtils.classFromString(className: className) as? AGCCloudDBObject.Type else {
            self.delegate?.postError(error: NSError.init(domain: "Class is null", code: 10, userInfo: ["PluginException": "ZONE_NOT_FOUND"]), result: completion)
            
            return nil }
        let types = FlutterCloudDBUtils.getPropsWithTypes(object: clazz)
        let query = AGCCloudDBQuery.where(clazz)
        guard let queryElements = map["queryElements"] as? [[String: Any]] else {
            self.delegate?.postError(error: NSError.init(domain: "Object is null", code: 10, userInfo: ["PluginException": "ZONE_NOT_FOUND"]), result: completion)
            return nil }
        
        
        do {
            try ObjC.catchException {
                FlutterCloudDBUtils.makeQuery(queryElements: queryElements, query: query, types: types, clazz: clazz, className: className)
            }
        }
        catch {
            if let error = error as NSError? {
                self.delegate?.postError(error: error, result: completion)
                return nil
            }
        }
        return query
    }
}
