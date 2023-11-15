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

/// Provider of a mobile number credential.
class PhoneAuthProvider {

  /// Obtains a credential using a mobile number and a password.
  static AGCAuthCredential credentialWithPassword(
      String countryCode, String phoneNumber, String password) {
    return PhoneAuthCredential(
        countryCode, phoneNumber, password, null, AuthProviderType.phone);
  }

  /// Obtains a credential using a mobile number and a verification code.
  static AGCAuthCredential credentialWithVerifyCode(
      String countryCode, String phoneNumber, String verifyCode,
      {required String password}) {
    return PhoneAuthCredential(
        countryCode, phoneNumber, password, verifyCode, AuthProviderType.phone);
  }

  /// Applies for a verification code using a mobile number.
  static Future<VerifyCodeResult?> requestVerifyCode(
      String countryCode, String phoneNumber, VerifyCodeSettings settings) {
    return PlatformAuth.methodChannel
        .invokeMethod('requestPhoneVerifyCode', <String, dynamic>{
          'countryCode': countryCode,
          'phoneNumber': phoneNumber,
          'settings': settings.toMap(),
        })
        .then((value) => value != null ? VerifyCodeResult.fromMap(value) : null)
        .catchError(PlatformAuth.handlePlatformException);
  }
}

class PhoneAuthCredential extends AGCAuthCredential {
  String countryCode;
  String phoneNumber;
  String password;
  String? verifyCode;

  PhoneAuthCredential(this.countryCode, this.phoneNumber, this.password,
      this.verifyCode, AuthProviderType provider)
      : super(provider);

  @override
  Map toMap() {
    return {
      'provider': provider.index,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'password': password,
      'verifyCode': verifyCode
    };
  }
}
