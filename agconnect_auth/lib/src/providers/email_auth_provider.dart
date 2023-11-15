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
import '../platform_auth.dart';

/// Provider of an email address credential.
class EmailAuthProvider {

  /// Obtains a credential using an email address and a password.
  static AGCAuthCredential credentialWithPassword(
      String email, String password) {
    return EmailAuthCredential(email, password, "", AuthProviderType.email);
  }

  /// Obtains a credential using an email address and a verification code.
  static AGCAuthCredential credentialWithVerifyCode(
       String email,  String verifyCode,
      { String? password}) {
    return EmailAuthCredential(
        email, "", verifyCode, AuthProviderType.email);
  }

  /// Applies for a verification code using an email address.
  static Future<VerifyCodeResult?> requestVerifyCode(
      String email, VerifyCodeSettings settings) {
    return PlatformAuth.methodChannel
        .invokeMethod('requestEmailVerifyCode', <String, dynamic>{
          'email': email,
          'settings': settings.toMap(),
        })
        .then((value) => value != null ? VerifyCodeResult.fromMap(value) : null)
        .catchError(PlatformAuth.handlePlatformException);
  }
}

class EmailAuthCredential extends AGCAuthCredential {
  String email;
  String password;
  String verifyCode;

  EmailAuthCredential(
      this.email, this.password, this.verifyCode, AuthProviderType provider)
      : super(provider);

  @override
  Map toMap() {
    return {
      'provider': provider.index,
      'email': email,
      'password': password,
      'verifyCode': verifyCode
    };
  }
}
