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

import Flutter
import UIKit
import AGConnectStorage
import AGConnectAuth

public class AGConnectStoragePluginHandler: NSObject, FlutterPlugin {
    let method = Methods.init()
    let agconnectStorage = AGConnectStorageFlutter.init()
    var binaryMessenger: FlutterBinaryMessenger?
    let agconnectStorageTask = AGCStorageTaskFlutter.init()
    let eventChannelPrefix = "com.huawei.agconnect.cloudstorage/eventChannel/task/"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.huawei.agconnect.cloudstorage/methodChannel/", binaryMessenger: registrar.messenger())
        let instance = AGConnectStoragePluginHandler()
        instance.binaryMessenger = registrar.messenger()
        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        AGCInstance.startUp()
        
        return true
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any] else {
            return
        }
        let methodList = call.method.components(separatedBy: "#")
        
        let methodName = methodList[1] as String
        print(methodName)
        if (methodList[0] == "AGCStorageTask") {
            agconnectStorageTask.handleInnerMethod(call, result: result)
        } else {
            if((arguments["bucket"] as? String != nil) && (arguments["policy"] as? Int != nil)) {
                let bucket = arguments["bucket"] as? String
                let policy = arguments["policy"] as? Int
                agconnectStorage.getInstance(policy!+1, bucket!,{ (response) in
                    result(response)
                })
            }else if(arguments["bucket"] as? String != nil) {
                let bucket = arguments["bucket"] as? String
                agconnectStorage.getInstanceForBucketName(bucket!,{ (response) in
                    result(response)
                })
                
            }else {
                agconnectStorage.getInstance({ (response) in
                    result(response)
                })
            }
            switch methodName {
            case method.GET_METADATA:
                agconnectStorage.getMetadata(arguments: arguments, { (response) in
                    result(response)
                })
            case method.UPDATE_METADATA:
                agconnectStorage.updateMetadata(arguments: arguments, { (response) in
                    result(response)
                })
            case method.REFERENCE_FROM_URL:
                guard let url = arguments["url"] as? String else { return  }
                
                agconnectStorage.referenceFromUrl(url, { (response) in
                    result(response)
                })
            case method.DELETE:
                agconnectStorage.delete(arguments: arguments, { (response) in
                    result(response)
                })
            case method.UPLOAD_FILE:
                guard let binaryMessenger = binaryMessenger  else {
                    return  }
                let taskID = FlutterStorageUtils.randomId(5)
                let eventChannelHandler = AGCStorageTaskEventHandler.init()
                let eventChannel = FlutterEventChannel(name: eventChannelPrefix+taskID, binaryMessenger:
                                                        binaryMessenger)
                eventChannel.setStreamHandler(eventChannelHandler)
                agconnectStorage.uploadFile(arguments:  arguments,flutterTask: agconnectStorageTask, handler: eventChannelHandler, taskID: taskID, { (response) in
                    result(response)
                })
            case method.UPLOAD_DATA:
                guard let binaryMessenger = binaryMessenger  else {
                    return  }
                let taskID = FlutterStorageUtils.randomId(5)
                let eventChannelHandler = AGCStorageTaskEventHandler.init()
                let eventChannel = FlutterEventChannel(name: eventChannelPrefix+taskID, binaryMessenger:
                                                        binaryMessenger)
                eventChannel.setStreamHandler(eventChannelHandler)
                agconnectStorage.uploadData(arguments:  arguments,flutterTask: agconnectStorageTask, handler: eventChannelHandler, taskID: taskID, { (response) in
                    result(response)
                })
            case method.DOWNLOAD_FILE:
                guard let binaryMessenger = binaryMessenger  else {
                    return  }
                let taskID = FlutterStorageUtils.randomId(5)
                let eventChannelHandler = AGCStorageTaskEventHandler.init()
                let eventChannel = FlutterEventChannel(name: eventChannelPrefix+taskID, binaryMessenger:
                                                        binaryMessenger)
                eventChannel.setStreamHandler(eventChannelHandler)
                agconnectStorage.downloadFile(arguments: arguments, flutterTask: agconnectStorageTask, handler: eventChannelHandler, taskID: taskID,  { (response) in
                    result(response)
                })
            case method.DOWNLOAD_DATA:
                
                agconnectStorage.downloadData(arguments: arguments, { (response) in
                    result(response)
                })
            case method.GET_DOWNLOAD_URL:
                agconnectStorage.getDownloadUrl(arguments: arguments, { (response) in
                    result(response)
                })
            case method.SET_RETRY_TIMES:
                guard let retryTimes = arguments["retryTimes"] as? NSInteger else { return  }
                agconnectStorage.setRetryTimes(retryTimes, { (response) in
                    result(response)
                })
            case method.GET_RETRY_TIMES:
                agconnectStorage.getRetryTimes({ (response) in
                    result(response)
                })
            case method.SET_MAX_REQUEST_TIMEOUT:
                guard let maxRequestTimeout = arguments["maxRequestTimeout"] as? NSInteger else { return  }
                agconnectStorage.setMaxRequestTimeout(maxRequestTimeout, { (response) in
                    result(response)
                })
            case method.GET_MAX_REQUEST_TIMEOUT:
                agconnectStorage.getMaxRequestTimeout({ (response) in
                    result(response)
                })
            case method.SET_MAX_UPLOAD_TIMEOUT:
                guard let maxUploadTimeout = arguments["maxUploadTimeout"] as? NSInteger else { return  }
                agconnectStorage.setMaxUploadTimeout(maxUploadTimeout, { (response) in
                    result(response)
                })
            case method.GET_MAX_UPLOAD_TIMEOUT:
                agconnectStorage.getMaxUploadTimeout({ (response) in
                    result(response)
                })
            case method.GET_MAX_DOWNLOAD_TIMEOUT:
                agconnectStorage.getMaxDownloadTimeout({ (response) in
                    result(response)
                })
            case method.SET_MAX_DOWNLOAD_TIMEOUT:
                guard let maxDownloadTimeout = arguments["maxDownloadTimeout"] as? NSInteger else { return  }
                agconnectStorage.setMaxDownloadTimeout(maxDownloadTimeout: maxDownloadTimeout, { (response) in
                    result(response)
                })
            case method.LIST_ALL:
                agconnectStorage.listAll(arguments: arguments, { (response) in
                    result(response)
                })
            case method.LIST:
                agconnectStorage.list(arguments: arguments, { (response) in
                    result(response)
                })
            case method.GET_ACTIVE_DOWNLOAD_TASKS:
                agconnectStorage.activeDownloadTasks(arguments: arguments, flutterTask: agconnectStorageTask, { (response) in
                    result(response)
                })
            case method.GET_ACTIVE_UPLOAD_TASKS:
                agconnectStorage.activeUploadTasks(arguments: arguments, flutterTask: agconnectStorageTask, { (response) in
                    result(response)
                })
            default:
                result(FlutterError(
                    code: "platformError" ,
                    message: "Not supported on iOS platform",
                    details: [
                        "exceptionType": "PluginException"
                    ]))
            }
        }
    }
    
    struct Methods {
        let GET_METADATA = "getMetadata"
        let UPDATE_METADATA = "updateMetadata"
        let DELETE = "deleteFile"
        let UPLOAD_FILE = "uploadFile"
        let UPLOAD_DATA = "uploadData"
        let GET_DOWNLOAD_URL = "getDownloadUrl"
        let SET_RETRY_TIMES = "setRetryTimes"
        let GET_RETRY_TIMES = "getRetryTimes"
        let SET_MAX_REQUEST_TIMEOUT = "setMaxRequestTimeout"
        let GET_MAX_REQUEST_TIMEOUT = "getMaxRequestTimeout"
        let SET_MAX_UPLOAD_TIMEOUT = "setMaxUploadTimeout"
        let GET_MAX_UPLOAD_TIMEOUT = "getMaxUploadTimeout"
        let SET_MAX_DOWNLOAD_TIMEOUT = "setMaxDownloadTimeout"
        let GET_MAX_DOWNLOAD_TIMEOUT = "getMaxDownloadTimeout"
        let LIST = "list"
        let LIST_ALL = "listAll"
        let DOWNLOAD_FILE = "downloadToFile"
        let DOWNLOAD_DATA = "downloadData"
        let GET_ACTIVE_DOWNLOAD_TASKS = "getActiveDownloadTasks"
        let GET_ACTIVE_UPLOAD_TASKS = "getActiveUploadTasks"
        let REFERENCE_FROM_URL = "referenceFromUrl"
    }
}
