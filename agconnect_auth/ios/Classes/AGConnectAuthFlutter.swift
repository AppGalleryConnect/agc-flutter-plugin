/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */
import Foundation
import Flutter
import AGConnectAuth

@objc(AGConnectAuthFlutter)

/// Provides methods to initialize Auth Kit and implement analysis functions.
class AGConnectAuthFlutter: NSObject {

    /// All the AGCAuth API's can be reached via AGCAuthViewModel class instance
    private lazy var viewModel: AGConnectAuthViewModel = AGConnectAuthViewModel()
    private var listenerList = [String: (AGCTokenSnapshot) -> Void]()

    /// Returns current signed in user.
    /// - Parameters:
    ///   - resolve: In the success scenario, current signed in user will be returned
    @objc func getUser(_ resolve: @escaping FlutterResult) {
        Log.showInPanel(message: #function, type: .call)
        if let user = AGCAuth.instance().currentUser {
            Log.showInPanel(message: #function, type: .success)
            resolve(FlutterUtils.userToDic(user: user))
        } else {
            resolve(nil)
        }
    }
    /// Signs out a user and deletes the user's cached data.
    /// - Parameters:
    ///   - resolve: Returns true after the function execution is completed.
    @objc func signOut(_ resolve: @escaping FlutterResult) {
        Log.debug(#function) {
            AGCAuth.instance().signOut()
            resolve(nil)
        }
    }

    /// Deletes the current user information and cache information from the AppGallery Connect server.
    /// - Parameters:
    ///   - resolve: Returns true after the function execution is completed.
    @objc func deleteUser(_ resolve: @escaping FlutterResult) {
        Log.debug(#function) {
            viewModel.delegate = self
            AGCAuth.instance().deleteUser()
            resolve(nil)
        }
    }

    /// Applies for a verification code using a mobile number.
    /// - Parameters:
    ///   - countryCode: Country/Region code.
    ///   - phoneNumber: Mobile number.
    ///   - map: Verification code attributes, including the verification code application scenarios (such as registration, sign-in, and password resetting), language of the verification code message, and interval for sending verification codes.
    ///   - resolve: In the success scenario, VerifyCodeResult will be returned.
    @objc func requestPhoneVerifyCode(
        _ countryCode: String,
        withPhoneNumber phoneNumber: String,
        verifyCodeSettings map: [String: Any],
        resolver resolve: @escaping FlutterResult
    ) {
        Log.showInPanel(message: #function, type: .call)
        var locale = ""
        var sendInterval = 30
        guard let action = map["action"] as? Int else { return }
        if let lang = map["locale"] as? String {
            locale = lang
        }
        if let interval = map["sendInterval"] as? Int {
            sendInterval = interval
        }
        let agcAction: AGCVerifyCodeAction = action == 0 ? AGCVerifyCodeAction.registerLogin : AGCVerifyCodeAction.resetPassword
        let setting = AGCVerifyCodeSettings.init(action: agcAction, locale: Locale.init(identifier: locale), sendInterval: sendInterval)
        viewModel.delegate = self
        viewModel.requestPhoneVerifyCode(countryCode: countryCode, phoneNumber: phoneNumber, settings: setting, completion: resolve)
    }
    
    /// Applies for a verification code using a mobile number.
    /// - Parameters:
    ///   - countryCode: Country/Region code.
    ///   - phoneNumber: Mobile number.
    ///   - map: Verification code attributes, including the verification code application scenarios (such as registration, sign-in, and password resetting), language of the verification code message, and interval for sending verification codes.
    ///   - resolve: In the success scenario, VerifyCodeResult will be returned.
    @objc func requestAuthPhoneVerifyCode(
        _ countryCode: String,
        withPhoneNumber phoneNumber: String,
        verifyCodeSettings map: [String: Any],
        resolver resolve: @escaping FlutterResult
    ) {
        Log.showInPanel(message: #function, type: .call)
        var locale = ""
        var sendInterval = 30
        guard let action = map["action"] as? Int else { return }
        if let lang = map["locale"] as? String {
            locale = lang
        }
        if let interval = map["sendInterval"] as? Int {
            sendInterval = interval
        }
        let agcAction: AGCVerifyCodeAction = action == 0 ? AGCVerifyCodeAction.registerLogin : AGCVerifyCodeAction.resetPassword
        let setting = AGCVerifyCodeSettings.init(action: agcAction, locale: Locale.init(identifier: locale), sendInterval: sendInterval)
        viewModel.delegate = self
        viewModel.requestAuthPhoneVerifyCode(countryCode: countryCode, phoneNumber: phoneNumber, settings: setting, completion: resolve)
    }

    /// Creates an account using a mobile number.
    /// - Parameters:
    ///   - countryCode: Country/Region code.
    ///   - phoneNumber: Mobile number.
    ///   - verificationCode: Verification code.
    ///   - password: Password.
    ///   - resolve: In the success scenario, user will be signed in and returned.
    @objc func createPhoneUser(
        _ countryCode: String,
        withPhoneNumber phoneNumber: String,
        withVerifyCode verificationCode: String,
        withPassword password: String,
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.createPhoneUser(countryCode: countryCode, phoneNumber: phoneNumber, verificationCode: verificationCode, password: password, completion: resolve)
    }

    /// Resets a user's password using the mobile number.
    /// - Parameters:
    ///   - countryCode: Country/Region code.
    ///   - phoneNumber: Mobile number.
    ///   - newPassword:  New password.
    ///   - verificationCode: Verification code.
    ///   - resolve: In the success scenario, true value will be returned.
    @objc func resetPhonePassword(
        _ countryCode: String,
        withPhoneNumber phoneNumber: String,
        withPassword newPassword: String,
        withVerifyCode verificationCode: String,
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.resetPhonePassword(countryCode: countryCode, phoneNumber: phoneNumber, newPassword: newPassword, verificationCode: verificationCode, completion: resolve)
    }

    /// Applies for a verification code using an email address.
    /// - Parameters:
    ///   - email: Email address.
    ///   - map: Verification code attributes, including the verification code application scenarios (such as registration, sign-in, and password resetting), language of the verification code message, and interval for sending verification codes.
    ///   - resolve: In the success scenario, VerifyCodeResult will be returned.
    @objc func requestEmailVerifyCode(
        _ email: String,
        verifyCodeSettings map: [String: Any],
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        var locale = ""
        var sendInterval = 30
        guard let action = map["action"] as? Int else { return }
        if let lang = map["locale"] as? String {
            locale = lang
        }
        if let interval = map["sendInterval"] as? Int {
            sendInterval = interval
        }
        let agcAction: AGCVerifyCodeAction = action == 0 ? AGCVerifyCodeAction.registerLogin : AGCVerifyCodeAction.resetPassword
        let setting = AGCVerifyCodeSettings.init(action: agcAction, locale: Locale.init(identifier: locale), sendInterval: sendInterval)
        viewModel.delegate = self
        viewModel.requestEmailVerifyCode(email: email, settings: setting, completion: resolve)
    }
    
    /// Applies for a verification code using an email address.
    /// - Parameters:
    ///   - email: Email address.
    ///   - map: Verification code attributes, including the verification code application scenarios (such as registration, sign-in, and password resetting), language of the verification code message, and interval for sending verification codes.
    ///   - resolve: In the success scenario, VerifyCodeResult will be returned.
    @objc func requestAuthEmailVerifyCode(
        _ email: String,
        verifyCodeSettings map: [String: Any],
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        var locale = ""
        var sendInterval = 30
        guard let action = map["action"] as? Int else { return }
        if let lang = map["locale"] as? String {
            locale = lang
        }
        if let interval = map["sendInterval"] as? Int {
            sendInterval = interval
        }
        let agcAction: AGCVerifyCodeAction = action == 0 ? AGCVerifyCodeAction.registerLogin : AGCVerifyCodeAction.resetPassword
        let setting = AGCVerifyCodeSettings.init(action: agcAction, locale: Locale.init(identifier: locale), sendInterval: sendInterval)
        viewModel.delegate = self
        viewModel.requestAuthEmailVerifyCode(email: email, settings: setting, completion: resolve)
    }

    /// Creates an account using an email address.
    /// - Parameters:
    ///   - email: Email address.
    ///   - verificationCode: Verification code.
    ///   - password: Password.
    ///   - resolve: In the success scenario, user will be signed in and returned.
    @objc func createEmailUser(
        _ email: String,
        withVerifyCode verificationCode: String,
        withPassword password: String,
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.createEmailUser(email: email, verificationCode: verificationCode, password: password, completion: resolve)
    }

    /// Resets a user's password using the email address.
    /// - Parameters:
    ///   - email: Email address.
    ///   - newPassword: New password.
    ///   - verificationCode: Verification code.
    ///   - resolve: In the success scenario, true value will be returned.
    @objc func resetEmailPassword(
        _ email: String,
        withPassword newPassword: String,
        withVerifyCode verificationCode: String,
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.resetEmailPassword(email: email, newPassword: newPassword, verificationCode: verificationCode, completion: resolve)
    }

    /// Signs in a user anonymously.
    /// - Parameters:
    ///   - resolve: In the success scenario, user will be signed in and returned.
    @objc func signInAnonymously(_ resolve: @escaping FlutterResult) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.signInAnonymously(completion: resolve)
    }

    /// Signs in a user to AppGallery Connect.
    /// - Parameters:
    ///   - provider: Auth Provider type that user will be used to sign in
    ///   - credential: Authentication credential, which must be created using the corresponding Auth Provider type.
    ///   - resolve: In the success scenario, user will be signed in and returned.
    @objc func signIn(
        _ credential: [String: Any],
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        guard let provider = credential["provider"] as? Int else { return }
        switch provider {
        case AGCAuthProviderType.phone.rawValue:
            signInWithPhone(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.email.rawValue:
            signInWithEmail(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.apple.rawValue:
            signInWithApple(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.weiXin.rawValue:
            signInWithWeixin(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.facebook.rawValue:
            signInWithFacebook(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.twitter.rawValue:
            signInWithTwitter(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.weiBo.rawValue:
            signInWithWeibo(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.QQ.rawValue:
            signInWithQQ(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.google.rawValue:
            signInWithGoogle(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.selfBuild.rawValue:
            signInWithSelfBuild(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.alipay.rawValue:
            signInWithAlipay(credentailDic: credential, resolve: resolve)
            break
        default:
            Log.showInPanel(message: #function, type: .fail)
            print("This provider is not supported.")
            return
        }
    }

    /// Updates the mobile number of the current user.
    /// - Parameters:
    ///   - countryCode: Country/Region code.
    ///   - phoneNumber: New Mobile number.
    ///   - verificationCode: Verification code send to the phone number.
    ///   - resolve: In the success scenario, true value will be returned.
    @objc func updatePhone(_ countryCode: String, withPhoneNumber phoneNumber: String, withVerificationCode verificationCode: String, resolver resolve: @escaping FlutterResult ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.updatePhone(countryCode: countryCode, phoneNumber: phoneNumber, verificationCode: verificationCode, completion: resolve)
    }

    /// Updates the mobile number of the current user.
    /// - Parameters:
    ///   - countryCode: Country/Region code.
    ///   - phoneNumber: New Mobile number.
    ///   - verificationCode: Verification code send to the phone number.
    ///   - locale: Language in which the verification code message is sent.
    ///   - resolve: In the success scenario, true value will be returned.
    @objc func updatePhoneWithLocale(_ countryCode: String, withPhoneNumber phoneNumber: String, withVerificationCode verificationCode: String, withLocale locale: String, resolver resolve: @escaping FlutterResult ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.updatePhoneWithLocale(countryCode: countryCode, phoneNumber: phoneNumber, verificationCode: verificationCode, locale: locale, completion: resolve)
    }

    /// Updates the current user's password.
    /// - Parameters:
    ///   - newPassword: New password.
    ///   - verificationCode: Verification code.
    ///   - provider: Provider type, which is used to differentiate the email address from mobile number.
    ///   - resolve: In the success scenario, true value will be returned.

    @objc func updatePassword(_ newPassword: String, withVerificationCode verificationCode: String, withProvider provider: Int, resolver resolve: @escaping FlutterResult ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.updatePassword(newPassword: newPassword, verificationCode: verificationCode, provider: provider, completion: resolve)
    }

    /// Updates the current user's email address.
    /// - Parameters:
    ///   - email: New email address.
    ///   - verificationCode: Verification code sent to the email address.
    ///   - resolve: In the success scenario, true value will be returned.
    @objc func updateEmail(_ email: String, withVerificationCode verificationCode: String, resolver resolve: @escaping FlutterResult ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.updateEmail(email: email, verificationCode: verificationCode, completion: resolve)
    }

    /// Updates the current user's email address.
    /// - Parameters:
    ///   - email: New email address.
    ///   - verificationCode: Verification code sent to the email address.
    ///   - locale: Language in which the verification code email is sent.
    ///   - resolve: In the success scenario, true value will be returned.
    @objc func updateEmailWithLocale(_ email: String, withVerificationCode verificationCode: String, withLocale locale: String, resolver resolve: @escaping FlutterResult ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.updateEmailWithLocale(email: email, verificationCode: verificationCode, locale: locale, completion: resolve)
    }

    /// Updates information (profile picture and nickname) for the current user.
    /// - Parameters:
    ///   - profileInfo: Profile information to be modified.
    ///   - resolve: In the success scenario, true value will be returned.
    @objc func updateProfile(
        _ profileInfo: [String: Any],
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        let profile = AGCProfileRequest()
        if let displayName = profileInfo["displayName"] as? String {
            profile.displayName = displayName
        }
        if let photoUrl = profileInfo["photoUrl"] as? String {
            profile.photoUrl = photoUrl
        }
        viewModel.delegate = self
        viewModel.updateProfile(profileRequest: profile, completion: resolve)
    }

    /// Obtains the access token of a user from AppGallery Connect.
    /// - Parameters:
    ///   - forceRefresh: Indicates whether to forcibly update the access token of a user.
    ///   - resolve: In the success scenario, TokenResult will be returned.
    @objc func getToken(
        _ forceRefresh: Bool,
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.getToken(forceRefresh: forceRefresh, completion: resolve)
    }

    /// Obtains UserExtra of the current user.
    /// - Parameters:
    ///   - resolve: In the success scenario, AGCUserExtra will be returned.
    @objc func getUserExtra(_ resolve: @escaping FlutterResult ) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.getUserExtra(completion: resolve)
    }

    /// Unlinks the current user from the linked authentication mode.
    /// - Parameters:
    ///   - provider: Authentication mode to be unlinked.
    ///   - resolve: In the success scenario, current signed in user will be returned.
    @objc func unlink(_ provider: Int, resolver resolve: @escaping FlutterResult ) {
        Log.showInPanel(message: #function, type: .call)
        if let agcAuthProvider = AGCAuthProviderType.init(rawValue: provider) {
            viewModel.delegate = self
            viewModel.unLink(provider: agcAuthProvider, completion: resolve)
        }
    }

    /// Links a new authentication mode for the current user.
    /// - Parameters:
    ///   - provider: Auth Provider type that will be linked to user.
    ///   - credential: Credential of a new authentication mode.
    ///   - resolve: In the success scenario, current signed in user will be returned.
    @objc func link(
        _ credential: [String: Any],
        resolver resolve: @escaping FlutterResult

    ) {
        Log.showInPanel(message: #function, type: .call)
        guard let provider = credential["provider"] as? Int else { return }
        switch provider {
        case AGCAuthProviderType.phone.rawValue:
            linkPhone(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.email.rawValue:
            linkEmail(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.apple.rawValue:
            linkApple(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.weiXin.rawValue:
            linkWeixin(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.facebook.rawValue:
            linkFacebook(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.twitter.rawValue:
            linkTwitter(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.weiBo.rawValue:
            linkWeibo(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.QQ.rawValue:
            linkQQ(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.google.rawValue:
            linkGoogle(credentailDic: credential, resolve: resolve)
            break
        case AGCAuthProviderType.selfBuild.rawValue:
            linkSelfBuild(credentailDic: credential, resolve: resolve)
            break
        default:
            Log.showInPanel(message: #function, type: .fail)
            return
        }
    }
    
    /// Get AutoCollectionAAID.
    /// - Parameters:
    ///   - resolve: In the success scenario, AutoCollectionAAID will be returned.
    @objc func getAutoCollectionAAID(_ resolve: @escaping FlutterResult) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.getAutoCollectionAAID(completion: resolve)
    }
    
    /// Set AutoCollectionAAID.
    /// - Parameters:
    ///   - resolve: In the success scenario, AutoCollectionAAID will be set.
    @objc func setAutoCollectionAAID(_ isAutoCollection : Bool,resolver resolve: @escaping FlutterResult) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.setAutoCollectionAAID(isAutoCollection: isAutoCollection, completion: resolve)
    }
    
    /// Obtains the list of supported authentication modes.
    /// - Parameters:
    ///   - resolve: In the success scenario, supported authentication modes returned.
    @objc func getSupportedAuthList(_ resolve: @escaping FlutterResult) {
        Log.showInPanel(message: #function, type: .call)
        viewModel.delegate = self
        viewModel.getSupportedAuthList(completion: resolve)
    }

    // MARK: - Private Helper Functions

    private func linkPhone(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var countryCode: String = ""
        var phoneNumber: String = ""
        var verificationCode = ""
        if let code = credentailDic["countryCode"] as? String {
            countryCode = code
        }
        if let number = credentailDic["phoneNumber"] as? String {
            phoneNumber = number
        }
        if let verifyCode = credentailDic["verifyCode"] as? String {
            verificationCode = verifyCode
        }
        let credential = AGCPhoneAuthProvider.credential(withCountryCode: countryCode, phoneNumber: phoneNumber, password: nil, verifyCode: verificationCode)
        linkHandler(credential: credential, resolve: resolve)
    }

    private func linkEmail(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var email = ""
        var verificationCode = ""
        if let mail = credentailDic["email"] as? String {
            email = mail
        }
        if let verifyCode = credentailDic["verifyCode"] as? String {
            verificationCode = verifyCode
        }
        let credential = AGCEmailAuthProvider.credential(withEmail: email, password: nil, verifyCode: verificationCode)
        linkHandler(credential: credential, resolve: resolve)
    }

    private func linkApple(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var identityToken = ""
        var nonce = ""
        if let token = credentailDic["identityToken"] as? String {
            identityToken = token
        }
        if let random = credentailDic["nonce"] as? String {
            nonce = random
        }
        let credential = AGCAppleIDAuthProvider.credential(withIdentityToken: Data(identityToken.utf8), nonce: nonce)
        linkHandler(credential: credential, resolve: resolve)
    }

    private func linkWeixin(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var accessToken = ""
        var openId = ""
        if let token = credentailDic["accessToken"] as? String {
            accessToken = token
        }
        if let id = credentailDic["openId"] as? String {
            openId = id
        }
        let credentail = AGCWeiXinAuthProvider.credential(withToken: accessToken, openId: openId)
        linkHandler(credential: credentail, resolve: resolve)
    }

    private func linkFacebook(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var accessToken = ""
        if let token = credentailDic["accessToken"] as? String {
            accessToken = token
        }
        let credentail = AGCFacebookAuthProvider.credential(withToken: accessToken)
        linkHandler(credential: credentail, resolve: resolve)
    }

    private func linkTwitter(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var token = ""
        var secret = ""
        if let accessToken = credentailDic["token"] as? String {
            token = accessToken
        }
        if let secretId = credentailDic["secret"] as? String {
            secret = secretId
        }
        let credentail = AGCTwitterAuthProvider.credential(withToken: token, secret: secret)
        linkHandler(credential: credentail, resolve: resolve)
    }

    private func linkWeibo(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var token = ""
        var uid = ""
        if let accessToken = credentailDic["token"] as? String {
            token = accessToken
        }
        if let id = credentailDic["uid"] as? String {
            uid = id
        }

        let credentail = AGCWeiboAuthProvider.credential(withToken: token, uid: uid)
        linkHandler(credential: credentail, resolve: resolve)
    }

    private func linkQQ(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var accessToken = ""
        var openId = ""
        if let token = credentailDic["accessToken"] as? String {
            accessToken = token
        }
        if let id = credentailDic["openId"] as? String {
            openId = id
        }
        let credentail = AGCQQAuthProvider.credential(withToken: accessToken, openId: openId)
        linkHandler(credential: credentail, resolve: resolve)
    }

    private func linkGoogle(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var idToken = ""
        if let token = credentailDic["idToken"] as? String {
            idToken = token
        }
        let credentail = AGCGoogleAuthProvider.credential(withToken: idToken)
        linkHandler(credential: credentail, resolve: resolve)
    }

    private func linkSelfBuild(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var token = ""
        if let accessToken = credentailDic["token"] as? String {
            token = accessToken
        }
        let credentail = AGCSelfBuildAuthProvider.credential(withToken: token)
        linkHandler(credential: credentail, resolve: resolve)
    }

    private func linkHandler(credential: AGCAuthCredential, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.link(credential: credential, completion: resolve)
    }

    // MARK: - Private Helper Functions

    private func signInWithPhone(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        if credentailDic.keys.contains("verifyCode") {
            signInPhoneWithVerification(credentailDic: credentailDic, resolve: resolve)
        } else {
            signInPhoneWithPassword(credentailDic: credentailDic, resolve: resolve)
        }
    }

    private func signInPhoneWithPassword(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var countryCode: String = ""
        var phoneNumber: String = ""
        var password: String = ""
        if let code = credentailDic["countryCode"] as? String {
            countryCode = code
        }
        if let number = credentailDic["phoneNumber"] as? String {
            phoneNumber = number
        }
        if let pass = credentailDic["password"] as? String {
            password = pass
        }
        let credential = AGCPhoneAuthProvider.credential(withCountryCode: countryCode, phoneNumber: phoneNumber, password: password)
        signInHandler(credential: credential, resolve: resolve)
    }

    private func signInPhoneWithVerification(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var countryCode: String = ""
        var phoneNumber: String = ""
        var password: String?
        var verificationCode = ""
        if let code = credentailDic["countryCode"] as? String {
            countryCode = code
        }
        if let number = credentailDic["phoneNumber"] as? String {
            phoneNumber = number
        }
        if let pass = credentailDic["password"] as? String {
            password = pass
        }
        if let verifyCode = credentailDic["verifyCode"] as? String {
            verificationCode = verifyCode
        }
        let credential = AGCPhoneAuthProvider.credential(withCountryCode: countryCode, phoneNumber: phoneNumber, password: password, verifyCode: verificationCode)
        signInHandler(credential: credential, resolve: resolve)
    }

    private func signInWithEmail(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        if credentailDic.keys.contains("verifyCode") {
            signInEmailWithVerification(credentailDic: credentailDic, resolve: resolve)
        } else {
            signInEmailWithPassword(credentailDic: credentailDic, resolve: resolve)
        }
    }

    private func signInEmailWithPassword(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var email = ""
        var password: String = ""
        if let mail = credentailDic["email"] as? String {
            email = mail
        }
        if let pass = credentailDic["password"] as? String {
            password = pass
        }
        let credential = AGCEmailAuthProvider.credential(withEmail: email, password: password)
        signInHandler(credential: credential, resolve: resolve)
    }

    private func signInEmailWithVerification(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var email = ""
        var password: String?
        var verificationCode = ""
        if let mail = credentailDic["email"] as? String {
            email = mail
        }
        if let pass = credentailDic["password"] as? String {
            password = pass
        }
        if let verifyCode = credentailDic["verifyCode"] as? String {
            verificationCode = verifyCode
        }
        let credential = AGCEmailAuthProvider.credential(withEmail: email, password: password, verifyCode: verificationCode)
        signInHandler(credential: credential, resolve: resolve)
    }

    private func signInWithApple(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var identityToken = ""
        var nonce = ""
        var autoCreateUser = true
        if let token = credentailDic["identityToken"] as? String {
            identityToken = token
        }
        if let random = credentailDic["nonce"] as? String {
            nonce = random
        }
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }

        let credential = AGCAppleIDAuthProvider.credential(withIdentityToken: Data(identityToken.utf8), nonce: nonce, autoCreateUser: autoCreateUser)
        signInHandler(credential: credential, resolve: resolve)
    }

    private func signInWithWeixin(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var accessToken = ""
        var openId = ""
        var autoCreateUser = true
        if let token = credentailDic["accessToken"] as? String {
            accessToken = token
        }
        if let id = credentailDic["openId"] as? String {
            openId = id
        }
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }
        let credentail = AGCWeiXinAuthProvider.credential(withToken: accessToken, openId: openId, autoCreateUser: autoCreateUser)
        signInHandler(credential: credentail, resolve: resolve)
    }

    private func signInWithFacebook(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var accessToken = ""
        var autoCreateUser = true
        if let token = credentailDic["accessToken"] as? String {
            accessToken = token
        }
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }
        let credentail = AGCFacebookAuthProvider.credential(withToken: accessToken, autoCreateUser: autoCreateUser)
        signInHandler(credential: credentail, resolve: resolve)
    }

    private func signInWithTwitter(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var _v2 = false
        if let v2 = credentailDic["v2"] as? Bool {
            _v2 = v2
        }
        var autoCreateUser = true
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }
        if _v2 {
            var clientId = ""
            var authCode = ""
            var codeVerifier = ""
            var redirectUrl = ""
            
            if let _clientId = credentailDic["clientId"] as? String {
                clientId = _clientId
            }
            if let _authCode = credentailDic["authCode"] as? String {
                authCode = _authCode
            }
            if let _codeVerifier = credentailDic["codeVerifier"] as? String {
                codeVerifier = _codeVerifier
            }
            if let _redirectUrl = credentailDic["redirectUrl"] as? String {
                redirectUrl = _redirectUrl
            }
            var param=AGCTwitterAuthParam(clientId: clientId, authCode: authCode, codeVerifier: codeVerifier, redirectUrl: redirectUrl)
            let credentail = AGCTwitterAuthProvider.credential(with: param, autoCreateUser: autoCreateUser)
            signInHandler(credential: credentail, resolve: resolve)
        }
        else {
            var token = ""
            var secret = ""
            
            if let accessToken = credentailDic["token"] as? String {
                token = accessToken
            }
            if let secretId = credentailDic["secret"] as? String {
                secret = secretId
            }
            let credentail = AGCTwitterAuthProvider.credential(withToken: token, secret: secret, autoCreateUser: autoCreateUser)
            signInHandler(credential: credentail, resolve: resolve)
        }
        
    }

    private func signInWithWeibo(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var token = ""
        var uid = ""
        var autoCreateUser = true
        if let accessToken = credentailDic["token"] as? String {
            token = accessToken
        }
        if let id = credentailDic["uid"] as? String {
            uid = id
        }
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }
        let credentail = AGCWeiboAuthProvider.credential(withToken: token, uid: uid, autoCreateUser: autoCreateUser)
        signInHandler(credential: credentail, resolve: resolve)
    }

    private func signInWithQQ(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var accessToken = ""
        var openId = ""
        var autoCreateUser = true
        if let token = credentailDic["accessToken"] as? String {
            accessToken = token
        }
        if let id = credentailDic["openId"] as? String {
            openId = id
        }
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }
        let credentail = AGCQQAuthProvider.credential(withToken: accessToken, openId: openId, autoCreateUser: autoCreateUser)
        signInHandler(credential: credentail, resolve: resolve)
    }

    private func signInWithGoogle(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var idToken = ""
        var autoCreateUser = true
        if let token = credentailDic["idToken"] as? String {
            idToken = token
        }
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }
        let credentail = AGCGoogleAuthProvider.credential(withToken: idToken, autoCreateUser: autoCreateUser)
        signInHandler(credential: credentail, resolve: resolve)
    }

    private func signInWithSelfBuild(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var token = ""
        var autoCreateUser = true
        if let accessToken = credentailDic["token"] as? String {
            token = accessToken
        }
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }
        let credentail = AGCSelfBuildAuthProvider.credential(withToken: token, autoCreateUser: autoCreateUser)
        signInHandler(credential: credentail, resolve: resolve)
    }
    
    private func signInWithAlipay(credentailDic: [String: Any], resolve: @escaping FlutterResult) {
        var authCode = ""
        var autoCreateUser = true
        if let accessToken = credentailDic["authCode"] as? String {
            authCode = accessToken
        }
        if let createUser = credentailDic["autoCreateUser"] as? Bool {
            autoCreateUser = createUser
        }
        let credential = AGCAlipayAuthProvider.credential(withAuthCode: authCode, autoCreateUser: autoCreateUser)
        signInHandler(credential: credential, resolve: resolve)
    }

    private func signInHandler(credential: AGCAuthCredential, resolve: @escaping FlutterResult) {
        viewModel.delegate = self
        viewModel.signIn(credential: credential, completion: resolve)
    }
}
extension AGConnectAuthFlutter: ViewModelDelegate {
    func postData(data: Any?, result: (Any?) -> Void) {
        result(data)
    }
    func post(result: (Any?) -> Void) {
        result("Success")
    }
    func postError(error: Error?, result: FlutterResult) {
        let error = error as NSError?
        var exceptionCode = error?.code
        if error is AGCAuthError {
            exceptionCode = error?.code
        }
        result(FlutterError(
                code: error?.code.description ?? "",
                message: error?.localizedDescription,
                details: [
                    "exceptionCode": NSNumber(value: exceptionCode!)
                ]))
    }
}
