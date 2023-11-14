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

class AppMessage {
  final String id;
  final int startTime;
  final int endTime;
  final AGCAppMessagingDisplayFrequencyType frequencyType;
  final int frequencyValue;
  final int testFlag;
  final AGCAppMessagingDismissType? dismissType;
  final List<String> triggerEvents;
  final AGCAppMessagingMessageType messageType;
  final CardMessage? cardMessage;
  final BannerMessage? bannerMessage;
  final PictureMessage? pictureMessage;

  AppMessage._(Map<String, dynamic> map)
      : id = map['base']?['id'],
        startTime = map['base']?['startTime'],
        endTime = map['base']?['endTime'],
        frequencyType = AGCAppMessagingDisplayFrequencyType
            .values[map['base']?['frequencyType'] - 1],
        frequencyValue = map['base']?['frequencyValue'],
        testFlag = map['base']?['testFlag'],
        dismissType = map['dismissType'] == null
            ? null
            : AGCAppMessagingDismissType.values.firstWhere(
                (e) => map['dismissType'] == describeEnum(e),
              ),
        triggerEvents = List<String>.from(map['base']?['triggerEvents']),
        messageType = AGCAppMessagingMessageType.values.firstWhere(
          (e) => map['base']?['messageType'] == describeEnum(e),
          orElse: () => AGCAppMessagingMessageType.UNKNOWN,
        ),
        cardMessage = map['card'] == null
            ? null
            : CardMessage._(Map<String, dynamic>.from(map['card'])),
        bannerMessage = map['banner'] == null
            ? null
            : BannerMessage._(Map<String, dynamic>.from(map['banner'])),
        pictureMessage = map['picture'] == null
            ? null
            : PictureMessage._(Map<String, dynamic>.from(map['picture']));

  @override
  String toString() {
    return '$AppMessage('
        'id: $id, '
        'startTime: $startTime, '
        'endTime: $endTime, '
        'frequencyType: $frequencyType, '
        'frequencyValue: $frequencyValue, '
        'testFlag: $testFlag, '
        'dismissType: $dismissType, '
        'triggerEvents: $triggerEvents, '
        'messageType: $messageType, '
        'cardMessage: ${cardMessage ?? 'null'}, '
        'bannerMessage: ${bannerMessage ?? 'null'}, '
        'pictureMessage: ${pictureMessage ?? 'null'})';
  }
}
