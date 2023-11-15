/*
 * Copyright 2020-2023. Huawei Technologies Co., Ltd. All rights reserved.
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
import AGConnectAppLinking

@objc(FlutterAGCAppLinking)

/// Provides methods to initialize AppLinking Kit and implement analysis functions.
class FlutterAGCAppLinking: NSObject{
    
    
    private lazy var viewModel: AGCAppLinkingViewModel = AGCAppLinkingViewModel()
    
    @objc func buildShortAppLinking(_ params: NSDictionary, resolve: @escaping FlutterResult) -> Void {
        
        
        viewModel.delegate = self
        viewModel.buildShortAppLinking(params, result: resolve)
    }
    
    
    @objc func buildLongAppLinking(_ params: NSDictionary, resolve: @escaping FlutterResult) -> Void {
        
        viewModel.delegate = self
        viewModel.buildLongAppLinking(params, result: resolve)
    }
    
}
extension FlutterAGCAppLinking: ViewModelDelegate {
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
    
    func postData(data: [String : Any], result: FlutterResult) {
        result(data)
    }
}
