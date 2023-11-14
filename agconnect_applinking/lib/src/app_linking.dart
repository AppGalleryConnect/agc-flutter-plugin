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
import 'package:flutter/services.dart';

import '../agconnect_applinking.dart';

class AGCAppLinking {
  static const MethodChannel _channel =
      const MethodChannel('com.huawei.agc.flutter.applinking_methodchannel');
  static const EventChannel _eventChannel =
      const EventChannel("com.huawei.agc.flutter.applinking_eventchannel");

  Stream<ResolvedLinkData>? _onResolvedLinkData;

  /// Asynchronously generates a short link and the test URL.
  ///
  /// This method returns a [Future] that resolves to a [ShortAppLinking] object,
  /// which contains the short app link and the test URL of App Linking.
  ///
  /// The [applinkingInfo] parameter is an [AppLinkingWithInfo] object that
  /// specifies the information to be contained in the app link, such as the
  /// deep link, the social card, the campaign parameters, etc.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// try {
  ///   ShortAppLinking shortAppLinking = await agcAppLinking.buildShortAppLinking(appLinkingInfo);
  ///   print(shortAppLinking.toString());
  ///   _showDialogShort(context, shortAppLinking);
  /// } on PlatformException catch (e) {
  ///   _showDialog(context, e.toString());
  /// }
  /// ```
  /// @param applinkingInfo The information to be contained in the app link.
  ///
  /// @return A [Future] that resolves to a [ShortAppLinking] object.
  Future<ShortAppLinking> buildShortAppLinking(
      ApplinkingInfo applinkingInfo) async {
    try {
      ShortAppLinking shortAppLinking = ShortAppLinking.fromMap(await _channel
          .invokeMethod('buildShortAppLinking', applinkingInfo.toMap()));

      return shortAppLinking;
    } catch (e) {
      throw AppLinkingException.from(e);
    }
  }

  /// Asynchronously generates a long link.
  ///
  /// This method returns a [Future] that resolves to a [LongAppLinking] object,
  /// which contains the long app link of App Linking.
  ///
  /// The [applinkingInfo] parameter is an [AppLinkingWithInfo] object that
  /// specifies the information to be contained in the app link, such as the
  /// deep link, the social card, the campaign parameters, etc.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// try {
  ///   LongAppLinking longAppLinking = await agcAppLinking.buildLongAppLinking(appLinkingInfo);
  ///   print(longAppLinking.longLink.toString());
  ///   _showDialogLong(context, longAppLinking);
  /// } on PlatformException catch (e) {
  ///   _showDialog(context, e.toString());
  /// }
  /// ```
  ///
  /// @param applinkingInfo The information to be contained in the app link.
  ///
  /// @return A [Future] that resolves to a [LongAppLinking] object.

  Future<LongAppLinking> buildLongAppLinking(
      ApplinkingInfo applinkingInfo) async {
    try {
      LongAppLinking appLinking = LongAppLinking.fromMap(await _channel
          .invokeMethod('buildLongAppLinking', applinkingInfo.toMap()));
      return appLinking;
    } catch (e) {
      throw AppLinkingException.from(e);
    }
  }

  /// Fetches an object with the following parameters: deepLink, clickTimeStamp, socialTitle, socialDescription, socialImageUrl, campaignName, campaignMedium, and campaignSource.
  ///
  /// This method returns a [Stream] that emits a [ResolvedLinkData] object,
  /// which contains the App Linking data to be processed. The App Linking data
  /// includes the deep link, the click time stamp, the social card information,
  /// and the campaign parameters of the app link.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// StreamSubscription<ResolvedLinkData> _streamSubscription;
  /// final AGCAppLinking agcAppLinking = new AGCAppLinking();
  /// initState() {
  ///   super.initState();
  ///
  ///   _streamSubscription = agcAppLinking.onResolvedData.listen((event) {
  ///     _showDialog(context, event.toString());
  ///   });
  /// }
  /// ```
  ///
  /// @return A [Stream] that emits a [ResolvedLinkData] object.
  Stream<ResolvedLinkData>? get onResolvedData {
    if (_onResolvedLinkData == null) {
      _onResolvedLinkData = _eventChannel
          .receiveBroadcastStream()
          .map((event) => ResolvedLinkData.fromMap(event));
    }
    return _onResolvedLinkData;
  }
}
