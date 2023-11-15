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

@objc(AGConnectStorageFlutter)

/// Provides methods to initialize Cloud Storage Kit and implement analysis functions.
class AGConnectStorageFlutter: NSObject {
    private var viewModel: AGConnectStorageViewModel = AGConnectStorageViewModel()
    
    
    @objc func getInstance(_ policy: Int, _ bucketName: String, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getInstance(policy, bucketName, completion: resolve)
    }
    
    @objc func getInstance(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getInstance(completion: resolve)
    }
    
    @objc func getInstanceForBucketName(_ bucketName: String, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getInstanceForBucketName(bucketName, completion: resolve)
    }
    
    @objc func referenceFromUrl(_ url: String, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.referenceFromUrl(url: url, completion: resolve)
    }
    
    @objc func getRetryTimes(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getRetryTimes(completion: resolve)
    }
    
    @objc func setRetryTimes(_ retryTimes: NSInteger, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.setRetryTimes(retryTimes: retryTimes, completion: resolve)
    }
    
    @objc func setMaxRequestTimeout(_ maxRequestTimeout: NSInteger, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.setMaxRequestTimeout(maxRequestTimeout: maxRequestTimeout, completion: resolve)
    }
    
    @objc func getMaxRequestTimeout(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getMaxRequestTimeout(completion: resolve)
    }
    
    @objc func setMaxUploadTimeout(_ maxUploadTimeout: NSInteger, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.setMaxUploadTimeout(maxUploadTimeout: maxUploadTimeout, completion: resolve)
    }
    
    @objc func getMaxUploadTimeout(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getMaxUploadTimeout(completion: resolve)
    }
    
    @objc func setMaxDownloadTimeout(maxDownloadTimeout: NSInteger, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.setMaxDownloadTimeout(maxDownloadTimeout: maxDownloadTimeout, completion: resolve)
    }
    
    @objc func getMaxDownloadTimeout(_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getMaxDownloadTimeout(completion: resolve)
    }
    
    @objc func getMetadata(arguments: Dictionary<String, Any>,_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getMetadata(arguments: arguments, completion: resolve)
    }
    
    @objc func updateMetadata(arguments: Dictionary<String, Any> ,_ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.updateMetadata(arguments: arguments, completion: resolve)
    }
    
    @objc func delete(arguments: Dictionary<String, Any>, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.deleteFile(arguments: arguments, completion: resolve)
    }
    
    @objc func uploadFile(arguments: Dictionary<String, Any>, flutterTask: AGCStorageTaskFlutter, handler: AGCStorageTaskEventHandler, taskID: String, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.uploadFile(arguments: arguments, flutterTask: flutterTask, handler: handler, taskID: taskID, completion: resolve)
    }
    
    @objc func uploadData(arguments: Dictionary<String, Any>, flutterTask: AGCStorageTaskFlutter, handler: AGCStorageTaskEventHandler, taskID: String, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.uploadData(arguments: arguments, flutterTask: flutterTask, handler: handler, taskID: taskID, completion: resolve)
    }
    
    @objc func downloadFile(arguments: Dictionary<String, Any>, flutterTask: AGCStorageTaskFlutter, handler: AGCStorageTaskEventHandler, taskID: String, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.downloadFile(arguments: arguments, flutterTask: flutterTask, handler: handler, taskID: taskID, completion: resolve)
    }
    
    @objc func downloadData(arguments: Dictionary<String, Any>, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.downloadData(arguments: arguments, completion: resolve)
    }
    
    @objc func getDownloadUrl(arguments: Dictionary<String, Any>, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.getDownloadUrl(arguments: arguments, completion: resolve)
    }
    
    @objc func listAll(arguments: Dictionary<String, Any> , _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.listAll(arguments: arguments, completion: resolve)
    }
    
    @objc func list(arguments: Dictionary<String, Any>, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.list(arguments: arguments, completion: resolve)
    }
    
    @objc func activeUploadTasks(arguments: Dictionary<String, Any>, flutterTask: AGCStorageTaskFlutter, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.activeUploadTasks(arguments: arguments, flutterTask: flutterTask, completion: resolve)
    }
    
    @objc func activeDownloadTasks(arguments: Dictionary<String, Any>, flutterTask: AGCStorageTaskFlutter, _ resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.activeDownloadTasks(arguments: arguments, flutterTask: flutterTask, completion: resolve)
    }
}
extension AGConnectStorageFlutter: ViewModelDelegate {
    
    func postNSData(data: NSData, result: (Any?) -> Void) {
        result(data)
    }
    func postData(data: Any, result: (Any?) -> Void) {
        result(data)
    }
    
    func post(result: (Any?) -> Void) {
        result("Success")
    }
    
    func postMap(data: [String: Any], result: FlutterResult) {
        result(data)
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
}
