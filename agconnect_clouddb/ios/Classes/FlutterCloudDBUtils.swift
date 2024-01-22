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

class FlutterCloudDBUtils {
    
    // MARK: Static Helper Functions
    
    static func getZoneFromList(name: String, dbZoneList: [String: AGCCloudDBZone]) -> AGCCloudDBZone? {
        return dbZoneList[name]
    }
    
    static func resolveSnapshot(array: [Any]) -> [[String: Any?]]? {
        var dicArray: [[String: Any?]] = []
        for element in array {
            guard let object = element as? AGCCloudDBObject else { return nil }
            let dic = self.convertObjectToDic(object: object)
            dicArray.append(dic)
        }
        return dicArray
    }
    
    static func makeQuery(queryElements: [Dictionary<String, Any>], query: AGCCloudDBQuery, types: Dictionary<String, String>, clazz: AGCCloudDBObject.Type, className: String) {
        for case let queryElement in queryElements {
            guard let operation = queryElement["operation"] as? String else { break }
            if let fieldName = queryElement["field"] as? String {
                if let value = queryElement["value"] {
                    let value = setTypeOfValue(value: value, field: fieldName, types: types)
                    queryAdd(value: value, fieldName: fieldName, operation: operation, query: query, types: types)
                } else {
                    queryAdd(onlyFieldName: fieldName, operation: operation, query: query)
                }
            } else {
                if operation == "limit" {
                    if let value = queryElement["value"] as? Double {
                        if let offset = queryElement["offset"] as? Double {
                            query.limit(Int32.init(value), offset: Int32.init(offset))
                        } else {
                            query.limit(Int32.init(value))
                        }
                    }
                }
                if let value = queryElement["value"] {
                    queryAdd(onlyValue: value, operation: operation, query: query, clazz: clazz)
                }
                if let value = queryElement["zoneObjectDataEntry"] {
                    queryAdd(onlyValue: value, operation: operation, query: query, clazz: clazz)
                }
            }
        }
    }

    static func queryAdd(value: Any, fieldName: String, operation: String, query: AGCCloudDBQuery, types: Dictionary<String, String>) {
        switch operation {
        case "equalTo":
            query.equal(to: value, forField: fieldName)
        case "notEqualTo":
            query.notEqual(to: value, forField: fieldName)
        case "greaterThan":
            query.greaterThan(value, forField: fieldName)
        case "greaterThanOrEqualTo":
            query.greaterThanOrEqual(to: value, forField: fieldName)
        case "lessThan":
            query.lessThan(value, forField: fieldName)
        case "lessThanOrEqualTo":
            query.lessThanOrEqual(to: value, forField: fieldName)
        case "in":
            if let value = handleArrayTypes(value: value, fieldName: fieldName, query: query, types: types) {
                query.inArray(value, forField: fieldName)
            }
        case "beginsWith":
            query.begins(with: value, forField: fieldName)
        case "endsWith":
            query.ends(with: value, forField: fieldName)
        case "contains":
            query.contains(value, forField: fieldName)
        default:
            break
        }
    }
    static func handleArrayTypes(value: Any, fieldName: String, query: AGCCloudDBQuery, types: Dictionary<String, String>) -> [Any]?{
        if let array = value as? [Any] {
            var typedValues: [Any] = []
            for item in array {
                let typedValue = setTypeOfValue(value: item, field: fieldName, types: types)
                typedValues.append(typedValue)
            }
            return typedValues
        }
        return nil
    }
    static func queryAdd(onlyFieldName fieldName: String, operation: String, query: AGCCloudDBQuery) {
        switch operation {
        case "isNull":
            query.isNull(fieldName)
        case "isNotNull":
            query.isNotNull(fieldName)
        case "orderByAsc":
            query.order(byAsc: fieldName)
        case "orderByDesc":
            query.order(byDesc: fieldName)
        default:
            break
        }
    }
    
    static func queryAdd(onlyValue value: Any, operation: String, query: AGCCloudDBQuery, clazz: AGCCloudDBObject.Type) {
        guard let value = value as? [String: Any] else { return }
        guard let object = mapToObject(clazz: clazz, map: value) as AGCCloudDBObject? else {return }
        switch operation {
        case "startAt":
            query.start(at: object)
        case "startAfter":
            query.start(after: object)
        case "endAt":
            query.end(at: object)
        case "endBefore":
            query.end(before: object)
        default:
            break
        }
    }
    
    static func mapToObject(clazz: AGCCloudDBObject.Type, map: [String: Any]) -> AGCCloudDBObject? {
        let instance = clazz.init()
        let types = getPropsWithTypes(object: clazz)
        for case let (key, value) in map {
            if (((types[key]?.isEmpty)) == nil) {
                break
            }
            let value = setTypeOfValue(value: value, field: key, types: types)
            instance.setValue(value, forKey: key)
        }
        return instance
    }
    
