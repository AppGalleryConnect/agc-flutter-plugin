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

import 'package:agconnect_auth/agconnect_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("auth test", () {
    const MethodChannel channel =
        MethodChannel('com.huawei.flutter/agconnect_auth');
    

    Future<Object?> handler(MethodCall methodCall) async {
      
      switch (methodCall.method) {
        case 'signIn':
          return {
            "isAnonymous": false,
            "uid": "uid",
            "email": "email",
            "phone": "phoneNumber",
            "providerId": 11,
          };
        case 'signInAnonymously':
          return {
            "isAnonymous": true,
            "uid": "uid",
            "email": null,
            "phone": null,
            "providerId": 0,
          };
        case 'signOut':
        case 'getCurrentUser':
        case 'deleteUser':
        case 'resetPasswordWithEmail':
        case 'resetPasswordWithPhone':
        case 'setAutoCollectionAAID':
          return null;
        case 'createUserWithEmail':
          return {
            "isAnonymous": false,
            "uid": "uid",
            "email": "email",
            "phone": "phoneNumber",
            "providerId": 12,
          };
        case 'createUserWithPhone':
          return {
            "isAnonymous": false,
            "uid": "uid",
            "phone": "phoneNumber",
            "providerId": 11,
          };
        case 'requestAuthEmailVerifyCode':
        case 'requestAuthPhoneVerifyCode':
          return {"shortestInterval": "0", "validityPeriod": "0"};
        case 'getSupportedAuthList':
          return {
            "supportedAuthList": [0, 11, 12]
          };
        case 'isAutoCollectionAAID':
          return {
            "isAutoCollection": true
          };
        default:
          throw PlatformException(
              code: '0', message: 'Unknown method call, please update test.');
      }
    }

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, handler);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('signIn', () async {
      var credential = PhoneAuthProvider.credentialWithPassword(
          "countryCode", "phoneNumber", "password");
      var result = await AGCAuth.instance.signIn(credential);
      expect(AuthProviderType.phone, result.user!.providerId);
      expect("phoneNumber", result.user!.phone);
    });

    test('signInAnonymously', () async {
      var result = await AGCAuth.instance.signInAnonymously();
      expect(AuthProviderType.anonymous, result.user!.providerId);
      expect(true, result.user!.isAnonymous);
    });

    test('signOut', () async {
      await AGCAuth.instance.signInAnonymously();
      await AGCAuth.instance.signOut();
      expect(null, await AGCAuth.instance.currentUser);
    });

    test('deleteUser', () async {
      await AGCAuth.instance.deleteUser();
      expect(null, await AGCAuth.instance.currentUser);
    });

    test('tokenChanges', () async {
      AGCAuth.instance.tokenChanges().listen((TokenSnapshot event) {
        expect(event.token, "token");
        expect(event.state, TokenState.signedIn);
      }, onError: (Object error) {
        fail("$error");
      });
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
              'com.huawei.flutter.event/agconnect_auth',
              const StandardMethodCodec()
                  .encodeSuccessEnvelope({"token": "token", "state": 0}),
              (ByteData? data) {});
    });

    test('createEmailUser', () async {
      var user = EmailUser("email", "verifyCode", "password");
      var result = await AGCAuth.instance.createEmailUser(user);
      expect(AuthProviderType.email, result.user!.providerId);
      expect("email", result.user!.email);
    });

    test('createPhoneUser', () async {
      var user = PhoneUser("countryCode", "phoneNumber", "verifyCode",
          password: "password");
      var result = await AGCAuth.instance.createPhoneUser(user);
      expect(AuthProviderType.phone, result.user!.providerId);
      expect("phoneNumber", result.user!.phone);
    });

    test('resetPasswordWithEmail', () async {
      await AGCAuth.instance
          .resetPasswordWithEmail("email", "newPassword", "verifyCode");
    });

    test('resetPasswordWithPhone', () async {
      await AGCAuth.instance.resetPasswordWithPhone(
          "countryCode", "phoneNumber", "newPassword", "verifyCode");
    });

    test('setAutoCollectionAAID', () async {
      await AGCAuth.instance.setAutoCollectionAAID(true);
    });

    test('requestVerifyCodeWithEmail', () async {
      VerifyCodeSettings settings =
          VerifyCodeSettings(VerifyCodeAction.registerLogin, sendInterval: 30);
      var result =
          await AGCAuth.instance.requestVerifyCodeWithEmail("email", settings);
      expect("0", result?.shortestInterval);
      expect("0", result?.validityPeriod);
    });

    test('requestVerifyCodeWithPhone', () async {
      VerifyCodeSettings settings =
          VerifyCodeSettings(VerifyCodeAction.registerLogin, sendInterval: 30);
      var result = await AGCAuth.instance
          .requestVerifyCodeWithPhone("countryCode", "phoneNumber", settings);
      expect("0", result?.shortestInterval);
      expect("0", result?.validityPeriod);
    });

    test('getSupportedAuthList', () async {
      var result = await AGCAuth.instance.getSupportedAuthList();
      expect(true, result!.contains(11));
    });

    test('isAutoCollectionAAID', () async {
      var result = await AGCAuth.instance.isAutoCollectionAAID();
      expect(true, result!);
    });
  });
}
