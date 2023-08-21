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

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// User Defined Log Level
enum LogLevel { debug, info, warning, error }

/// External API class of the Crash service in AppGallery Connect
class AGCCrash {
  static const MethodChannel _channel =
      const MethodChannel('com.huawei.flutter/agconnect_crash');

  /// AGCCrash Instance
  static final AGCCrash instance = AGCCrash();

  ///Call the onFlutterError and recordError methods in the main function to
  ///automatically record all exceptions that occur in your app.
  ///```
  ///void main() {
  ///   FlutterError.onError = AGCCrash.instance.onFlutterError;
  ///   runZonedGuarded<Future<void>>(() async {
  ///     runApp(MyApp());
  ///}, (Object error, StackTrace stackTrace) {
  ///   AGCCrash.instance.recordError(error, stackTrace, true);
  /// });
  ///}
  ///```
  /// try to implement this by
  /// ```
  ///try {
  /// //your code
  ///} catch (error, stackTrace) {
  ///  AGCCrash.instance.recordError(error, stackTrace, true);
  ///}
  /// ```
  Future<void> onFlutterError(FlutterErrorDetails details) async {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
    recordError(details.exceptionAsString(), details.stack!);
  }

  ///Call the onFlutterError and recordError methods in the main function to
  ///automatically record all exceptions that occur in your app.
  ///```
  ///void main() {
  ///   FlutterError.onError = AGCCrash.instance.onFlutterError;
  ///   runZonedGuarded<Future<void>>(() async {
  ///   runApp(MyApp());
  ///}, (Object error, StackTrace stackTrace) {
  ///   AGCCrash.instance.recordError(error, stackTrace, true);
  /// });
  ///}
  ///```
  /// try to implement this by
  /// ```
  ///try {
  ///  // <your code>
  ///} catch (error, stackTrace) {
  ///  AGCCrash.instance.recordError(error, stackTrace, true);
  ///}
  /// ```
  Future<void> recordError(dynamic exception, StackTrace stack,
      {bool fatal = false}) async {
    debugPrint(
        'Error caught by AGCCrash : ${exception.toString()} \n${stack.toString()}');
    await _channel.invokeMethod('recordError', <String, String>{
      'reason': exception.toString(),
      'stack': stack.toString(),
      'fatal': fatal.toString(),
    });
    return;
  }

  /// a Fatal Crash to test your app by
  /// ```
  /// AGCCrash.instance.testIt();
  /// ```
  /// this code will fail your app
  Future<void> testIt() {
    return _channel.invokeMethod('testIt');
  }

  /// Enable crash collection by
  /// ```
  /// AGCCrash.instance.enableCrashCollection(true);
  /// ```
  /// or disable crash collection by
  /// ```
  /// AGCCrash.instance.enableCrashCollection(false);
  /// ```
  Future<void> enableCrashCollection(bool enable) {
    return _channel.invokeMethod('enableCrashCollection', <String, bool>{
      'enable': enable,
    });
  }

  /// You can allocate a custom user ID to a user to uniquely identify the user.
  /// These user IDs will help you learn about the users who have specific crashes.
  /// ```
  /// AGCCrash.instance.setUserId("12345");
  /// ```
  Future<void> setUserId(String userId) {
    return _channel.invokeMethod('setUserId', <String, String>{
      'userId': userId,
    });
  }

  /// To obtain the app status in which a crash occurs,
  /// you can add a custom key-value pair to record the status.
  /// The recorded status will be reported together with the crash data.
  /// ```
  /// //Add a key-value pair of the string type.
  /// AGCCrash.instance.setCustomKey("stringKey", "world");
  /// //Add a key-value pair of the boolean type.
  /// AGCCrash.instance.setCustomKey("booleanKey", false);
  /// //Add a key-value pair of the number type.
  /// AGCCrash.instance.setCustomKey("numberKey", 1.1);
  /// ```
  Future<void> setCustomKey(String key, dynamic value) {
    return _channel.invokeMethod('setCustomKey',
        <String, String>{'key': key, 'value': value.toString()});
  }

  /// You can record custom logs,
  /// which will be reported together with the crash data.
  /// You can check a crash report with custom log information in AppGallery Connect
  /// ```
  /// AGCCrash.instance.log(message: "set info log");
  /// ```
  Future<void> log({LogLevel level = LogLevel.info, required String message}) {
    return _channel.invokeMethod('customLog',
        <String, dynamic>{'level': level.index, 'message': message});
  }
}
