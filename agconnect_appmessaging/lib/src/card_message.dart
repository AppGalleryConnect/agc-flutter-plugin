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

class CardMessage {
  final String title;
  final String titleColor;
  final num titleColorOpenness;
  final String? body;
  final String bodyColor;
  final num bodyColorOpenness;
  final String backgroundColor;
  final num backgroundColorOpenness;
  final String portraitPictureUrl;
  final String landscapePictureUrl;
  final CardMessageButton majorButton;
  final CardMessageButton? minorButton;

  CardMessage._(Map<String, dynamic> map)
      : title = map['title'],
        titleColor = map['titleColor'],
        titleColorOpenness = map['titleColorOpenness'],
        body = map['body'],
        bodyColor = map['bodyColor'],
        bodyColorOpenness = map['bodyColorOpenness'],
        backgroundColor = map['backgroundColor'],
        backgroundColorOpenness = map['backgroundColorOpenness'],
        portraitPictureUrl = map['portraitPictureURL'],
        landscapePictureUrl = map['landscapePictureURL'],
        majorButton =
            CardMessageButton._(Map<String, dynamic>.from(map['majorButton'])),
        minorButton = map['minorButton'] == null
            ? null
            : CardMessageButton._(
                Map<String, dynamic>.from(map['minorButton']));

  @override
  String toString() {
    return '$CardMessage('
        'title: $title, '
        'titleColor: $titleColor, '
        'titleColorOpenness: $titleColorOpenness, '
        'body: $body, '
        'bodyColor: $bodyColor, '
        'bodyColorOpenness: $bodyColorOpenness, '
        'backgroundColor: $backgroundColor, '
        'backgroundColorOpenness: $backgroundColorOpenness, '
        'portraitPictureUrl: $portraitPictureUrl, '
        'landscapePictureUrl: $landscapePictureUrl, '
        'majorButton: $majorButton, '
        'minorButton: ${minorButton ?? 'null'})';
  }
}
