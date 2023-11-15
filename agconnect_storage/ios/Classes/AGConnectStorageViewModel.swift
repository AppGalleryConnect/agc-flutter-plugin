/*
 * Copyright 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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
import AGConnectStorage

public protocol ViewModelDelegate: AnyObject {
    func post(result: FlutterResult)
    func postError(error: Error?, result: FlutterResult)
    func postMap(data: Dictionary<String, Any>, result: FlutterResult)
    func postData(data: Any, result: FlutterResult)
    func postNSData(data: NSData, result: FlutterResult)
}

public class AGConnectStorageViewModel: NSObject {
    weak var delegate: ViewModelDelegate?
    private var storage : AGCStorage?
    
    private let agcStorageNullError = NSError.init(domain: "AGCStorage is null", code: 10, userInfo: ["PluginException": "AGCStorage_NOT_FOUND"])
    private let agcMetadataNullError = NSError.init(domain: "AGCStorageMetadata is null", code: 11, userInfo: ["PluginException": "AGCStorageMetadata_IS_null"])
    
    
    func getInstance(completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                self.storage = AGCStorage.getInstance()
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    
    func getInstance(_ policy: Int, _ bucketName: String, completion: @escaping FlutterResult) {
        let policy = AGCRoutePolicy(rawValue: UInt(policy))
        let config = AGCServicesConfig.init(defaultPlist:())
        config.routePolicy = policy ?? AGCRoutePolicy.unknown
        let instance = AGCInstance.getInstance(config)
        storage = AGCStorage.getInstance(instance, bucketName: bucketName)
    }
    
    func getInstanceForBucketName(_ bucketName: String, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                self.storage = AGCStorage.getInstanceForBucketName(bucketName)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func referenceFromUrl(url: String , completion: @escaping FlutterResult) {
        guard let storage = storage else { self.delegate?.postError(error: agcStorageNullError, result: completion)
            return }
        do {
            try ObjC.catchException{
                let reference = storage.reference(from: URL(string: url)!)
                self.delegate?.postData(data: reference.path, result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func setRetryTimes(retryTimes: NSInteger, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                storage.retryTimes = retryTimes
                self.delegate?.post(result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func getRetryTimes(completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                self.delegate?.postData(data: Int(storage.retryTimes), result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func setMaxRequestTimeout(maxRequestTimeout: NSInteger, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                
                storage.maxRequestTimeout = TimeInterval(maxRequestTimeout)
                self.delegate?.post(result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func getMaxRequestTimeout(completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                self.delegate?.postData(data: (Int(storage.maxRequestTimeout)) * 1000, result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func setMaxUploadTimeout(maxUploadTimeout: NSInteger, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                storage.maxUploadTimeout = TimeInterval(maxUploadTimeout)
                self.delegate?.post(result: completion)            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func getMaxUploadTimeout(completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                self.delegate?.postData(data: (Int(storage.maxUploadTimeout)) * 1000, result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func setMaxDownloadTimeout(maxDownloadTimeout: NSInteger, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                storage.maxDownloadTimeout = TimeInterval(maxDownloadTimeout)
                self.delegate?.post(result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func getMaxDownloadTimeout(completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                self.delegate?.postData(data: (Int(storage.maxDownloadTimeout)) * 1000, result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func getMetadata(arguments: Dictionary<String, Any>, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                
                reference.getMetadata().onSuccess{(result) in
                    guard let result = result else { self.delegate?.postError(error: self.agcMetadataNullError, result: completion)
                        return}
                    self.delegate?.postMap(data: FlutterStorageUtils.fileMetadataToMap(fileMetadata: result), result: completion)
                }.onFailure{(error) in
                    self.delegate?.postError(error: error, result: completion)
                }            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func updateMetadata(arguments: Dictionary<String, Any> , completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                guard let metadataMap = arguments["metadata"] as? Dictionary<String, Any> else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                reference.update(FlutterStorageUtils.mapToFileMetadata(fileMetadataMap: metadataMap)).onSuccess{(result) in
                    guard let result = result else { self.delegate?.postError(error: self.agcMetadataNullError, result: completion)
                        return}
                    self.delegate?.postMap(data: FlutterStorageUtils.fileMetadataToMap(fileMetadata: result), result: completion)
                }.onFailure{(error) in
                    self.delegate?.postError(error: error, result: completion)
                }            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func deleteFile(arguments: Dictionary<String, Any>, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                
                reference.deleteFile().onSuccess{(void) in
                    self.delegate?.post(result: completion)
                }.onFailure{(error) in
                    self.delegate?.postError(error: error, result: completion)
                }            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func uploadFile(arguments: Dictionary<String, Any>, flutterTask: AGCStorageTaskFlutter, handler: AGCStorageTaskEventHandler, taskID: String, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                guard let filePath = arguments["filePath"] as? String else { return  }
                if((arguments["metadata"] as? Dictionary<String, Any> != nil) && ((arguments["offset"] as? Int64) != nil)) {
                    guard let metadataMap = arguments["metadata"] as? Dictionary<String, Any> else { return  }
                    guard let offset = arguments["offset"] as? Int64 else { return  }
                    let metadata = FlutterStorageUtils.mapToFileMetadata(fileMetadataMap: metadataMap)
                    guard let task = reference.uploadFile(URL(fileURLWithPath: filePath), metadata: metadata, offset: offset) else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                        return}
                    
                    flutterTask.uploadTaskList[taskID] = task
                    handler.uploadTask = task
                    self.delegate?.postData(data: taskID, result: completion)
                } else if (arguments["metadata"] as? Dictionary<String, Any> != nil) {
                    guard let metadataMap = arguments["metadata"] as? Dictionary<String, Any> else { return  }
                    let metadata = FlutterStorageUtils.mapToFileMetadata(fileMetadataMap: metadataMap)
                    guard let task = reference.uploadFile(URL(fileURLWithPath: filePath), metadata: metadata) else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                        return}
                    
                    flutterTask.uploadTaskList[taskID] = task
                    handler.uploadTask = task
                    self.delegate?.postData(data: taskID, result: completion)
                } else {
                    guard let task = reference.uploadFile(URL(fileURLWithPath: filePath)) else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                        return}
                    
                    flutterTask.uploadTaskList[taskID] = task
                    handler.uploadTask = task
                    self.delegate?.postData(data: taskID, result: completion)
                }
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func uploadData(arguments: Dictionary<String, Any>, flutterTask: AGCStorageTaskFlutter, handler: AGCStorageTaskEventHandler, taskID: String, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                
                if((arguments["metadata"] as? Dictionary<String, Any> != nil) && ((arguments["offset"] as? Int64) != nil)) {
                    guard let metadataMap = arguments["metadata"] as? Dictionary<String, Any> else { return  }
                    guard let offset = arguments["offset"] as? Int64 else { return  }
                    guard let flutterData = arguments["bytes"] as? FlutterStandardTypedData else { return  }
                    
                    let metadata = FlutterStorageUtils.mapToFileMetadata(fileMetadataMap: metadataMap)
                    guard let task = reference.uploadData(Data(flutterData.data), metadata: metadata, offset: offset) else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                        return}
                    
                    flutterTask.uploadTaskList[taskID] = task
                    handler.uploadTask = task
                    self.delegate?.postData(data: taskID, result: completion)
                } else if (arguments["metadata"] as? Dictionary<String, Any> != nil) {
                    guard let metadataMap = arguments["metadata"] as? Dictionary<String, Any> else { return  }
                    guard let flutterData = arguments["bytes"] as? FlutterStandardTypedData else { return  }
                    
                    let metadata = FlutterStorageUtils.mapToFileMetadata(fileMetadataMap: metadataMap)
                    guard let task = reference.uploadData(Data(flutterData.data), metadata: metadata) else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                        return}
                    
                    flutterTask.uploadTaskList[taskID] = task
                    handler.uploadTask = task
                    self.delegate?.postData(data: taskID, result: completion)
                } else {
                    guard let flutterData = arguments["bytes"] as? FlutterStandardTypedData else { return  }
                    guard let task = reference.uploadData(Data(flutterData.data)) else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                        return}
                    
                    flutterTask.uploadTaskList[taskID] = task
                    handler.uploadTask = task
                    self.delegate?.postData(data: taskID, result: completion)
                }
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func downloadFile(arguments: Dictionary<String, Any>, flutterTask: AGCStorageTaskFlutter, handler: AGCStorageTaskEventHandler, taskID: String, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                guard let filePath = arguments["filePath"] as? String else { return  }
                
                guard let task = reference.download(toFile: URL(fileURLWithPath: filePath)) else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                
                flutterTask.downloadTaskList[taskID] = task
                handler.downloadTask = task
                self.delegate?.postData(data: taskID, result: completion)
                
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func downloadData(arguments: Dictionary<String, Any>, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                guard let maxSize = arguments["maxSize"] as? Int64 else { return  }
                
                guard let task = reference.downloadData(withMaxSize: maxSize) else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                task.onSuccess(callback: {(result) in
                    self.delegate?.postNSData(data: result!, result: completion)
                }).onFailure{(error) in
                    self.delegate?.postError(error: error, result: completion)
                }
                
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func getDownloadUrl(arguments: Dictionary<String, Any> , completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                reference.getDownloadUrl().onSuccess{(result) in
                    self.delegate?.postData(data: result?.absoluteString as Any, result: completion)
                }.onFailure{(error) in
                    self.delegate?.postError(error: error, result: completion)
                }
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)        }
    }
    
    func list(arguments: Dictionary<String, Any>, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                
                if((arguments["max"] as? Int != nil) && (arguments["pageMarker"] as? String != nil)) {
                    guard let max = arguments["max"] as? Int else { return  }
                    guard let marker = arguments["pageMarker"] as? String else { return  }
                    
                    let task = reference.list(max, marker: marker)
                    
                    task.onSuccess(callback: {(result) in
                        guard let result = result else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                            return}
                        
                        self.delegate?.postMap(data: FlutterStorageUtils.getResultList(agcStorageList: result), result: completion)
                    } ).onFailure(callback: {(error) in
                        self.delegate?.postError(error: error, result: completion)
                    })
                    
                }else {
                    guard let max = arguments["max"] as? Int else { return  }
                    let task = reference.list(max)
                    
                    task.onSuccess(callback: {(result) in
                        guard let result = result else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                            return}
                        
                        self.delegate?.postMap(data: FlutterStorageUtils.getResultList(agcStorageList: result), result: completion)
                    } ).onFailure(callback: {(error) in
                        self.delegate?.postError(error: error, result: completion)
                    })
                }
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func listAll(arguments: Dictionary<String, Any> , completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                
                let task = reference.listAll()
                
                task.onSuccess(callback: {(result) in
                    guard let result = result else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                        return}
                    
                    self.delegate?.postMap(data: FlutterStorageUtils.getResultList(agcStorageList: result), result: completion)
                } ).onFailure(callback: {(error) in
                    
                    self.delegate?.postError(error: error, result: completion)
                })
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func activeUploadTasks(arguments: Dictionary<String, Any> , flutterTask: AGCStorageTaskFlutter, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                
                let list = reference.activeUploadTasks()
                var uploadTaskIds: [String] = []
                for item in flutterTask.uploadTaskList {
                    if(list.contains(item.value)) {
                        uploadTaskIds.append(item.key)
                    }
                }
                self.delegate?.postData(data: uploadTaskIds, result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
    func activeDownloadTasks(arguments: Dictionary<String, Any> , flutterTask: AGCStorageTaskFlutter, completion: @escaping FlutterResult) {
        do {
            try ObjC.catchException{
                guard let storage = self.storage else { self.delegate?.postError(error: self.agcStorageNullError, result: completion)
                    return}
                let reference = FlutterStorageUtils.getReference(arguments: arguments, storage: storage)
                
                let list = reference.activeDownloadTasks()
                var downloadTaskIds: [String] = []
                for item in flutterTask.downloadTaskList {
                    if(list.contains(item.value)) {
                        downloadTaskIds.append(item.key)
                    }
                }
                self.delegate?.postData(data: downloadTaskIds, result: completion)
            }
        } catch {
            self.delegate?.postError(error: error, result: completion)
        }
    }
    
}

