/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

package com.huawei.agconnectauth.utils;

import com.huawei.agconnect.auth.AGConnectAuthCredential;
import com.huawei.agconnect.auth.AGConnectUser;
import com.huawei.agconnect.auth.AlipayAuthProvider;
import com.huawei.agconnect.auth.EmailAuthProvider;
import com.huawei.agconnect.auth.FacebookAuthProvider;
import com.huawei.agconnect.auth.GoogleAuthProvider;
import com.huawei.agconnect.auth.GoogleGameAuthProvider;
import com.huawei.agconnect.auth.HWGameAuthProvider;
import com.huawei.agconnect.auth.HwIdAuthProvider;
import com.huawei.agconnect.auth.PhoneAuthProvider;
import com.huawei.agconnect.auth.QQAuthProvider;
import com.huawei.agconnect.auth.SelfBuildProvider;
import com.huawei.agconnect.auth.TwitterAuthParam;
import com.huawei.agconnect.auth.TwitterAuthProvider;
import com.huawei.agconnect.auth.VerifyCodeSettings;
import com.huawei.agconnect.auth.WeiboAuthProvider;
import com.huawei.agconnect.auth.WeixinAuthProvider;
import com.huawei.agconnect.exception.AGCException;
import com.huawei.hmf.tasks.OnFailureListener;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel.Result;

public class AGConnectAuthUtils {

    /**
     * authFailureListener.
     *
     * @param result: FlutterResult.
     * @return result/
     */
    public static OnFailureListener authFailureListener(final Result result) {
        return e -> {
            Map<String, Object> map = new HashMap<>();
            if (e instanceof AGCException) {
                int code = ((AGCException) e).getCode();
                map.put("exceptionCode", code);
                result.error(String.valueOf(code), ((AGCException) e).getErrMsg(), map);
            } else {
                result.error("", e.getMessage(), map);
            }
        };
    }

    /**
     * Converts a AGConnectUser into a Map.
     *
     * @param user: AGConnectUser.
     * @return map
     */
    public static Map<String, Object> mapFromUser(AGConnectUser user) {
        if (user != null) {
            Map<String, Object> res = new HashMap<>();
            res.put("isAnonymous", user.isAnonymous());
            res.put("uid", user.getUid());
            res.put("email", user.getEmail());
            res.put("phone", user.getPhone());
            res.put("displayName", user.getDisplayName());
            res.put("photoUrl", user.getPhotoUrl());
            res.put("providerId", Integer.valueOf(user.getProviderId()));
            res.put("providerInfo", user.getProviderInfo());
            res.put("emailVerified", user.getEmailVerified());
            res.put("passwordSet", user.getPasswordSetted());
            return res;
        } else {
            return null;
        }
    }

    /**
     * Converts a Map into a VerifyCodeSettings.
     *
     * @param arguments: map.
     * @return VerifyCodeSettings.
     */
    public static VerifyCodeSettings getSettingsFromArguments(Map arguments) {
        Map map = (Map) arguments.get("settings");
        if (map != null) {
            int action = (int) map.get("action") == 0
                    ? VerifyCodeSettings.ACTION_REGISTER_LOGIN
                    : VerifyCodeSettings.ACTION_RESET_PASSWORD;
            Locale locale = getLocaleFromArguments(map);
            int interval = (int) map.get("sendInterval");
            return new VerifyCodeSettings.Builder().action(action).locale(locale).sendInterval(interval).build();
        }
        return null;
    }

    /**
     * Converts a Map into a Locale.
     *
     * @param arguments: map.
     * @return locale
     */
    public static Locale getLocaleFromArguments(Map arguments) {
        Locale locale = null;
        if (arguments != null) {
            String localeLanguage = (String) arguments.get("localeLanguage");
            String localeCountry = (String) arguments.get("localeCountry");
            if (localeLanguage != null && localeCountry != null) {
                locale = new Locale(localeLanguage, localeCountry);
            }
        }
        return locale;
    }

    /**
     * Converts a Map into a AGConnectAuthCredential.
     *
     * @param credential: map.
     * @return AGConnectAuthCredential
     */
    public static AGConnectAuthCredential getCredentialFromArguments(Map credential, Result result) {
        int provider = ValueGetter.getInteger("provider", credential);
        switch (provider) {
            case AGConnectAuthCredential.SelfBuild_Provider:
                return selfBuild(credential);
            case AGConnectAuthCredential.Email_Provider:
                return email(credential);
            case AGConnectAuthCredential.Phone_Provider:
                return phone(credential);
            case AGConnectAuthCredential.HMS_Provider:
                return hms(credential);
            case AGConnectAuthCredential.HWGame_Provider:
                return hwGame(credential);
            case AGConnectAuthCredential.WeiXin_Provider:
                return weixin(credential);
            case AGConnectAuthCredential.Facebook_Provider:
                return facebook(credential);
            case AGConnectAuthCredential.Twitter_Provider:
                return twitter(credential);
            case AGConnectAuthCredential.WeiBo_Provider:
                return weibo(credential);
            case AGConnectAuthCredential.QQ_Provider:
                return qq(credential);
            case AGConnectAuthCredential.Google_Provider:
                return google(credential);
            case AGConnectAuthCredential.GoogleGame_Provider:
                return googleGame(credential);
            case AGConnectAuthCredential.Alipay_Provider:
                return alipay(credential);
            default:
                result.error("", "This provider is not supported", new HashMap<>());
                return null;
        }
    }

