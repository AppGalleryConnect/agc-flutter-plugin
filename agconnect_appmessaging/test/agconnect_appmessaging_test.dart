/*
 * Copyright 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_appmessaging/agconnect_appmessaging.dart';
import 'package:flutter/foundation.dart';

void main() {
  group('AGCAppMessaging Tests', () {
    const MethodChannel channel =
        MethodChannel('com.huawei.agc.flutter.appmessaging_methodchannel');
    const AGCAppMessagingDisplayLocation expectedLocation =
        AGCAppMessagingDisplayLocation.CENTER;

    List<MethodCall> calls = [];
    final AGCAppMessaging appMessaging = AGCAppMessaging.getInstance();

    TestWidgetsFlutterBinding.ensureInitialized();
    const String expectedEventId = 'test_event';
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        calls.add(methodCall);
        switch (methodCall.method) {
          case "handleCustomViewMessageEvent":
            break;
          case "isDisplayEnable":
            return true;
          case "trigger":
            break;
          case "isFetchMessageEnable":
            return true;
          case "removeCustomView":
            break;
          case "setDisplayEnable":
            break;
          case "setDisplayLocation":
            break;
          case "setFetchMessageEnable":
            break;
          default:
            throw PlatformException(
                code: '1', message: 'Method is not implemented');
        }
        return null;
      });
    });

    test(
        'handleCustomViewMessageEvent should invoke the method channel with the given arguments',
        () async {
      const eventType = AGCAppMessagingEventType.onMessageDisplay;
      const dismissType = AGCAppMessagingDismissType.CLICK;

      await appMessaging.handleCustomViewMessageEvent(eventType, dismissType);

      expect(calls, <Matcher>[
        isMethodCall('handleCustomViewMessageEvent',
            arguments: <String, dynamic>{
              'eventType': describeEnum(eventType),
              'dismissType': 'dismissTypeClick',
            }),
      ]);
      calls.clear();
    });
    test('isDisplayEnable should return true', () async {
      final bool actualResult = await appMessaging.isDisplayEnable();
      expect(actualResult, true);
      calls.clear();
    });

    test('trigger should invoke the method channel with the given argument',
        () async {
      await appMessaging.trigger(expectedEventId);

      expect(calls, <Matcher>[
        isMethodCall('trigger', arguments: expectedEventId),
      ]);
      calls.clear();
    });
    test('isFetchMessageEnable should return true', () async {
      final bool actualResult = await appMessaging.isFetchMessageEnable();
      expect(actualResult, true);
      calls.clear();
    });
    test('removeCustomView should invoke the method channel with no arguments',
        () async {
      await appMessaging.removeCustomView();

      expect(calls, <Matcher>[
        isMethodCall('removeCustomView', arguments: <String, dynamic>{}),
      ]);
      calls.clear();
    });
    test('setDisplayEnable should set display enable to true', () async {
      await appMessaging.setDisplayEnable(true);

      expect(calls, <Matcher>[
        isMethodCall('setDisplayEnable', arguments: true),
      ]);
      calls.clear();

      await appMessaging.setDisplayEnable(false);

      expect(calls, <Matcher>[
        isMethodCall('setDisplayEnable', arguments: false),
      ]);
      calls.clear();
    });
    test(
        'setDisplayLocation should invoke the method channel with the given argument',
        () async {
      await appMessaging.setDisplayLocation(expectedLocation);

      expect(calls, <Matcher>[
        isMethodCall('setDisplayLocation', arguments: expectedLocation.index),
      ]);
      calls.clear();
    });
    test(
        'setFetchMessageEnable should invoke the method channel with the given argument',
        () async {
      await appMessaging.setFetchMessageEnable(true);

      expect(calls, <Matcher>[
        isMethodCall('setFetchMessageEnable', arguments: true),
      ]);
      calls.clear();

      await appMessaging.setFetchMessageEnable(false);

      expect(calls, <Matcher>[
        isMethodCall('setFetchMessageEnable', arguments: false),
      ]);
      calls.clear();
    });
  });
}
