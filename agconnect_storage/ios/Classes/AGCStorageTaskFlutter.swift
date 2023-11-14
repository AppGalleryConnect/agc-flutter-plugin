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

class AGCStorageTaskFlutter: NSObject {
    
    var downloadTaskList = [String: AGCStorageDownloadTask]()
    var uploadTaskList = [String: AGCStorageUploadTask]()
    
    public func handleInnerMethod(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            return
        }
        let methodList = call.method.components(separatedBy: "#")
        
        guard let taskID = args["taskId"] as? String else {
            return
        }
        let methodName = methodList[1] as String
        switch methodName {
        case "uploadTask/pause":
            let task = FlutterStorageUtils.getUploadTaskFromList(name: taskID, uploadTaskList: uploadTaskList)
            result(task?.pause())
            
        case "uploadTask/resume":
            let task = FlutterStorageUtils.getUploadTaskFromList(name: taskID, uploadTaskList: uploadTaskList)            
            result(task?.resume())
            
        case "uploadTask/cancel":
            let task = FlutterStorageUtils.getUploadTaskFromList(name: taskID, uploadTaskList: uploadTaskList)
            result(task?.cancel())
            
        case "downloadTask/pause":
            let task = FlutterStorageUtils.getdownloadTaskFromList(name: taskID, downloadTaskList: downloadTaskList)
            result(task?.pause())
            
        case "downloadTask/resume":
            let task = FlutterStorageUtils.getdownloadTaskFromList(name: taskID, downloadTaskList: downloadTaskList)
            result(task?.resume())
            
        case "downloadTask/cancel":
            let task = FlutterStorageUtils.getdownloadTaskFromList(name: taskID, downloadTaskList: downloadTaskList)
            result(task?.cancel())
            
        default:
            result(FlutterError(code: "platformError", message: "Not supported on iOS platform", details: nil))
        }
    }
}