    private static AGConnectAuthCredential selfBuild(Map credential) {
        String selfBuildToken = ValueGetter.getString("token", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return SelfBuildProvider.credentialWithToken(selfBuildToken, autoCreateUser);
    }

    private static AGConnectAuthCredential email(Map credential) {
        String email = ValueGetter.getString("email", credential);
        String password = (String) credential.get("password");
        String verifyCode = (String) credential.get("verifyCode");
        return EmailAuthProvider.credentialWithVerifyCode(email, password, verifyCode);
    }

    private static AGConnectAuthCredential phone(Map credential) {
        String countryCode = ValueGetter.getString("countryCode", credential);
        String phoneNumber = ValueGetter.getString("phoneNumber", credential);
        String phonePassword = (String) credential.get("password");
        String phoneVerifyCode = (String) credential.get("verifyCode");
        return PhoneAuthProvider.credentialWithVerifyCode(countryCode, phoneNumber, phonePassword,
                phoneVerifyCode);
    }

    private static AGConnectAuthCredential hms(Map credential) {
        String accessToken = ValueGetter.getString("accessToken", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return HwIdAuthProvider.credentialWithToken(accessToken, autoCreateUser);
    }

    private static AGConnectAuthCredential hwGame(Map credential) {
        HWGameAuthProvider.Builder builder = new HWGameAuthProvider.Builder();
        if (credential.get("playerSign") != null) {
            String playerSign = ValueGetter.getString("playerSign", credential);
            builder.setPlayerSign(playerSign);
        }
        if (credential.get("playerId") != null) {
            String playerId = ValueGetter.getString("playerId", credential);
            builder.setPlayerId(playerId);
        }
        if (credential.get("displayName") != null) {
            String displayName = ValueGetter.getString("displayName", credential);
            builder.setDisplayName(displayName);
        }
        if (credential.get("imageUrl") != null) {
            String imageUrl = ValueGetter.getString("imageUrl", credential);
            builder.setImageUrl(imageUrl);
        }
        if (credential.get("playerLevel") != null) {
            int playerLevel = ValueGetter.getInteger("playerLevel", credential);
            builder.setPlayerLevel(playerLevel);
        }
        if (credential.get("signTs") != null) {
            String signTs = ValueGetter.getString("signTs", credential);
            builder.setSignTs(signTs);
        }
        if (credential.get("autoCreateUser") != null) {
            boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
            builder.setAutoCreateUser(autoCreateUser);
        }

        return builder.build();
    }

    private static AGConnectAuthCredential weixin(Map credential) {
        String accessTokenWei = ValueGetter.getString("accessToken", credential);
        String openId = ValueGetter.getString("openId", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return WeixinAuthProvider.credentialWithToken(accessTokenWei, openId, autoCreateUser);
    }

    private static AGConnectAuthCredential facebook(Map credential) {
        String accessTokenFacebook = ValueGetter.getString("accessToken", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return FacebookAuthProvider.credentialWithToken(accessTokenFacebook, autoCreateUser);
    }

    private static AGConnectAuthCredential twitter(Map credential) {
        boolean v2 = ValueGetter.getBoolean("v2", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        if (v2) {
            String clientId = ValueGetter.getString("clientId", credential);
            String authCode = ValueGetter.getString("authCode", credential);
            String codeVerifier = ValueGetter.getString("codeVerifier", credential);
            String redirectUrl = ValueGetter.getString("redirectUrl", credential);
            TwitterAuthParam twitterAuthParam = new TwitterAuthParam(clientId, authCode, codeVerifier, redirectUrl);
            return TwitterAuthProvider.credentialWithAuthCode(twitterAuthParam, autoCreateUser);
        } else {
            String token = ValueGetter.getString("token", credential);
            String secret = ValueGetter.getString("secret", credential);
            return TwitterAuthProvider.credentialWithToken(token, secret, autoCreateUser);
        }
    }

    private static AGConnectAuthCredential weibo(Map credential) {
        String tokenWeibo = ValueGetter.getString("token", credential);
        String uid = ValueGetter.getString("uid", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return WeiboAuthProvider.credentialWithToken(tokenWeibo, uid, autoCreateUser);
    }

    private static AGConnectAuthCredential alipay(Map credential) {
        String authCode = ValueGetter.getString("authCode", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return AlipayAuthProvider.credentialWithAuthCode(authCode, autoCreateUser);
    }

    private static AGConnectAuthCredential google(Map credential) {
        String idToken = ValueGetter.getString("idToken", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return GoogleAuthProvider.credentialWithToken(idToken, autoCreateUser);
    }

    private static AGConnectAuthCredential googleGame(Map credential) {
        String serverAuthCode = ValueGetter.getString("serverAuthCode", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return GoogleGameAuthProvider.credentialWithToken(serverAuthCode, autoCreateUser);
    }

    private static AGConnectAuthCredential qq(Map credential) {
        String accessTokenQQ = ValueGetter.getString("accessToken", credential);
        String openIdQQ = ValueGetter.getString("openId", credential);
        boolean autoCreateUser = ValueGetter.getBoolean("autoCreateUser", credential);
        return QQAuthProvider.credentialWithToken(accessTokenQQ, openIdQQ, autoCreateUser);
    }

}