    static func handleConfig(map: [String: Any]) -> AGCCloudDBZoneConfig? {
        guard let cloudDBZoneName = map["zoneName"] as? String else { return nil }
        guard let syncRaw = map["syncProperty"] as? Int else { return nil }
        guard let syncProperty = AGCCloudDBZoneSyncMode.init(rawValue: syncRaw) else { return nil }
        guard let accessRaw = map["accessProperty"] as? Int else { return nil }
        guard let accessProperty = AGCCloudDBZoneAccessMode.init(rawValue: accessRaw) else { return nil }
        let isPersistenceEnabled = map["isPersistenceEnabled"] as? Bool ?? true
        let zoneConfig = AGCCloudDBZoneConfig.init(zoneName: cloudDBZoneName, syncMode: syncProperty, accessMode: accessProperty)
        
        zoneConfig.persistence = isPersistenceEnabled
        if (isPersistenceEnabled) {
            zoneConfig.capacity = map["capacity"] as? Int ?? 104857600
        }
        let isEncrypted = map["isEncrypted"] as? Bool ?? false
        if (isEncrypted) {
            guard let key = map["userKey"] as? String else { return nil }
            guard let reKey = map["userReKey"] as? String else { return nil }
            zoneConfig.setEncryptKey(key, rekey: reKey)
        }
        return zoneConfig
    }
    
    static func classFromString(className: String) -> AnyClass? {
        let cls: AnyClass? = NSClassFromString(className)
        return cls
    }
    
    static func convertObjectToDic(object: AGCCloudDBObject) -> [String: Any?] {
        var dic: [String: Any?] = [:]
        let types = getPropsWithTypes(object: object.classForCoder)
        
        for type in types {
            if type.value == "AGCCloudDBText" {
                if let cloudDBText = object.value(forKey: type.key) as? AGCCloudDBText {
                    dic[type.key] = cloudDBText.text
                }
            } else if type.value == "NSDate" {
                if let cloudDBDate = object.value(forKey: type.key) as? NSDate {
                    dic[type.key] = UInt64((cloudDBDate.timeIntervalSince1970 * 1000).rounded())
                }
            } else if type.value == "NSData" {
                if let cloudDBData = object.value(forKey: type.key) as? NSData {
                    var array: [Int] = []
                    for byte in cloudDBData {
                        array.append(Int(byte))
                    }
                    dic[type.key] = array
                }
            }else if type.value == "NSNumber<AGCLong>" {
                if let number = object.value(forKey: type.key) as? NSNumber {
                    dic[type.key] = number
                }
            }else if type.value == "NSNumber<AGCFloat>" {
                if let number = object.value(forKey: type.key) as? Float {
                    dic[type.key] = Double("\(number)")
                }
            }else {
                dic[type.key] = object.value(forKey: type.key)
            }
        }
        return dic
    }
    
    static func getPropNames (object: AnyClass) -> [String] {
        var outCount: UInt32 = 0
        let properties = class_copyPropertyList(object.self, &outCount)
        var propertiesArray: [String] = []
        for i: UInt32 in 0..<outCount {
            let strKey: NSString = NSString(cString: property_getName(properties![Int(i)]), encoding: String.Encoding.utf8.rawValue)!
            propertiesArray.append(strKey as String)
        }
        return propertiesArray
    }
    
    static func getPropsWithTypes (object: AnyClass) -> Dictionary<String, String> {
        var outCount: UInt32 = 0
        let properties = class_copyPropertyList(object.self, &outCount)
        var propertiesArray:  Dictionary<String, String> = [:]
        for i: UInt32 in 0..<outCount {
            let strKey: NSString = NSString(cString: property_getName(properties![Int(i)]), encoding: String.Encoding.utf8.rawValue)!
            let typeDef: String = NSString(cString: property_getAttributes(properties![Int(i)])!, encoding: String.Encoding.utf8.rawValue)! as String
            let typeName = typeDef.split(separator: "\"")
            propertiesArray[strKey as String] = String(typeName[1])
        }
        return propertiesArray
    }
    static func setTypeOfValue (value: Any, field: String, types: Dictionary<String, String>) -> Any {
        
        if types[field] == "AGCCloudDBText" {
            if let strValue = value as? String {
                let text = AGCCloudDBText.createText(strValue)
                return text
            }
        }else if types[field] == "NSDate" {
            if let timeInterval = value as? Int {
                let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval) / 1000)
                return date
            }
        }else if types[field] == "NSData" {
            if let str = value as? [UInt8] {
                let nsData = NSData(bytes: str, length: str.count)
                return nsData
            }
        }else if types[field] == "NSNumber<AGCLong>" {
            if let str = value as? String {
                if let number = Int(str) {
                    return NSNumber(value: number)
                }
            }
        }else if types[field] == "NSNumber<AGCFloat>" {
            if let number = value as? Float {
                return number
            }
        }
        return value
    }
    
    static func randomId(_ n: Int) -> String
    {
        let digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var result = ""
        
        for _ in 0..<n {
            result += String(digits.randomElement()!)
        }
        
        return result
    }
}
