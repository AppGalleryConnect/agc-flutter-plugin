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
part of agconnect_appmessaging;

class AGCAppMessaging {
  static AGCAppMessaging? _instance;
  static AGCAppMessaging getInstance() => (_instance ??= AGCAppMessaging._());

  /// listener for message display events.
  final Stream<AppMessage> onMessageDisplay;

  /// Listener for message tap events.
  final Stream<AppMessage> onMessageClick;

  /// Listener for message closing events.
  final Stream<AppMessage> onMessageDismiss;

  /// Listener for message error events.
  final Stream<AppMessage> onMessageError;

  /// Listener for custom events.
  final Stream<AppMessage?> onCustomEvent;

  AGCAppMessaging._()
      : onMessageDisplay = _eventChannelOnMessageDisplay
            .receiveBroadcastStream()
            .asBroadcastStream()
            .map((dynamic event) {
          return AppMessage._(Map<String, dynamic>.from(event));
        }),
        onMessageClick = _eventChannelOnMessageClick
            .receiveBroadcastStream()
            .asBroadcastStream()
            .map((dynamic event) {
          return AppMessage._(Map<String, dynamic>.from(event));
        }),
        onMessageDismiss = _eventChannelOnMessageDismiss
            .receiveBroadcastStream()
            .asBroadcastStream()
            .map((dynamic event) {
          return AppMessage._(Map<String, dynamic>.from(event));
        }),
        onMessageError = _eventChannelOnMessageError
            .receiveBroadcastStream()
            .asBroadcastStream()
            .map((dynamic event) {
          return AppMessage._(Map<String, dynamic>.from(event));
        }),
        onCustomEvent = _eventChannelCustomEvent
            .receiveBroadcastStream()
            .asBroadcastStream()
            .map((dynamic event) {
          return Map<String, dynamic>.from(event).isEmpty
              ? null
              : AppMessage._(Map<String, dynamic>.from(event));
        });

  /// Checks whether the App Messaging SDK is allowed to display in-app messages.
  Future<bool> isDisplayEnable() async {
    try {
      final bool? result = await _methodChannel.invokeMethod<bool?>(
        'isDisplayEnable',
        <String, dynamic>{},
      );
      return result!;
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }

  /// Sets whether to allow the App Messaging SDK to display in-app messages.
  Future<void> setDisplayEnable(bool enable) async {
    try {
      await _methodChannel.invokeMethod<void>(
        'setDisplayEnable',
        enable,
      );
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }

  /// Checks whether the App Messaging SDK is allowed to synchronize
  /// in-app message data from the AppGallery Connect server.
  Future<bool> isFetchMessageEnable() async {
    try {
      final bool? result = await _methodChannel.invokeMethod<bool?>(
        'isFetchMessageEnable',
        <String, dynamic>{},
      );
      return result!;
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }

  /// Sets the forcible in-app message data obtaining flag.
  /// When the flag is enabled, you can obtain latest in-app message data
  /// from the AppGallery Connect server in real time.
  ///
  /// **WARNING:** This method can be used only for message testing during app tests.
  /// Do not call this method in an official version of the app.
  Future<void> setForceFetch() async {
    try {
      await _methodChannel.invokeMethod<void>(
        'setForceFetch',
        <String, dynamic>{},
      );
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }

  /// Sets whether to allow the App Messaging SDK to synchronize
  /// in-app message data from the AppGallery Connect server.
  Future<void> setFetchMessageEnable(bool enable) async {
    try {
      await _methodChannel.invokeMethod<void>(
        'setFetchMessageEnable',
        enable,
      );
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }

  /// Sets the display position of a pop-up or image message.
  Future<void> setDisplayLocation(
      AGCAppMessagingDisplayLocation location) async {
    try {
      await _methodChannel.invokeMethod<void>(
        'setDisplayLocation',
        location.index,
      );
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }

  /// Deletes a custom in-app message layout.
  /// Then the default layout will be used.
  Future<void> removeCustomView() async {
    try {
      await _methodChannel.invokeMethod<void>(
        'removeCustomView',
        <String, dynamic>{},
      );
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }

  /// Triggers a custom event.
  Future<void> trigger(String eventId) async {
    try {
      await _methodChannel.invokeMethod<void>(
        'trigger',
        eventId,
      );
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }

  /// Processes custom events while using a custom layout.
  Future<void> handleCustomViewMessageEvent(
    AGCAppMessagingEventType eventType, [
    AGCAppMessagingDismissType? dismissType,
  ]) async {
    try {
      assert(eventType != AGCAppMessagingEventType.onMessageDismiss ||
          dismissType != null);

      await _methodChannel.invokeMethod<void>(
        'handleCustomViewMessageEvent',
        <String, dynamic>{
          'eventType': describeEnum(eventType),
          if (dismissType != null)
            'dismissType': () {
              switch (dismissType) {
                case AGCAppMessagingDismissType.CLICK:
                  return 'dismissTypeClick';
                case AGCAppMessagingDismissType.CLICK_OUTSIDE:
                  return 'dismissTypeClickOutside';
                case AGCAppMessagingDismissType.AUTO:
                  return 'dismissTypeAuto';
                case AGCAppMessagingDismissType.BACK_BUTTON:
                  return 'dismissTypeBack';
                case AGCAppMessagingDismissType.SWIPE:
                  return 'dismissTypeSwipe';
              }
            }.call(),
        },
      );
    } catch (e) {
      throw AGCAppMessagingException._from(e);
    }
  }
}
