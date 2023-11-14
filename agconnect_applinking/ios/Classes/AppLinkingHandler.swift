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

import Flutter
import UIKit
import AGConnectCore
import AGConnectAppLinking

public class AppLinkingHandler: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.huawei.agc.flutter.applinking_methodchannel", binaryMessenger:
                                            registrar.messenger())
        let instance = AppLinkingHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
        let eventChannel = FlutterEventChannel(name: "com.huawei.agc.flutter.applinking_eventchannel", binaryMessenger:
                                                registrar.messenger())
        eventChannel.setStreamHandler(AppLinkingEventHandler())
    }
    
    var resolvedLinkData:AGCResolvedLink?
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        AGCInstance.startUp()
        
        AGCAppLinking.instance().handle { [weak self] (link, error) in
            var userInfo = [String:Any]()
            guard let strongSelf = self else {return}
            if (error != nil) {
                userInfo["resolvedLink"] = error
            }else {
                let link = link
                strongSelf.resolvedLinkData = link
                userInfo["resolvedLink"] = link
            }
            NotificationCenter.default
                .post(name: NSNotification.Name(rawValue: "AGCApplinkingNotification"), object: nil, userInfo: userInfo)
            
        }
        return true
    }
    private func application(_ application: UIApplication, continueUserActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool  {
        let isAppLinking = AGCAppLinking.instance().continueUserActivity(continueUserActivity)
        
        return isAppLinking
    }
    public func application(_ app: UIApplication, open url: URL, options:
                                [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let isAppLinking = AGCAppLinking.instance().openDeepLinkURL(url)
        return isAppLinking
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        guard let args = call.arguments as? NSDictionary else {
            return
        }
        let method = Methods.init()
        let agcAppLinking = FlutterAGCAppLinking.init()
        print(call.method)
        switch call.method {
        
        case method.BUILD_LONG_APP_LINKING:
            agcAppLinking.buildLongAppLinking(args, resolve: { (response) in
                result(response)
            })
            
        case method.BUILD_SHORT_APP_LINKING:
            
            agcAppLinking.buildShortAppLinking(args, resolve: { (response) in
                result(response)
            })
        default:
            result(FlutterError(code: "platformError", message: "Not supported on iOS platform", details: ""));
        }
    }
    
    struct Methods {
        let BUILD_SHORT_APP_LINKING = "buildShortAppLinking"
        let BUILD_LONG_APP_LINKING = "buildLongAppLinking"
        let ENABLE_LOGGER = "enableLogger"
        let DISABLE_LOGGER = "disableLogger"
        
    }
}
