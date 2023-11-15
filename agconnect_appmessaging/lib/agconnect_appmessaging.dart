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

library agconnect_appmessaging;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'src/agconnect_appmessaging.dart';
part 'src/app_message.dart';
part 'src/exception.dart';
part 'src/picture_message.dart';
part 'src/banner_message.dart';
part 'src/card_message_button.dart';
part 'src/card_message.dart';
part 'src/enums.dart';

const MethodChannel _methodChannel = MethodChannel(
  'com.huawei.agc.flutter.appmessaging_methodchannel',
);
const EventChannel _eventChannelOnMessageDisplay = EventChannel(
  'com.huawei.agc.flutter.appmessaging_eventchannel_onMessageDisplay',
);
const EventChannel _eventChannelOnMessageClick = EventChannel(
  'com.huawei.agc.flutter.appmessaging_eventchannel_onMessageClick',
);
const EventChannel _eventChannelOnMessageDismiss = EventChannel(
  'com.huawei.agc.flutter.appmessaging_eventchannel_onMessageDismiss',
);
const EventChannel _eventChannelOnMessageError = EventChannel(
  'com.huawei.agc.flutter.appmessaging_eventchannel_onMessageError',
);
const EventChannel _eventChannelCustomEvent = EventChannel(
  'com.huawei.agc.flutter.appmessaging_eventchannel_customEvent',
);
