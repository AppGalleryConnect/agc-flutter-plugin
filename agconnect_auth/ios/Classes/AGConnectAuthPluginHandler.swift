/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */
import Flutter
import UIKit
import AGConnectCore
import AGConnectAuth

public class AGConnectAuthPluginHandler: NSObject, FlutterPlugin {

    let eventChannelHandler = AGConnectAuthEventHandler.init()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.huawei.flutter/agconnect_auth", binaryMessenger: registrar.messenger())
        let instance = AGConnectAuthPluginHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.initEventChannel(messenger: registrar.messenger())

        registrar.addApplicationDelegate(instance)
    }
    func initEventChannel(messenger: FlutterBinaryMessenger) {

        let eventChannel = FlutterEventChannel(name: "com.huawei.flutter.event/agconnect_auth", binaryMessenger:
                                                    messenger)

        eventChannel.setStreamHandler(eventChannelHandler)
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        AGCInstance.startUp()
        addTokenChangeListener()

        return true
    }

    func addTokenChangeListener() {
        AGCAuth.instance().addTokenListener({ [self] tokenSnapshot in

            eventChannelHandler.showData(tokenSnapshot)

        })
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        let method = Methods.init()
        let agconnectAuth = AGConnectAuthFlutter.init()
        switch call.method {

        case method.SIGN_IN:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            agconnectAuth.signIn(args["credential"] as! [String: Any], resolver: { (response) in
                result(response)
            })
        case method.SIGN_IN_ANONYMOUSLY:
            agconnectAuth.signInAnonymously({ (response) in
                result(response)
            })
        case method.SIGN_OUT:
            agconnectAuth.signOut({ (response) in
                result(response)
            })
        case method.DELETE_USER:
            agconnectAuth.deleteUser({ (response) in
                result(response)
            })
        case method.GET_CURRENT_USER:
            agconnectAuth.getUser({ (response) in
                result(response)
            })
        case method.CREATE_USER_WITH_EMAIL:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let email = args["email"] as? String else { return  }
            guard let password = args["password"] as? String else { return  }
            guard let verifyCode = args["verifyCode"] as? String else { return  }
            agconnectAuth.createEmailUser(email, withVerifyCode: verifyCode, withPassword: password, resolver: { (response) in
                result(response)
            })
        case method.CREATE_USER_WITH_PHONE:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let countryCode = args["countryCode"] as? String else { return  }
            guard let phoneNumber = args["phoneNumber"] as? String else { return  }
            guard let verifyCode = args["verifyCode"] as? String else { return  }
            guard let password = args["password"] as? String else { return  }
            agconnectAuth.createPhoneUser(countryCode, withPhoneNumber: phoneNumber, withVerifyCode: verifyCode, withPassword: password, resolver: { (response) in
                result(response)
            })
        case method.RESET_PASSWORD_WITH_EMAIL:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let email = args["email"] as? String else { return  }
            guard let verifyCode = args["verifyCode"] as? String else { return  }
            guard let password = args["password"] as? String else { return  }
            agconnectAuth.resetEmailPassword(email, withPassword: password, withVerifyCode: verifyCode, resolver: { (response) in
                result(response)
            })
        case method.RESET_PASSWORD_WITH_PHONE:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let countryCode = args["countryCode"] as? String else { return  }
            guard let phoneNumber = args["phoneNumber"] as? String else { return  }
            guard let verifyCode = args["verifyCode"] as? String else { return  }
            guard let password = args["password"] as? String else { return  }
            agconnectAuth.resetPhonePassword(countryCode, withPhoneNumber: phoneNumber, withPassword: password, withVerifyCode: verifyCode, resolver: { (response) in
                result(response)
            })
        case method.LINK:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            agconnectAuth.link(args["credential"] as! [String: Any], resolver: { (response) in
                result(response)
            })
        case method.UN_LINK:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let provider = args["provider"] as? Int else {
                return
            }
            agconnectAuth.unlink(provider, resolver: { (response) in
                result(response)
            })
        case method.UPDATE_PROFİLE:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            agconnectAuth.updateProfile(args, resolver: { (response) in
                result(response)
            })
        case method.UPDATE_EMAIL:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let email = args["email"] as? String else { return  }
            guard let verifyCode = args["verifyCode"] as? String else { return  }
            let localeLanguage = args["localeLanguage"]
            let localeCountry = args["localeCountry"]
            if localeCountry is NSString && localeLanguage is NSString {
                let locale = "\(localeLanguage)_\(localeCountry)"
                agconnectAuth.updateEmailWithLocale(email, withVerificationCode: verifyCode, withLocale: locale, resolver: { (response) in
                    result(response)
                })
            } else {
                agconnectAuth.updateEmail(email, withVerificationCode: verifyCode, resolver: { (response) in
                    result(response)
                })
            }
        case method.UPDATE_PHONE:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let countryCode = args["countryCode"] as? String else { return  }
            guard let phoneNumber = args["phoneNumber"] as? String else { return  }
            guard let verifyCode = args["verifyCode"] as? String else { return  }
            let localeLanguage = args["localeLanguage"]
            let localeCountry = args["localeCountry"]
            if localeCountry is NSString && localeLanguage is NSString {
                let locale = "\(localeLanguage)_\(localeCountry)"
                agconnectAuth.updatePhoneWithLocale(countryCode, withPhoneNumber: phoneNumber, withVerificationCode: verifyCode, withLocale: locale, resolver: { (response) in
                    result(response)
                })
            } else {
                agconnectAuth.updatePhone(countryCode, withPhoneNumber: phoneNumber, withVerificationCode: verifyCode, resolver: { (response) in
                    result(response)
                })
            }
        case method.UPDATE_PASSWORD:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let password = args["password"] as? String else { return  }
            guard let provider = args["provider"] as? Int else { return }
            guard let verifyCode = args["verifyCode"] as? String else { return  }
            agconnectAuth.updatePassword(password, withVerificationCode: verifyCode, withProvider: provider, resolver: { (response) in
                result(response)
            })
        case method.GET_USER_EXTRA:
            agconnectAuth.getUserExtra({ (response) in
                result(response)
            })
        case method.GET_TOKEN:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let forceRefresh = args["forceRefresh"] as? Bool else { return }
            agconnectAuth.getToken(forceRefresh, resolver: { (response) in
                result(response)
            })
        case method.REQUEST_EMAIL_VERFY_CODE:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let email = args["email"] as? String else { return  }
            guard let settings = args["settings"] as? [String: Any] else { return  }
            agconnectAuth.requestEmailVerifyCode(email, verifyCodeSettings: settings, resolver: { (response) in
                result(response)
            })
        case method.REQUEST_PHONE_VERFY_CODE:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let countryCode = args["countryCode"] as? String else { return  }
            guard let phoneNumber = args["phoneNumber"] as? String else { return  }
            guard let settings = args["settings"] as? [String: Any] else { return  }
            agconnectAuth.requestPhoneVerifyCode(countryCode, withPhoneNumber: phoneNumber, verifyCodeSettings: settings, resolver: { (response) in
                result(response)
            })
        case method.REQUEST_AUTH_EMAIL_VERFY_CODE:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let email = args["email"] as? String else { return  }
            guard let settings = args["settings"] as? [String: Any] else { return  }
            agconnectAuth.requestAuthEmailVerifyCode(email, verifyCodeSettings: settings, resolver: { (response) in
                result(response)
            })
        case method.REQUEST_AUTH_PHONE_VERFY_CODE:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let countryCode = args["countryCode"] as? String else { return  }
            guard let phoneNumber = args["phoneNumber"] as? String else { return  }
            guard let settings = args["settings"] as? [String: Any] else { return  }
            agconnectAuth.requestAuthPhoneVerifyCode(countryCode, withPhoneNumber: phoneNumber, verifyCodeSettings: settings, resolver: { (response) in
                result(response)
            })
        case method.GET_AUTO_COLLECTION_AAID:
            agconnectAuth.getAutoCollectionAAID({ (response) in
                result(response)
            })
        case method.SET_AUTO_COLLECTION_AAID:
            guard let args = call.arguments as? [String: Any] else {
                return
            }
            guard let isAutoCollection = args["isAutoCollection"] as? Bool else { return  }
            agconnectAuth.setAutoCollectionAAID(isAutoCollection,resolver: {(response) in
                result(response)
            })
        case method.GET_SUPPORTED_AUTH_LIST:
            agconnectAuth.getSupportedAuthList({ (response) in
                result(response)
            })
        default:
            result(FlutterError(code: "platformError", message: "Not supported on iOS platform", details: ""))
        }
    }
    struct Methods {
        let SIGN_IN = "signIn"
        let SIGN_IN_ANONYMOUSLY = "signInAnonymously"
        let SIGN_OUT = "signOut"
        let DELETE_USER = "deleteUser"
        let GET_CURRENT_USER = "getCurrentUser"
        let CREATE_USER_WITH_EMAIL = "createUserWithEmail"
        let CREATE_USER_WITH_PHONE = "createUserWithPhone"
        let RESET_PASSWORD_WITH_EMAIL = "resetPasswordWithEmail"
        let RESET_PASSWORD_WITH_PHONE = "resetPasswordWithPhone"
        let LINK = "link"
        let UN_LINK = "unlink"
        let UPDATE_PROFİLE = "updateProfile"
        let UPDATE_EMAIL = "updateEmail"
        let UPDATE_PHONE = "updatePhone"
        let UPDATE_PASSWORD = "updatePassword"
        let GET_USER_EXTRA = "getUserExtra"
        let GET_TOKEN = "getToken"
        let REQUEST_EMAIL_VERFY_CODE = "requestEmailVerifyCode"
        let REQUEST_PHONE_VERFY_CODE = "requestPhoneVerifyCode"
        let REQUEST_AUTH_EMAIL_VERFY_CODE = "requestAuthEmailVerifyCode"
        let REQUEST_AUTH_PHONE_VERFY_CODE = "requestAuthPhoneVerifyCode"
        let GET_AUTO_COLLECTION_AAID = "isAutoCollectionAAID"
        let SET_AUTO_COLLECTION_AAID = "setAutoCollectionAAID"
        let GET_SUPPORTED_AUTH_LIST = "getSupportedAuthList"
    }
}
