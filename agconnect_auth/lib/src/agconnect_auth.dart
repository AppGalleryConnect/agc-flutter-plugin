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


import 'dart:async';

import 'package:agconnect_auth/agconnect_auth.dart';
import 'package:agconnect_auth/src/platform_auth.dart';
import 'package:flutter/services.dart';

/// AGConnect Auth SDK entry class
class AGCAuth {
  final MethodChannel _channel = PlatformAuth.methodChannel;
  final Stream<dynamic> _tokenListener =
      PlatformAuth.eventChannel.receiveBroadcastStream();

  /// Obtains the AGCAuth instance.
  static final AGCAuth instance = AGCAuth();


  /// Signs in a user to AppGallery Connect through third-party authentication.
  Future<SignInResult> signIn(AGCAuthCredential credential) {
    return _channel
        .invokeMethod(
            'signIn', <String, dynamic>{'credential': credential.toMap()})
        .then((value) => SignInResult.fromMap(value))
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Signs in a user anonymously.
  Future<SignInResult> signInAnonymously() {
    return _channel
        .invokeMethod('signInAnonymously')
        .then((value) => SignInResult.fromMap(value))
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Signs out a user and deletes the user's cached data.
  Future<void> signOut() {
    return _channel
        .invokeMethod('signOut')
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Deletes the current user information and the user's cached data from the AppGallery Connect server.
  Future<void> deleteUser() {
    return _channel
        .invokeMethod('deleteUser')
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Obtains information about the current user. If the user has not signed in, a null value is returned.
  Future<AGCUser?> get currentUser {
    return _channel
        .invokeMethod('getCurrentUser')
        .then((value) => value != null ? AGCUser.fromMap(value) : null)
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Obtain token and tokens state
  Stream<TokenSnapshot> tokenChanges() {
    return _tokenListener.map((event) => TokenSnapshot.fromMap(event));
  }

  /// Creates an account using an email address.
  Future<SignInResult> createEmailUser(EmailUser user) {
    return _channel
        .invokeMethod('createUserWithEmail', <String, dynamic>{
          'email': user.email,
          'password': user.password,
          'verifyCode': user.verifyCode
        })
        .then((value) => SignInResult.fromMap(value))
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Creates an account using a mobile number.
  Future<SignInResult> createPhoneUser(PhoneUser user) {
    return _channel
        .invokeMethod('createUserWithPhone', <String, dynamic>{
          'countryCode': user.countryCode,
          'phoneNumber': user.phoneNumber,
          'password': user.password,
          'verifyCode': user.verifyCode
        })
        .then((value) => SignInResult.fromMap(value))
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Resets a user's password using the email address.
  Future<void> resetPasswordWithEmail(
      String email, String newPassword, String verifyCode) {
    return _channel.invokeMethod('resetPasswordWithEmail', <String, dynamic>{
      'email': email,
      'password': newPassword,
      'verifyCode': verifyCode
    }).catchError(PlatformAuth.handlePlatformException);
  }

  /// Resets a user's password using the mobile number.
  Future<void> resetPasswordWithPhone(String countryCode, String phoneNumber,
      String newPassword, String verifyCode) {
    return _channel.invokeMethod('resetPasswordWithPhone', <String, dynamic>{
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'password': newPassword,
      'verifyCode': verifyCode
    }).catchError(PlatformAuth.handlePlatformException);
  }

  /// Set AutoCollectionAAID
  Future<void> setAutoCollectionAAID(bool isAutoCollection) {
    return _channel.invokeListMethod("setAutoCollectionAAID", <String, dynamic>{
      'isAutoCollection': isAutoCollection
    }).catchError(PlatformAuth.handlePlatformException);
  }

  /// Applies for a verification code using an email address.
  Future<VerifyCodeResult?> requestVerifyCodeWithEmail(
      String email, VerifyCodeSettings settings) {
    return PlatformAuth.methodChannel
        .invokeMethod('requestAuthEmailVerifyCode', <String, dynamic>{
      'email': email,
      'settings': settings.toMap(),
    })
        .then((value) => value != null ? VerifyCodeResult.fromMap(value) : null)
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Applies for a verification code using a mobile number.
  Future<VerifyCodeResult?> requestVerifyCodeWithPhone(
      String countryCode, String phoneNumber, VerifyCodeSettings settings) {
    return PlatformAuth.methodChannel
        .invokeMethod('requestAuthPhoneVerifyCode', <String, dynamic>{
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'settings': settings.toMap(),
    })
        .then((value) => value != null ? VerifyCodeResult.fromMap(value) : null)
        .catchError(PlatformAuth.handlePlatformException);
  }

  /// Obtains the list of supported authentication modes. This API needs to be used with the third-party SDK for unified sign-in or packaging in aggregation services.
  Future<List<int>?> getSupportedAuthList(){
    return _channel
        .invokeMethod("getSupportedAuthList")
        .then((value) => value != null ? _getAuthListFromHash(value)  : null)
        .catchError(PlatformAuth.handlePlatformException);
  }


  /// Get AutoCollectionAAID
  Future<bool?> isAutoCollectionAAID() {
    return _channel
        .invokeMethod("isAutoCollectionAAID")
        .then((value) => value != null ? _getAutoCollectionFromHash(value)  : null)
        .catchError(PlatformAuth.handlePlatformException);
  }

  bool _getAutoCollectionFromHash(Map map){
    bool isAutoCollection = map["isAutoCollection"];
    return isAutoCollection;
  }

  List<int> _getAuthListFromHash(Map map){
    List<int> supportedAuthList = map["supportedAuthList"].cast<int>();
    return supportedAuthList;
  }
}
