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

class ResolvedLinkData {
  int? clickTimestamp;
  Uri? deepLink;
  String? socialTitle;
  String? socialDescription;
  String? socialImageUrl;
  String? campaignName;
  String? campaignMedium;
  String? campaignSource;
  String? installSource;
  LinkType? linkType;

  ResolvedLinkData(
      {this.clickTimestamp = 0,
      this.socialTitle = "",
      this.socialDescription = "",
      this.socialImageUrl = "",
      this.deepLink,
      this.campaignName = "",
      this.campaignMedium = "",
      this.campaignSource = "",
      this.installSource = "",
      this.linkType});

  Map<String, dynamic> toMap() {
    return {
      'clickTimestamp': clickTimestamp,
      'deepLink': deepLink.toString(),
      'socialTitle': socialTitle,
      'socialDescription': socialDescription,
      'socialImageUrl': socialImageUrl,
      'campaignName': campaignName,
      'campaignMedium': campaignMedium,
      'campaignSource': campaignSource,
      'installSource': installSource,
      'linkType': linkType!.index,
    };
  }

  factory ResolvedLinkData.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return ResolvedLinkData();

    return ResolvedLinkData(
        clickTimestamp:
            map["clickTimestamp"] == null ? null : map["clickTimestamp"],
        deepLink: map["deepLink"] == null ? null : Uri.parse(map["deepLink"]),
        socialTitle: map["socialTitle"] == null ? null : map["socialTitle"],
        socialDescription:
            map["socialDescription"] == null ? null : map["socialDescription"],
        socialImageUrl:
            map["socialImageUrl"] == null ? null : map["socialImageUrl"],
        campaignName: map["campaignName"] == null ? null : map["campaignName"],
        campaignMedium:
            map["campaignMedium"] == null ? null : map["campaignMedium"],
        campaignSource:
            map["campaignSource"] == null ? null : map["campaignSource"],
        installSource:
            map["installSource"] == null ? null : map["installSource"],
        linkType: map["linkType"] == null
            ? null
            : (map["linkType"] == 0
                ? LinkType.AppLinking
                : LinkType.UnifiedLinking));
  }

  String toJson() => json.encode(toMap());

  factory ResolvedLinkData.fromJson(String source) =>
      ResolvedLinkData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResolvedLinkData(clickTimestamp: $clickTimestamp, '
        'deepLink: $deepLink,  '
        'socialTitle: $socialTitle, socialDescription: $socialDescription, '
        'socialImageUrl: $socialImageUrl, campaignName: $campaignName, '
        'campaignMedium: $campaignMedium, campaignSource: $campaignSource,'
        '  installSource: $installSource, linkType: $linkType)';
  }
}

enum LinkType { AppLinking, UnifiedLinking }
