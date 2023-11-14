/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */
import Foundation
import AGConnectAuth

public protocol ViewModelDelegate: AnyObject {
    func post(result: FlutterResult)
    func postError(error: Error?, result: FlutterResult)
    func postData(data: Any?, result: FlutterResult)
}

public class AGConnectAuthViewModel {
    var delegate: ViewModelDelegate?
    private let userNilError = AGCAuthError(domain: "com.huawei.agc.auth", code: 2, userInfo: [NSDebugDescriptionErrorKey: "User Null"])

    func requestPhoneVerifyCode(countryCode: String, phoneNumber: String, settings: AGCVerifyCodeSettings, completion: @escaping FlutterResult) {

        AGCPhoneAuthProvider.requestVerifyCode(withCountryCode: countryCode, phoneNumber: phoneNumber, settings: settings).onSuccess(callback: {res in

            self.delegate?.postData(data: FlutterUtils.verifyCodeToDic(result: res), result: completion)
        }).onFailure(callback: { error in
            self.delegate?.postError(error: error, result: completion)
        })
    }

    func requestAuthPhoneVerifyCode(countryCode: String, phoneNumber: String, settings: AGCVerifyCodeSettings, completion: @escaping FlutterResult) {

        AGCAuth.instance().requestVerifyCode(withCountryCode: countryCode, phoneNumber: phoneNumber, settings: settings).onSuccess(callback: {res in

            self.delegate?.postData(data: FlutterUtils.verifyCodeToDic(result: res), result: completion)
        }).onFailure(callback: { error in
            self.delegate?.postError(error: error, result: completion)
        })
    }
    
