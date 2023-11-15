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
// ignore_for_file: constant_identifier_names

part of agconnect_appmessaging;

enum AGCAppMessagingDisplayLocation {
  BOTTOM,
  CENTER,
}

enum AGCAppMessagingMessageType {
  UNKNOWN,
  CARD,
  PICTURE,
  BANNER,
}

enum AGCAppMessagingDisplayFrequencyType {
  ONLY_ONCE,

  /// The value of X is the return value of frequencyValue.
  ONCE_EVERY_X_DAYS,

  /// The value of X is the return value of frequencyValue.
  X_TIMES_PER_DAY,
}

enum AGCAppMessagingDismissType {
  /// Close button or redirection link tapping.
  CLICK,

  /// Tapping outside the message borders.
  CLICK_OUTSIDE,

  /// Automatic closing. Only banner messages can be automatically closed within 15 seconds.
  AUTO,

  /// Back button tapping.
  BACK_BUTTON,

  /// Slide to close. Only banner messages are supported.
  SWIPE,
}

enum AGCAppMessagingEventType {
  onMessageDisplay,
  onMessageClick,
  onMessageDismiss,
  onMessageError,
}
