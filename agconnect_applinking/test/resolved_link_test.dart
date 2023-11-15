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

import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_applinking/src/models/resolved_link_data.dart';

void main() {
  group('ResolvedLinkData', () {
    test('Should correctly serialize to JSON', () {
      final resolvedLinkData = ResolvedLinkData(
        clickTimestamp: 123456789,
        deepLink: Uri.parse('https://example.com/deeplink'),
        socialTitle: 'Social Title',
        socialDescription: 'Social Description',
        socialImageUrl: 'https://example.com/image.jpg',
        campaignName: 'Campaign Name',
        campaignMedium: 'Campaign Medium',
        campaignSource: 'Campaign Source',
        installSource: 'Install Source',
        linkType: LinkType.AppLinking,
      );

      final jsonResult = resolvedLinkData.toJson();

      final expectedJson =
          '{"clickTimestamp":123456789,"deepLink":"https://example.com/deeplink","socialTitle":"Social Title","socialDescription":"Social Description","socialImageUrl":"https://example.com/image.jpg","campaignName":"Campaign Name","campaignMedium":"Campaign Medium","campaignSource":"Campaign Source","installSource":"Install Source","linkType":0}';
      expect(jsonResult, equals(expectedJson));
    });

    test('Should correctly deserialize from JSON', () {
      final jsonString =
          '{"clickTimestamp":123456789,"deepLink":"https://example.com/deeplink","socialTitle":"Social Title","socialDescription":"Social Description","socialImageUrl":"https://example.com/image.jpg","campaignName":"Campaign Name","campaignMedium":"Campaign Medium","campaignSource":"Campaign Source","installSource":"Install Source","linkType":0}';

      final resolvedLinkData = ResolvedLinkData.fromJson(jsonString);

      final expectedClickTimestamp = 123456789;
      final expectedDeepLink = Uri.parse('https://example.com/deeplink');
      final expectedSocialTitle = 'Social Title';
      final expectedSocialDescription = 'Social Description';
      final expectedSocialImageUrl = 'https://example.com/image.jpg';
      final expectedCampaignName = 'Campaign Name';
      final expectedCampaignMedium = 'Campaign Medium';
      final expectedCampaignSource = 'Campaign Source';
      final expectedInstallSource = 'Install Source';
      final expectedLinkType = LinkType.AppLinking;

      expect(resolvedLinkData.clickTimestamp, equals(expectedClickTimestamp));
      expect(resolvedLinkData.deepLink, equals(expectedDeepLink));
      expect(resolvedLinkData.socialTitle, equals(expectedSocialTitle));
      expect(resolvedLinkData.socialDescription,
          equals(expectedSocialDescription));
      expect(resolvedLinkData.socialImageUrl, equals(expectedSocialImageUrl));
      expect(resolvedLinkData.campaignName, equals(expectedCampaignName));
      expect(resolvedLinkData.campaignMedium, equals(expectedCampaignMedium));
      expect(resolvedLinkData.campaignSource, equals(expectedCampaignSource));
      expect(resolvedLinkData.installSource, equals(expectedInstallSource));
      expect(resolvedLinkData.linkType, equals(expectedLinkType));
    });

    test('Should correctly convert to map', () {
      final resolvedLinkData = ResolvedLinkData(
        clickTimestamp: 123456789,
        deepLink: Uri.parse('https://example.com/deeplink'),
        socialTitle: 'Social Title',
        socialDescription: 'Social Description',
        socialImageUrl: 'https://example.com/image.jpg',
        campaignName: 'Campaign Name',
        campaignMedium: 'Campaign Medium',
        campaignSource: 'Campaign Source',
        installSource: 'Install Source',
        linkType: LinkType.AppLinking,
      );

      final resultMap = resolvedLinkData.toMap();

      final expectedMap = {
        'clickTimestamp': 123456789,
        'deepLink': 'https://example.com/deeplink',
        'socialTitle': 'Social Title',
        'socialDescription': 'Social Description',
        'socialImageUrl': 'https://example.com/image.jpg',
        'campaignName': 'Campaign Name',
        'campaignMedium': 'Campaign Medium',
        'campaignSource': 'Campaign Source',
        'installSource': 'Install Source',
        'linkType': 0,
      };

      expect(resultMap, equals(expectedMap));
    });

    test('Should correctly create instance from map', () {
      final map = {
        'clickTimestamp': 123456789,
        'deepLink': 'https://example.com/deeplink',
        'socialTitle': 'Social Title',
        'socialDescription': 'Social Description',
        'socialImageUrl': 'https://example.com/image.jpg',
        'campaignName': 'Campaign Name',
        'campaignMedium': 'Campaign Medium',
        'campaignSource': 'Campaign Source',
        'installSource': 'Install Source',
        'linkType': 0,
      };

      final resolvedLinkData = ResolvedLinkData.fromMap(map);

      final expectedClickTimestamp = 123456789;
      final expectedDeepLink = Uri.parse('https://example.com/deeplink');
      final expectedSocialTitle = 'Social Title';
      final expectedSocialDescription = 'Social Description';
      final expectedSocialImageUrl = 'https://example.com/image.jpg';
      final expectedCampaignName = 'Campaign Name';
      final expectedCampaignMedium = 'Campaign Medium';
      final expectedCampaignSource = 'Campaign Source';
      final expectedInstallSource = 'Install Source';
      final expectedLinkType = LinkType.AppLinking;

      expect(resolvedLinkData.clickTimestamp, equals(expectedClickTimestamp));
      expect(resolvedLinkData.deepLink, equals(expectedDeepLink));
      expect(resolvedLinkData.socialTitle, equals(expectedSocialTitle));
      expect(resolvedLinkData.socialDescription,
          equals(expectedSocialDescription));
      expect(resolvedLinkData.socialImageUrl, equals(expectedSocialImageUrl));
      expect(resolvedLinkData.campaignName, equals(expectedCampaignName));
      expect(resolvedLinkData.campaignMedium, equals(expectedCampaignMedium));
      expect(resolvedLinkData.campaignSource, equals(expectedCampaignSource));
      expect(resolvedLinkData.installSource, equals(expectedInstallSource));
      expect(resolvedLinkData.linkType, equals(expectedLinkType));
    });

    test('Should return correct string representation', () {
      final resolvedLinkData = ResolvedLinkData(
        clickTimestamp: 123456789,
        deepLink: Uri.parse('https://example.com/deeplink'),
        socialTitle: 'Social Title',
        socialDescription: 'Social Description',
        socialImageUrl: 'https://example.com/image.jpg',
        campaignName: 'Campaign Name',
        campaignMedium: 'Campaign Medium',
        campaignSource: 'Campaign Source',
        installSource: 'Install Source',
        linkType: LinkType.AppLinking,
      );

      final resultString = resolvedLinkData.toString();

      final expectedString = 'ResolvedLinkData(clickTimestamp: 123456789, '
          'deepLink: https://example.com/deeplink,  '
          'socialTitle: Social Title, socialDescription: Social Description, '
          'socialImageUrl: https://example.com/image.jpg, campaignName: Campaign Name, '
          'campaignMedium: Campaign Medium, campaignSource: Campaign Source,'
          '  installSource: Install Source, linkType: LinkType.AppLinking)';
      expect(resultString, equals(expectedString));
    });
  });
}
