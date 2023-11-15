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

class BannerMessage {
  final String title;
  final String titleColor;
  final num titleColorOpenness;
  final String? body;
  final String bodyColor;
  final num bodyColorOpenness;
  final String backgroundColor;
  final num backgroundColorOpenness;
  final String? pictureUrl;
  final String? actionUrl;
  final int? actionType;
  BannerMessage._(Map<String, dynamic> map)
      : title = map['title'],
        titleColor = map['titleColor'],
        titleColorOpenness = map['titleColorOpenness'],
        body = map['body'],
        bodyColor = map['bodyColor'],
        bodyColorOpenness = map['bodyColorOpenness'],
        backgroundColor = map['backgroundColor'],
        backgroundColorOpenness = map['backgroundColorOpenness'],
        pictureUrl = map['pictureURL'],
        actionType = map['actionType'],
        actionUrl = map['actionURL'];

  @override
  String toString() {
    return '$BannerMessage('
        'title: $title, '
        'titleColor: $titleColor, '
        'titleColorOpenness: $titleColorOpenness, '
        'body: $body, '
        'bodyColor: $bodyColor, '
        'bodyColorOpenness: $bodyColorOpenness, '
        'backgroundColor: $backgroundColor, '
        'backgroundColorOpenness: $backgroundColorOpenness, '
        'pictureUrl: $pictureUrl, '
        'actionType: $actionType, '
        'actionUrl: $actionUrl)';
  }
}
