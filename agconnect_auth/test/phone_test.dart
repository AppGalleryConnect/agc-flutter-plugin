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

  group('phone test', () {
    const MethodChannel channel = MethodChannel('com.huawei.flutter/agconnect_auth');
    

    Future<Object?> handler(MethodCall methodCall) async {
      
      switch (methodCall.method) {
        case 'requestPhoneVerifyCode':
          return  {"shortestInterval": "0","validityPeriod": "0"};
        default:
          throw PlatformException(code: '0', message: 'Unknown method call, please update test.');
      }
    }

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel,handler);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('requestVerifyCode', () async {
      VerifyCodeSettings settings = VerifyCodeSettings(VerifyCodeAction.registerLogin, sendInterval: 30);
      var result= await PhoneAuthProvider.requestVerifyCode("countryCode", "phoneNumber", settings);
      expect("0", result?.shortestInterval);
      expect("0", result?.validityPeriod);
    });

    test('credential with password', () {
      var result= PhoneAuthProvider.credentialWithPassword("countryCode", "phoneNumber","password");
      result.toMap();
      expect(AuthProviderType.phone, result.provider);
    });
    test('credential with verifyCode', () {
      var result= PhoneAuthProvider.credentialWithVerifyCode("countryCode", "phoneNumber","verifyCode",password:"password");
      expect(AuthProviderType.phone, result.provider);
    });

  });

}
