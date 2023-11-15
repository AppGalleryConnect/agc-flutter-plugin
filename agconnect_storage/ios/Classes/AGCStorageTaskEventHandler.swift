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

class AGCStorageTaskEventHandler: NSObject, FlutterStreamHandler {
    
    var uploadTask: AGCStorageUploadTask?
    var downloadTask: AGCStorageDownloadTask?
    
    func uploadTaskAdd(uploadTask: AGCStorageUploadTask) {
        self.uploadTask = uploadTask
    }
    
    func downloadTaskAdd(downloadTask: AGCStorageDownloadTask) {
        self.downloadTask = downloadTask
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        if (uploadTask != nil) {
            
            uploadTask!.onSuccess{(result) in
                
                events(FlutterStorageUtils.uploadResultToMap(taskState: "success", uploadResult: result!))
            }.onFailure{ [self](error) in
                
                postError(error: error, result: events)
                
            }.onProgress{(result) in
                events(FlutterStorageUtils.uploadResultToMap(taskState: "progress", uploadResult: result!))
                
            }.onPaused{(result) in
                
                events(FlutterStorageUtils.uploadResultToMap(taskState: "paused", uploadResult: result!))
                
            }.onCancel {
                var map = Dictionary<String, Any>()
                
                map["taskState"] = "canceled"
                events(map)
            }
        } else if (downloadTask != nil) {
            
            downloadTask!.onSuccess{(result) in
                
                events(FlutterStorageUtils.downloadResultToMap(taskState: "success", downloadResult: result!))
            }.onFailure{(error) in
                
                self.postError(error: error, result: events)
            }.onProgress{(result) in
                
                events(FlutterStorageUtils.downloadResultToMap(taskState: "progress", downloadResult: result!))
            }.onPaused{(result) in
                
                events(FlutterStorageUtils.downloadResultToMap(taskState: "paused", downloadResult: result!))
                
            }.onCancel {
                var map = Dictionary<String, Any>()
                
                map["taskState"] = "canceled"
                events(map)
            }
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        
        return nil
    }
    
    func postError(error: Error?, result: FlutterEventSink) {
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
    
}
