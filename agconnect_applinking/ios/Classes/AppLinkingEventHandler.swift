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

class AppLinkingEventHandler:NSObject,  FlutterStreamHandler {
    
    private var _eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        self._eventSink = events
        NotificationCenter.default.addObserver(self, selector: #selector(self.showResolvedLinkData(_:)), name: NSNotification.Name(rawValue: "AGCApplinkingNotification"), object: nil)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self._eventSink = nil
        NotificationCenter.default.removeObserver(self)
        return nil
    }
    
    @objc func  showResolvedLinkData(_ notification: NSNotification) {
        guard let _eventSink = _eventSink else {
            return
        }
        if let map = notification.userInfo {
            guard let resolvedLink = map["resolvedLink"] as? AGCResolvedLink else { return }
            
            let resolvedLinkMap = resolvedLinkDataToMap(resolvedLink: resolvedLink)
            _eventSink(resolvedLinkMap)
        }
    }
    func resolvedLinkDataToMap(resolvedLink: AGCResolvedLink) -> [String: Any] {
        let resolvedLinkList:[String: Any] = ["deepLink": resolvedLink.deepLink,"clickTimeStamp": Int(resolvedLink.clickTime.timeIntervalSince1970*1000),"socialTitle": (resolvedLink.socialTitle ?? "") as String,
                                              "socialDescription": (resolvedLink.socialDescription ?? "") as String,
                                              "socialImageUrl": (resolvedLink.socialImageUrl ?? "") as String,
                                              "campaignName": (resolvedLink.campaignName ?? "") as String,
                                              "campaignSource": (resolvedLink.campaignSource ?? "") as String,
                                              "campaignMedium": (resolvedLink.campaignMedium ?? "") as String
        ]
        return resolvedLinkList
    }
}
