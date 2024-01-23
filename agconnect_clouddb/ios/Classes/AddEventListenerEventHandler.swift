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

class AddEventListenerEventHandler: NSObject, FlutterStreamHandler {
    
    let agcCloudDB = AGConnectCloudDB.init()
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        agcCloudDB.addEventCallback { result in
            
            switch result {
            case AGCCloudDBEventType.userKeyChanged:
                events("USER_KEY_CHANGED")
            default:
                events("UNKNOWN_EVENT_TYPE")
            }
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
