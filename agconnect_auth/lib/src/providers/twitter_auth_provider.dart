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
import '../../agconnect_auth.dart';

/// Provider of a Twitter account credential.
class TwitterAuthProvider {
  /// Creates a sign-in credential. By default, an account is automatically created.
  static AGCAuthCredential credentialWithToken(String token, String secret,
      {bool autoCreateUser = true}) {
    return TwitterAuthCredential(
        token, autoCreateUser, secret, AuthProviderType.twitter);
  }

  /// Creates a credential for sign-in authentication.
  static AGCAuthCredential credentialWithAuthCode(
      TwitterAuthParam twitterAuthParam,
      {bool autoCreateUser = true}) {
    return TwitterAuthCredential.v2(twitterAuthParam, AuthProviderType.twitter,
        autoCreateUser: autoCreateUser);
  }
}

class TwitterAuthParam {
  String clientId;
  String authCode;
  String codeVerifier;
  String redirectUrl;

  TwitterAuthParam(
      this.clientId, this.authCode, this.codeVerifier, this.redirectUrl);
}

class TwitterAuthCredential extends AGCAuthCredential {
  String token = "TwitterV2";
  String secret = "";
  late bool autoCreateUser;
  bool _v2 = false;
  TwitterAuthParam _twitterAuthParam = TwitterAuthParam("", "", "", "");

  TwitterAuthCredential(
      this.token, this.autoCreateUser, this.secret, AuthProviderType provider)
      : super(provider);

  TwitterAuthCredential.v2(
      TwitterAuthParam twitterAuthParam, AuthProviderType provider,
      {this.autoCreateUser = true})
      : super(provider) {
    _twitterAuthParam = twitterAuthParam;
    _v2 = true;
  }

  @override
  Map toMap() {
    return {
      'provider': provider.index,
      'token': token,
      'v2': _v2,
      'autoCreateUser': autoCreateUser,
      'clientId': _twitterAuthParam.clientId,
      'authCode': _twitterAuthParam.authCode,
      'codeVerifier': _twitterAuthParam.codeVerifier,
      'redirectUrl': _twitterAuthParam.redirectUrl,
      'secret': secret
    };
  }
}
