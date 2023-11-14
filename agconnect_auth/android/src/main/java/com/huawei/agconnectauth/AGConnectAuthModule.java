/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

package com.huawei.agconnectauth;

import com.huawei.agconnectauth.viewmodel.AGConnectAuthViewModel;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGConnectAuthModule {
    // ViewModel instance
    private final AGConnectAuthViewModel viewModel;

    /**
     * Initialization of AgcAppMessagingModule in Flutter Side.
     */
    public AGConnectAuthModule() {
        viewModel = new AGConnectAuthViewModel();
    }

    /**
     * Returns current signed in user.
     *
     * @param result: In the success scenario, current signed in user will be returned, or AGCAuthException will be
     *                returned  in the failure scenario.
     */
    public void handleGetCurrentUser(Result result) {
        viewModel.handleGetCurrentUser(result);
    }

    /**
     * Applies for a verification code using a mobile number.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be
     *                    returned  in the failure scenario.
     */
    public void handleRequestPhoneVerifyCode(MethodCall methodCall, Result result) {
        viewModel.handleRequestPhoneVerifyCode(methodCall, result);
    }

    /**
     * Applies for a verification code using a mobile number.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be
     *                    returned  in the failure scenario.
     */
    public void handleAuthRequestPhoneVerifyCode(MethodCall methodCall, Result result) {
        viewModel.handleAuthRequestPhoneVerifyCode(methodCall, result);
    }

    /**
     * Applies for a verification code using an email address.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be
     *                    returned in the failure scenario.
     */
    public void handleRequestEmailVerifyCode(MethodCall methodCall, Result result) {
        viewModel.handleRequestEmailVerifyCode(methodCall, result);
    }

    /**
     * Applies for a verification code using an email address.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be
     *                    returned in the failure scenario.
     */
    public void handleAuthRequestEmailVerifyCode(MethodCall methodCall, Result result) {
        viewModel.handleAuthRequestEmailVerifyCode(methodCall, result);
    }


    /**
     * Creates an account using a mobile number.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, user will be signed in and returned, or AGCAuthException will be
     *                    returned  in the failure scenario.
     */
    public void handleCreateUserWithPhone(MethodCall methodCall, Result result) {
        viewModel.handleCreateUserWithPhone(methodCall, result);
    }

    /**
     * Creates an account using an email address.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, user will be signed in and returned, or AGCAuthException will be
     *                    returned  in the failure scenario.
     */
    public void handleCreateUserWithEmail(MethodCall methodCall, Result result) {
        viewModel.handleCreateUserWithEmail(methodCall, result);
    }

    /**
     * Deletes the current user information and cache information from the AppGallery Connect server.
     *
     * @param result: Returns true after the function execution is completed.
     */
    public void handleDeleteUser(Result result) {
        viewModel.handleDeleteUser(result);
    }

    /**
     * Signs out a user and deletes the user's cached data.
     *
     * @param result: Returns true after the function execution is completed.
     */
    public void handleSignOut(Result result) {
        viewModel.handleSignOut(result);
    }

    /**
     * Signs in a user anonymously.
     *
     * @param result: In the success scenario, user will be signed in and returned, or AGCAuthException will be returned
     *                in the failure scenario.
     */
    public void handleSignInAnonymously(Result result) {
        viewModel.handleSignInAnonymously(result);
    }

    /**
     * Resets a user's password using the mobile number.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, true value will be returned, or AGCAuthException will be returned  in
     *                    the failure scenario.
     */
    public void handleResetPasswordWithPhone(MethodCall methodCall, Result result) {
        viewModel.handleResetPasswordWithPhone(methodCall, result);
    }

    /**
     * Resets a user's password using the email address.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, true value will be returned, or AGCAuthException will be returned  in
     *                    the failure scenario.
     */
    public void handleResetPasswordWithEmail(MethodCall methodCall, Result result) {
        viewModel.handleResetPasswordWithEmail(methodCall, result);
    }

    /**
     * Signs in a user to AppGallery Connect.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, user will be signed in and returned, or AGCAuthException will be
     *                    returned in the failure scenario.
     */
    public void handleSignIn(MethodCall methodCall, Result result) {
        viewModel.handleSignIn(methodCall, result);
    }

    /**
     * Updates the mobile number of the current user.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, true value will be returned, or AGCAuthException will be returned  in
     *                    the failure scenario.
     */
    public void handleUpdatePhone(MethodCall methodCall, Result result) {
        viewModel.handleUpdatePhone(methodCall, result);
    }

    /**
     * Updates the current user's password.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, true value will be returned, or AGCAuthException will be returned  in
     *                    the failure scenario.
     */
    public void handleUpdatePassword(MethodCall methodCall, Result result) {
        viewModel.handleUpdatePassword(methodCall, result);
    }

    /**
     * Updates the current user's email address.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, true value will be returned, or AGCAuthException will be returned  in
     *                    the failure scenario.
     */
    public void handleUpdateEmail(MethodCall methodCall, Result result) {
        viewModel.handleUpdateEmail(methodCall, result);
    }

    /**
     * Unlinks the current user from the linked authentication mode.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, current signed in user will be returned, or AGCAuthException will be
     *                    returned  in the failure scenario.
     */
    public void handleUnlink(MethodCall methodCall, Result result) {
        viewModel.handleUnlink(methodCall, result);
    }

    /**
     * Obtains the access token of a user from AppGallery Connect.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, TokenResult will be returned, or AGCAuthException will be returned
     *                    in the failure scenario.
     */
    public void handleGetToken(MethodCall methodCall, Result result) {
        viewModel.handleGetToken(methodCall, result);
    }

    /**
     * Obtains UserExtra of the current user.
     *
     * @param result: In the success scenario, AGCUserExtra will be returned, or AGCAuthException will be returned  in
     *                the failure scenario.
     */
    public void handleGetUserExtra(Result result) {
        viewModel.handleGetUserExtra(result);
    }

    /**
     * Updates information (profile picture and nickname) for the current user.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, true value will be returned, or AGCAuthException will be returned  in
     *                    the failure scenario.
     */
    public void handleUpdateProfile(MethodCall methodCall, Result result) {
        viewModel.handleUpdateProfile(methodCall, result);
    }

    /**
     * Links a new authentication mode for the current user.
     *
     * @param methodCall: Command object representing a method call on a MethodChannel.
     * @param result:     In the success scenario, current signed in user will be returned, or AGCAuthException will be
     *                    returned  in the failure scenario.
     */
    public void handleLink(MethodCall methodCall, Result result) {
        viewModel.handleLink(methodCall, result);
    }

    public void handleSetAutoCollectionAAID(MethodCall methodCall, Result result){
        viewModel.handleSetAutoCollectionAAID(methodCall, result);
    }

    public void handleIsAutoCollectionAAID(Result result){
        viewModel.handleIsAutoCollectionAAID(result);
    }

    public void handleGetSupportedAuthList(Result result){
        viewModel.handleGetSupportedAuthList(result);
    }
}
