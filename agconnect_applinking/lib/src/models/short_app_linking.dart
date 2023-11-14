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
import 'dart:convert';

class ShortAppLinking {
  Uri? shortLink;
  Uri? testUrl;

  ShortAppLinking._({
    this.shortLink,
    this.testUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'shortLink': shortLink,
      'testUrl': testUrl,
    };
  }

  factory ShortAppLinking.fromMap(Map<dynamic, dynamic> map) {
    return ShortAppLinking._(
      shortLink: map["shortLink"] == null ? null : Uri.parse(map["shortLink"]),
      testUrl: map["testUrl"] == null ? null : Uri.parse(map["testUrl"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShortAppLinking.fromJson(String source) =>
      ShortAppLinking.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShortAppLinking(shortLink: $shortLink, '
        'testUrl: $testUrl)';
  }
}
