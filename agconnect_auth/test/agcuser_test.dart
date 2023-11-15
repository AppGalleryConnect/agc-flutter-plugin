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

import 'dart:ui';

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
        case 'getCurrentUser':
        case 'link':
        case 'unlink':
          return {
            "isAnonymous": false,
            "uid": "uid",
            "email": "email",
            "phone": "phoneNumber",
            "displayName": "displayName",
            "photoUrl": "photoUrl",
            "providerId": 11,
            "providerInfo": [{"providerKey": "providerValue"}],
            "emailVerified": 1,
            "passwordSet": 1,
          };
        case 'updateProfile':
        case 'updateEmail':
        case 'updatePhone':
        case 'updatePassword':
          return {
            "isAnonymous": false,
            "uid": "uid",
            "email": "newEmail",
            "phone": "newPhoneNumber",
            "displayName": "newDisplayName",
            "photoUrl": "newPhotoUrl",
            "providerId": 11,
            "providerInfo": [{"providerKey": "providerValue"}],
            "emailVerified": 1,
            "passwordSet": 1,
          };
        case 'getUserExtra':
          return {
            "user": {
              "isAnonymous": false,
              "uid": "uid",
              "email": "newEmail",
              "phone": "newPhoneNumber",
              "displayName": "newDisplayName",
              "photoUrl": "newPhotoUrl",
              "providerId": 11,
              "providerInfo": [{"providerKey": "providerValue"}],
              "emailVerified": 1,
              "passwordSet": 1,
            },
            "userExtra": {
              "createTime":"createTime",
              "lastSignInTime":"lastSignInTime"
            }
          };
        case 'getToken':
          return {
            "token" : "token",
            "expirePeriod":30
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


    test('getters', () async {
      var user = await AGCAuth.instance.currentUser;
      expect("uid", user!.uid);
      expect("displayName", user.displayName);
      expect("photoUrl", user.photoUrl);
      expect("providerValue", user.providerInfo![0]["providerKey"]);
      expect(true, user.emailVerified);
      expect(true, user.passwordSet);
    });
    test('link', () async {
      var user = await AGCAuth.instance.currentUser;
      var credential = EmailAuthProvider.credentialWithPassword(
          "email", "password");
      await user!.link(credential);
      expect("uid", user.uid);
    });

    test('unlink', () async {
      var user = await AGCAuth.instance.currentUser;
      await user!.unlink(AuthProviderType.email);
      expect("uid", user.uid);
    });

    test('updateProfile', () async {
      var user = await AGCAuth.instance.currentUser;
      var request = ProfileRequest("newDisplayName", "newPhotoUrl");
      await user!.updateProfile(request);
      expect("newDisplayName", user.displayName);
    });

    test('updateEmail', () async {
      var user = await AGCAuth.instance.currentUser;
      await user!.updateEmail("newEmail", "newVerifyCode" , locale: const Locale("en"));
      expect("newEmail", user.email);
    });

    test('updatePhone', () async {
      var user = await AGCAuth.instance.currentUser;
      await user!.updatePhone("countryCode", "newPhoneNumber", "verifyCode", locale: const Locale("en") );
      expect("newPhoneNumber", user.phone);
    });

    test('updatePassword', () async {
      var user = await AGCAuth.instance.currentUser;
      await user!.updatePassword(
          "newPassword", "verifyCode", AuthProviderType.phone);
      expect(AuthProviderType.phone, user.providerId);
    });

    test('userExtra', () async {
      var user = await AGCAuth.instance.currentUser;
      var result = await user!.userExtra;
      expect("createTime", result.createTime);
      expect("lastSignInTime", result.lastSignInTime);
    });

    test('getToken', () async {
      var user = await AGCAuth.instance.currentUser;
      var result = await user!.getToken();
      expect(30, result.expirePeriod);
      expect("token", result.token);
    });
  });
}