    func createPhoneUser(countryCode: String, phoneNumber: String, verificationCode: String, password: String, completion: @escaping FlutterResult) {

        AGCAuth.instance().createUser(withCountryCode: countryCode, phoneNumber: phoneNumber, password: password, verifyCode: verificationCode).onSuccess(callback: { result in

            self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)

        }).onFailure(callback: { error in

            self.delegate?.postError(error: error, result: completion)

        })

    }

    func resetPhonePassword(countryCode: String, phoneNumber: String, newPassword: String, verificationCode: String, completion: @escaping FlutterResult) {

        AGCAuth.instance().resetPassword(withCountryCode: countryCode, phoneNumber: phoneNumber, newPassword: newPassword, verifyCode: verificationCode)

            .onSuccess(callback: { result in

                self.delegate?.postData(data: result, result: completion)

            }).onFailure(callback: { error in

                self.delegate?.postError(error: error, result: completion)

            })

    }

    func requestEmailVerifyCode(email: String, settings: AGCVerifyCodeSettings, completion: @escaping FlutterResult) {

        AGCEmailAuthProvider.requestVerifyCode(withEmail: email, settings: settings)

            .onSuccess(callback: { res in
                self.delegate?.postData(data: FlutterUtils.verifyCodeToDic(result: res), result: completion)

            }).onFailure(callback: { error in

                self.delegate?.postError(error: error, result: completion)

            })

    }
    
    func requestAuthEmailVerifyCode(email: String, settings: AGCVerifyCodeSettings, completion: @escaping FlutterResult) {

        AGCAuth.instance().requestVerifyCode(withEmail: email, settings: settings)

            .onSuccess(callback: { res in
                self.delegate?.postData(data: FlutterUtils.verifyCodeToDic(result: res), result: completion)

            }).onFailure(callback: { error in

                self.delegate?.postError(error: error, result: completion)

            })

    }

    func createEmailUser(email: String, verificationCode: String, password: String, completion: @escaping FlutterResult) {

        AGCAuth.instance().createUser(withEmail: email, password: password, verifyCode: verificationCode)

            .onSuccess(callback: { result in

                self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)

            }).onFailure(callback: { error in

                self.delegate?.postError(error: error, result: completion)

            })

    }

    func resetEmailPassword(email: String, newPassword: String, verificationCode: String, completion: @escaping FlutterResult) {

        AGCAuth.instance().resetPassword(withEmail: email, newPassword: newPassword, verifyCode: verificationCode)

            .onSuccess(callback: { result in

                self.delegate?.postData(data: result, result: completion)

            }).onFailure(callback: { error in

                self.delegate?.postError(error: error, result: completion)

            })
    }

    func signInAnonymously(completion: @escaping FlutterResult) {

        AGCAuth.instance().signInAnonymously()

            .onSuccess(callback: { result in

                self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)

            }).onFailure(callback: {error in

                self.delegate?.postError(error: error, result: completion)

            })
    }

    func signIn(credential: AGCAuthCredential, completion: @escaping FlutterResult) {

        AGCAuth.instance().signIn(credential: credential).onSuccess(callback: { result in
            self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
        }).onFailure(callback: { error in
            print("Error: \(error)")
            self.delegate?.postError(error: error, result: completion)
        })
    }

    func updatePhone(countryCode: String, phoneNumber: String, verificationCode: String, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.updatePhone(withCountryCode: countryCode, phoneNumber: phoneNumber, verifyCode: verificationCode)
                .onSuccess(callback: { result in
                    self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func updatePhoneWithLocale(countryCode: String, phoneNumber: String, verificationCode: String, locale: String, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.updatePhone(withCountryCode: countryCode, phoneNumber: phoneNumber, verifyCode: verificationCode, locale: Locale.init(identifier: locale ))
                .onSuccess(callback: { result in
                    self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func updatePassword(newPassword: String, verificationCode: String, provider: Int, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.updatePassword(newPassword, verifyCode: verificationCode, provider: provider)
                .onSuccess(callback: { result in
                    self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func updateEmail(email: String, verificationCode: String, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.updateEmail(email, verifyCode: verificationCode)
                .onSuccess(callback: { result in
                    self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func updateEmailWithLocale(email: String, verificationCode: String, locale: String, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.updateEmail(email, verifyCode: verificationCode, locale: Locale.init(identifier: locale))
                .onSuccess(callback: { result in
                    self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func updateProfile(profileRequest: AGCProfileRequest, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.updateProfile(profileRequest)
                .onSuccess(callback: { result in
                    self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func getToken(forceRefresh: Bool, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.getToken(forceRefresh)
                .onSuccess(callback: { result in

                    self.delegate?.postData(data: FlutterUtils.tokenToDic(token: result), result: completion)
                }).onFailure(callback: {error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func getUserExtra(completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.getExtra()
                .onSuccess(callback: { res in
                    let userExtra: [String: Any] = FlutterUtils.userExtraToDic(userExtra: res)
                    let map: [String: Any] = [
                        "userExtra": userExtra,
                        "user": FlutterUtils.userToDic(user: AGCAuth.instance().currentUser)
                    ]
                    self.delegate?.postData(data: map, result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func unLink(provider: AGCAuthProviderType, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.unlink(provider)
                .onSuccess(callback: { result in
                    self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }

    func link(credential: AGCAuthCredential, completion: @escaping FlutterResult) {
        if let user = AGCAuth.instance().currentUser {
            user.link(credential)
                .onSuccess(callback: { result in
                    self.delegate?.postData(data: FlutterUtils.userToDic(user: result?.user), result: completion)
                }).onFailure(callback: { error in
                    self.delegate?.postError(error: error, result: completion)
                })
        } else {
            self.delegate?.postError(error: userNilError, result: completion)
        }
    }
    
    func getAutoCollectionAAID(completion: @escaping FlutterResult)  {
        let isAutoCollection =  AGCAuth.instance().isAutoCollectionAAID()
        let map: [String:Any] = ["isAutoCollection": isAutoCollection]
        self.delegate?.postData(data: map, result: completion)
        
    }
    
    func setAutoCollectionAAID(isAutoCollection : Bool,completion: @escaping FlutterResult)  {
        AGCAuth.instance().setAutoCollectionAAID(isAutoCollection);
        self.delegate?.postData(data:nil, result: completion)
    }
    
    func getSupportedAuthList(completion: @escaping FlutterResult){
        let authList = AGCAuth.instance().supportProviders()
        let map: [String:Any] = ["supportedAuthList": authList]
        self.delegate?.postData(data: map, result: completion)
    }
}
