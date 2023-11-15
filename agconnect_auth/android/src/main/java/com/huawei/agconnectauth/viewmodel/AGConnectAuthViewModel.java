/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

package com.huawei.agconnectauth.viewmodel;

import com.huawei.agconnect.auth.AGConnectAuth;
import com.huawei.agconnect.auth.AGConnectAuthCredential;
import com.huawei.agconnect.auth.AGConnectUser;
import com.huawei.agconnect.auth.EmailAuthProvider;
import com.huawei.agconnect.auth.EmailUser;
import com.huawei.agconnect.auth.PhoneAuthProvider;
import com.huawei.agconnect.auth.PhoneUser;
import com.huawei.agconnect.auth.ProfileRequest;
import com.huawei.agconnect.auth.VerifyCodeSettings;
import com.huawei.agconnectauth.utils.AGConnectAuthUtils;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public class AGConnectAuthViewModel {

    /**
     * Signs in a user to AppGallery Connect.
     * <p>
     * credential: Authentication credential, which must be created using the corresponding Auth Provider type.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, user will be signed in and returned, or AGCAuthException will be returned
     *                in the failure scenario.
     */
    public void handleSignIn(MethodCall call, final Result result) {
        AGConnectAuthCredential credential = AGConnectAuthUtils.getCredentialFromArguments(
                (Map) call.argument("credential"), result);
        if (credential != null) {
            AGConnectAuth.getInstance()
                    .signIn(credential)
                    .addOnSuccessListener(signInResult -> result.success(AGConnectAuthUtils.mapFromUser(signInResult.getUser())))
                    .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
        }
    }

    /**
     * Signs in a user anonymously.
     *
     * @param result: In the success scenario, user will be signed in and returned, or AGCAuthException will be returned
     *                in the failure scenario.
     */
    public void handleSignInAnonymously(final Result result) {
        AGConnectAuth.getInstance()
                .signInAnonymously()
                .addOnSuccessListener(
                        signInResult -> result.success(AGConnectAuthUtils.mapFromUser(signInResult.getUser())))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Signs out a user and deletes the user's cached data.
     *
     * @param result: Returns true after the function execution is completed.
     */
    public void handleSignOut(final Result result) {
        AGConnectAuth.getInstance().signOut();
        result.success(null);
    }

    /**
     * Deletes the current user information and cache information from the AppGallery Connect server.
     *
     * @param result: Returns true after the function execution is completed.
     */
    public void handleDeleteUser(final Result result) {
        AGConnectAuth.getInstance().deleteUser();
        result.success(null);
    }

    /**
     * Returns current signed in user.
     *
     * @param result: In the success scenario, current signed in user will be returned, or AGCAuthException will be
     *                returned  in the failure scenario.
     */
    public void handleGetCurrentUser(final Result result) {
        AGConnectUser user = AGConnectAuth.getInstance().getCurrentUser();
        result.success(AGConnectAuthUtils.mapFromUser(user));
    }

    /**
     * Creates an account using an email address.
     * <p>
     * email:            Email address. verificationCode: Verification code. password:         Password.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, user will be signed in and returned, or AGCAuthException will be returned
     *                in the failure scenario.
     */
    public void handleCreateUserWithEmail(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String email = (String) map.get("email");
        String password = (String) map.get("password");
        String verifyCode = (String) map.get("verifyCode");
        EmailUser emailUser = new EmailUser.Builder().setEmail(email)
                .setPassword(password)
                .setVerifyCode(verifyCode)
                .build();
        AGConnectAuth.getInstance()
                .createUser(emailUser)
                .addOnSuccessListener(
                        signInResult -> result.success(AGConnectAuthUtils.mapFromUser(signInResult.getUser())))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Creates an account using a mobile number.
     * <p>
     * countryCode: Country/Region code. phoneNumber: Mobile number. verificationCode: Verification code. password:
     * Password.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be returned
     *                in the failure scenario.
     */
    public void handleCreateUserWithPhone(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String countryCode = (String) map.get("countryCode");
        String phoneNumber = (String) map.get("phoneNumber");
        String password = (String) map.get("password");
        String verifyCode = (String) map.get("verifyCode");
        PhoneUser phoneUser = new PhoneUser.Builder().setCountryCode(countryCode)
                .setPhoneNumber(phoneNumber)
                .setPassword(password)
                .setVerifyCode(verifyCode)
                .build();
        AGConnectAuth.getInstance()
                .createUser(phoneUser)
                .addOnSuccessListener(
                        signInResult -> result.success(AGConnectAuthUtils.mapFromUser(signInResult.getUser())))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Resets a user's password using the email address.
     * <p>
     * email:            Email address. newPassword:      New password. verificationCode: Verification code.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, true value will be returned, or AGCAuthException will be returned  in the
     *                failure scenario.
     */
    public void handleResetPasswordWithEmail(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String email = (String) map.get("email");
        String password = (String) map.get("password");
        String verifyCode = (String) map.get("verifyCode");
        AGConnectAuth.getInstance()
                .resetPassword(email, password, verifyCode)
                .addOnSuccessListener(aVoid -> result.success(null))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Resets a user's password using the mobile number.
     * <p>
     * countryCode:      Country/Region code. phoneNumber:      Mobile number. newPassword:      New password.
     * verificationCode: Verification code.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, true value will be returned, or AGCAuthException will be returned  in the
     *                failure scenario.
     */
    public void handleResetPasswordWithPhone(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String countryCode = (String) map.get("countryCode");
        String phoneNumber = (String) map.get("phoneNumber");
        String password = (String) map.get("password");
        String verifyCode = (String) map.get("verifyCode");
        AGConnectAuth.getInstance()
                .resetPassword(countryCode, phoneNumber, password, verifyCode)
                .addOnSuccessListener(aVoid -> result.success(null))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Links a new authentication mode for the current user.
     * <p>
     * credential: Credential of a new authentication mode.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, current signed in user will be returned, or AGCAuthException will be
     *                returned  in the failure scenario.
     */
    public void handleLink(MethodCall call, final Result result) {
        AGConnectAuthCredential credential = AGConnectAuthUtils.getCredentialFromArguments(
                (Map) call.argument("credential"), result);
        if (credential != null) {
            AGConnectAuth.getInstance()
                    .getCurrentUser()
                    .link(credential)
                    .addOnSuccessListener(signInResult -> result.success(AGConnectAuthUtils.mapFromUser(signInResult.getUser())))
                    .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
        }
    }

    /**
     * Unlinks the current user from the linked authentication mode.
     * <p>
     * provider: Authentication mode to be unlinked.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, current signed in user will be returned, or AGCAuthException will be
     *                returned  in the failure scenario.
     */
    public void handleUnlink(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        int provider = (int) map.get("provider");
        AGConnectAuth.getInstance()
                .getCurrentUser()
                .unlink(provider)
                .addOnSuccessListener(
                        signInResult -> result.success(AGConnectAuthUtils.mapFromUser(signInResult.getUser())))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Updates the current user's email address.
     * <p>
     * newEmail: New email address. verificationCode: Verification code sent to the email address. locale: Language in
     * which the verification code email is sent.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, true value will be returned, or AGCAuthException will be returned  in the
     *                failure scenario.
     */
    public void handleUpdateEmail(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String email = (String) map.get("email");
        String verifyCode = (String) map.get("verifyCode");
        Locale locale = AGConnectAuthUtils.getLocaleFromArguments((Map) call.arguments);
        AGConnectAuth.getInstance()
                .getCurrentUser()
                .updateEmail(email, verifyCode, locale)
                .addOnSuccessListener(
                        aVoid -> result.success(AGConnectAuthUtils.mapFromUser(AGConnectAuth.getInstance().getCurrentUser())))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Updates the mobile number of the current user.
     * <p>
     * countryCode: Country/Region code. newPhoneNumber: New Mobile number. verificationCode: Verification code send to
     * the phone number. locale: Language in which the verification code message is sent.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, true value will be returned, or AGCAuthException will be returned  in the
     *                failure scenario.
     */
    public void handleUpdatePhone(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String countryCode = (String) map.get("countryCode");
        String phoneNumber = (String) map.get("phoneNumber");
        String verifyCode = (String) map.get("verifyCode");
        Locale locale = AGConnectAuthUtils.getLocaleFromArguments((Map) call.arguments);
        AGConnectAuth.getInstance()
                .getCurrentUser()
                .updatePhone(countryCode, phoneNumber, verifyCode, locale)
                .addOnSuccessListener(
                        aVoid -> result.success(AGConnectAuthUtils.mapFromUser(AGConnectAuth.getInstance().getCurrentUser())))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Updates information (profile picture and nickname) for the current user.
     * <p>
     * displayName: nickname photoUrl: profile picture
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, true value will be returned, or AGCAuthException will be returned  in the
     *                failure scenario.
     */
    public void handleUpdateProfile(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String displayName = (String) map.get("displayName");
        String photoUrl = (String) map.get("photoUrl");
        ProfileRequest request = new ProfileRequest.Builder().setDisplayName(displayName).setPhotoUrl(photoUrl).build();
        AGConnectAuth.getInstance()
                .getCurrentUser()
                .updateProfile(request)
                .addOnSuccessListener(
                        aVoid -> result.success(AGConnectAuthUtils.mapFromUser(AGConnectAuth.getInstance().getCurrentUser())))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Updates the current user's password.
     * <p>
     * newPassword: New password. verificationCode: Verification code. provider: Provider type, which is used to
     * differentiate the email address from mobile number.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, true value will be returned, or AGCAuthException will be returned  in the
     *                failure scenario.
     */
    public void handleUpdatePassword(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String password = (String) map.get("password");
        String verifyCode = (String) map.get("verifyCode");
        int provider = (int) map.get("provider");
        AGConnectAuth.getInstance()
                .getCurrentUser()
                .updatePassword(password, verifyCode, provider)
                .addOnSuccessListener(
                        aVoid -> result.success(AGConnectAuthUtils.mapFromUser(AGConnectAuth.getInstance().getCurrentUser())))
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Obtains UserExtra of the current user.
     *
     * @param result: In the success scenario, AGCUserExtra will be returned, or AGCAuthException will be returned  in
     *                the failure scenario.
     */
    public void handleGetUserExtra(final Result result) {
        AGConnectAuth.getInstance().getCurrentUser().getUserExtra().addOnSuccessListener(agConnectUserExtra -> {
            Map<String, String> userExtra = new HashMap<>();
            userExtra.put("createTime", agConnectUserExtra.getCreateTime());
            userExtra.put("lastSignInTime", agConnectUserExtra.getLastSignInTime());
            Map user = AGConnectAuthUtils.mapFromUser(AGConnectAuth.getInstance().getCurrentUser());
            Map res = new HashMap<>();
            res.put("userExtra", userExtra);
            res.put("user", user);
            result.success(res);
        }).addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Obtains the access token of a user from AppGallery Connect.
     * <p>
     * forceRefresh: Indicates whether to forcibly update the access token of a user.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, TokenResult will be returned, or AGCAuthException will be returned  in
     *                the failure scenario.
     */
    public void handleGetToken(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        boolean forceRefresh = (boolean) map.get("forceRefresh");
        AGConnectAuth.getInstance().getCurrentUser().getToken(forceRefresh).addOnSuccessListener(tokenResult -> {
            Map<String, Object> res = new HashMap<>();
            res.put("token", tokenResult.getToken());
            res.put("expirePeriod", tokenResult.getExpirePeriod());
            result.success(res);
        }).addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Applies for a verification code using an email address.
     * <p>
     * email:   Email address. res:     Verification code attributes, including the verification code application
     * scenarios (such as registration, sign-in, and password resetting), language of the verification code message, and
     * interval for sending verification codes.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be returned
     *                in the failure scenario.
     */
    public void handleRequestEmailVerifyCode(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String email = (String) map.get("email");
        VerifyCodeSettings settings = AGConnectAuthUtils.getSettingsFromArguments((Map) call.arguments);
        EmailAuthProvider.requestVerifyCode(email, settings).addOnSuccessListener(verifyCodeResult -> {
            Map<String, String> res = new HashMap<>();
            res.put("shortestInterval", verifyCodeResult.getShortestInterval());
            res.put("validityPeriod", verifyCodeResult.getValidityPeriod());
            result.success(res);
        }).addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Applies for a verification code using an email address.
     * <p>
     * email:   Email address. res:     Verification code attributes, including the verification code application
     * scenarios (such as registration, sign-in, and password resetting), language of the verification code message, and
     * interval for sending verification codes.
     *
     * @param call:   Command object representing a method call on a MethodChannel.
     * @param result: In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be returned
     *                in the failure scenario.
     */
    public void handleAuthRequestEmailVerifyCode(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String email = (String) map.get("email");
        VerifyCodeSettings settings = AGConnectAuthUtils.getSettingsFromArguments((Map) call.arguments);
        AGConnectAuth.getInstance().requestVerifyCode(email,settings).addOnSuccessListener(verifyCodeResult -> {
            Map<String, String> res = new HashMap<>();
            res.put("shortestInterval", verifyCodeResult.getShortestInterval());
            res.put("validityPeriod", verifyCodeResult.getValidityPeriod());
            result.success(res);
        }).addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Applies for a verification code using a mobile number.
     * <p>
     * countryCode: Country/Region code. phoneNumber: Mobile number. res:         Verification code attributes,
     * including the verification code application scenarios (such as registration, sign-in, and password resetting),
     * language of the verification code message, and interval for sending verification codes.
     *
     * @param result: In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be returned
     *                in the failure scenario.
     * @param call:   Command object representing a method call on a MethodChannel.
     */
    public void handleRequestPhoneVerifyCode(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String countryCode = (String) map.get("countryCode");
        String phoneNumber = (String) map.get("phoneNumber");
        VerifyCodeSettings settings = AGConnectAuthUtils.getSettingsFromArguments((Map) call.arguments);
        PhoneAuthProvider.requestVerifyCode(countryCode, phoneNumber, settings)
                .addOnSuccessListener(verifyCodeResult -> {
                    Map<String, String> res = new HashMap<>();
                    res.put("shortestInterval", verifyCodeResult.getShortestInterval());
                    res.put("validityPeriod", verifyCodeResult.getValidityPeriod());
                    result.success(res);
                })
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    /**
     * Applies for a verification code using a mobile number.
     * <p>
     * countryCode: Country/Region code. phoneNumber: Mobile number. res:         Verification code attributes,
     * including the verification code application scenarios (such as registration, sign-in, and password resetting),
     * language of the verification code message, and interval for sending verification codes.
     *
     * @param result: In the success scenario, VerifyCodeResult will be returned, or AGCAuthException will be returned
     *                in the failure scenario.
     * @param call:   Command object representing a method call on a MethodChannel.
     */
    public void handleAuthRequestPhoneVerifyCode(MethodCall call, final Result result) {
        Map map = (Map) call.arguments;
        String countryCode = (String) map.get("countryCode");
        String phoneNumber = (String) map.get("phoneNumber");
        VerifyCodeSettings settings = AGConnectAuthUtils.getSettingsFromArguments((Map) call.arguments);
        AGConnectAuth.getInstance().requestVerifyCode(countryCode, phoneNumber, settings)
                .addOnSuccessListener(verifyCodeResult -> {
                    Map<String, String> res = new HashMap<>();
                    res.put("shortestInterval", verifyCodeResult.getShortestInterval());
                    res.put("validityPeriod", verifyCodeResult.getValidityPeriod());
                    result.success(res);
                })
                .addOnFailureListener(AGConnectAuthUtils.authFailureListener(result));
    }

    public void handleSetAutoCollectionAAID(MethodCall call, final Result result){
        Map map = (Map) call.arguments;
        Boolean isAutoCollection = (Boolean) map.get("isAutoCollection");
        AGConnectAuth.getInstance().setAutoCollectionAAID(isAutoCollection);
        result.success(null);
    }

    public void handleIsAutoCollectionAAID(final Result result){
        Map res = new HashMap<>();
        res.put("isAutoCollection", AGConnectAuth.getInstance().isAutoCollectionAAID());
        result.success(res);
    }

    public void handleGetSupportedAuthList(final Result result){
        Map res = new HashMap<>();
        res.put("supportedAuthList", AGConnectAuth.getInstance().getSupportedAuthList());
        result.success(res);
    }
}
