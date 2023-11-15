/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

package com.huawei.agconnectauth.handlers;

import com.huawei.agconnectauth.AGConnectAuthModule;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGConnectAuthMethodCallHandler implements MethodCallHandler {

    private final AGConnectAuthModule agConnectAuthModule;

    public AGConnectAuthMethodCallHandler(AGConnectAuthModule agConnectAuthModule) {
        this.agConnectAuthModule = agConnectAuthModule;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "signIn":
                agConnectAuthModule.handleSignIn(call, result);
                break;
            case "signInAnonymously":
                agConnectAuthModule.handleSignInAnonymously(result);
                break;
            case "signOut":
                agConnectAuthModule.handleSignOut(result);
                break;
            case "deleteUser":
                agConnectAuthModule.handleDeleteUser(result);
                break;
            case "getCurrentUser":
                agConnectAuthModule.handleGetCurrentUser(result);
                break;
            case "createUserWithEmail":
                agConnectAuthModule.handleCreateUserWithEmail(call, result);
                break;
            case "createUserWithPhone":
                agConnectAuthModule.handleCreateUserWithPhone(call, result);
                break;
            case "resetPasswordWithEmail":
                agConnectAuthModule.handleResetPasswordWithEmail(call, result);
                break;
            case "resetPasswordWithPhone":
                agConnectAuthModule.handleResetPasswordWithPhone(call, result);
                break;
            case "link":
                agConnectAuthModule.handleLink(call, result);
                break;
            case "unlink":
                agConnectAuthModule.handleUnlink(call, result);
                break;
            case "updateEmail":
                agConnectAuthModule.handleUpdateEmail(call, result);
                break;
            case "updatePhone":
                agConnectAuthModule.handleUpdatePhone(call, result);
                break;
            case "updateProfile":
                agConnectAuthModule.handleUpdateProfile(call, result);
                break;
            case "updatePassword":
                agConnectAuthModule.handleUpdatePassword(call, result);
                break;
            case "getUserExtra":
                agConnectAuthModule.handleGetUserExtra(result);
                break;
            case "getToken":
                agConnectAuthModule.handleGetToken(call, result);
                break;
            case "requestEmailVerifyCode":
                agConnectAuthModule.handleRequestEmailVerifyCode(call, result);
                break;
            case "requestAuthEmailVerifyCode":
                agConnectAuthModule.handleAuthRequestEmailVerifyCode(call, result);
                break;
            case "requestPhoneVerifyCode":
                agConnectAuthModule.handleRequestPhoneVerifyCode(call, result);
                break;
            case "requestAuthPhoneVerifyCode":
                agConnectAuthModule.handleAuthRequestPhoneVerifyCode(call, result);
                break;
            case "setAutoCollectionAAID":
                agConnectAuthModule.handleSetAutoCollectionAAID(call,result);
                break;
            case "isAutoCollectionAAID":
                agConnectAuthModule.handleIsAutoCollectionAAID(result);
                break;
            case "getSupportedAuthList":
                agConnectAuthModule.handleGetSupportedAuthList(result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

}
