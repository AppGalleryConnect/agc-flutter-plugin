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

import AGConnectAppLinking

public protocol ViewModelDelegate: AnyObject {
    func postData(data:[String:Any], result: FlutterResult)
    func postError(error: Error?, result: FlutterResult)
}

/// All the AppLinking API's can be reached via AGCAppLinkingViewModel class instance.
public class AGCAppLinkingViewModel {
    
    var delegate: ViewModelDelegate?
    var resolvedLinkMap = [String: Any]()
    
    func buildShortAppLinking(_ params: NSDictionary, result: @escaping FlutterResult){
        if let params = (params as? [String : Any]){
            let components = AGCAppLinkingComponents()
            buildLink(components: components, params: params)
            var agcShortAppLinkingLength : AGCShortLinkingLength?
            if let shortAppLinkingLength = params["shortAppLinkingLength"] as? String{
                switch shortAppLinkingLength {
                case "LONG":
                    agcShortAppLinkingLength = AGCShortLinkingLength.long
                default:
                    agcShortAppLinkingLength = AGCShortLinkingLength.short
                }
            }
            components.buildShortLink(agcShortAppLinkingLength!, callback: { [weak self] (shortLink, error) in
                guard let strongSelf = self else {return}
                if(error != nil) {
                    strongSelf.delegate?.postError(error: error, result: result)
                }else {
                    var map = [String: Any]()
                    if let shortUrl = shortLink {
                        map = ["shortLink" :shortUrl.url.absoluteString ,
                               "testUrl" :shortUrl.testUrl.absoluteString
                        ]
                        strongSelf.delegate?.postData(data: map, result: result)
                    }
                }
            })
        }
    }
    func buildLongAppLinking(_ params: NSDictionary , result: @escaping FlutterResult){
        if let params = (params as? [String : Any]){
            let components = AGCAppLinkingComponents()
            buildLink(components: components, params: params)
            let map = ["longLink" :components.buildLongLink().absoluteString]
            self.delegate?.postData(data: map, result: result)
        }
    }
    
    func buildLink(components: AGCAppLinkingComponents, params: [String : Any]){
        if let domainUriPrefix = params["domainUriPrefix"] as? String{
            components.uriPrefix = domainUriPrefix
        }
        
        if let deepLink = params["deepLink"] as? String{
            components.deepLink = deepLink
        }
        
        if let longLink = params["longLink"] as? String{
            components.longLink = longLink
        }
        
        if let socialCardInfo = params["socialCardInfo"] as? NSDictionary{
            buildSocialCardInfo(components: components, socialCardInfo: socialCardInfo)
        }
        
        if let campaignInfo = params["campaignInfo"] as? NSDictionary{
            buildCampaignInfo(components: components, campaignInfo: campaignInfo)
        }
        
        if let androidLinkInfo = params["androidLinkInfo"] as? NSDictionary{
            buildAndroidLinkInfo(components: components, androidLinkInfo: androidLinkInfo)
        }
        
        if let harmonyOSLinkInfo = params["harmonyOSLinkInfo"] as? NSDictionary{
            buildHarmonyOSLinkInfo(components: components, harmonyOSLinkInfo: harmonyOSLinkInfo)
        }
        
        if let iosLinkInfo = params["iosLinkInfo"] as? NSDictionary{
            buildiOSLinkInfo(components: components, iosLinkInfo: iosLinkInfo)
        }
        
        if let iTunesLinkInfo = params["iTunesLinkInfo"] as? NSDictionary{
            buildiTunesLinkInfo(components: components, iTunesLinkInfo: iTunesLinkInfo)
        }
        
        if let expireMinute = params["expireMinute"] as? Int {
            components.expireMinute = expireMinute
        }
        
        if let isShowPreview = params["isShowPreview"] as? Bool {
            components.isShowPreview = isShowPreview
        }
    }
    
    private func buildSocialCardInfo(components: AGCAppLinkingComponents, socialCardInfo: NSDictionary){
        if let socialDescription = socialCardInfo["description"] as? String{
            components.socialDescription = socialDescription
        }
        if let socialImageUrl = socialCardInfo["imageUrl"] as? String{
            components.socialImageUrl = socialImageUrl
        }
        if let socialTitle = socialCardInfo["title"] as? String{
            components.socialTitle = socialTitle
        }
    }
    
    private func buildCampaignInfo(components: AGCAppLinkingComponents, campaignInfo: NSDictionary){
        
        if let campaignName = campaignInfo["medium"] as? String{
            components.campaignName = campaignName
        }
        if let campaignMedium = campaignInfo["name"] as? String{
            components.campaignMedium = campaignMedium
        }
        if let campaignSource = campaignInfo["source"] as? String{
            components.campaignSource = campaignSource
        }
    }
    
    private func buildHarmonyOSLinkInfo(components: AGCAppLinkingComponents, harmonyOSLinkInfo: NSDictionary){
        
        if let packageName = harmonyOSLinkInfo["harmonyOSPackageName"] as? String{
            components.harmonyOSPackageName = packageName
        }
        if let harmonyOSDeepLink = harmonyOSLinkInfo["harmonyOSDeepLink"] as? String{
            components.harmonyOSDeepLink = harmonyOSDeepLink
        }
        if let fallbackUrl = harmonyOSLinkInfo["harmonyOSFallbackUrl"] as? String{
            components.harmonyOSFallbackUrl = fallbackUrl
        }
    }
    
    private func buildAndroidLinkInfo(components: AGCAppLinkingComponents, androidLinkInfo: NSDictionary){
        if let packageName = androidLinkInfo["androidPackageName"] as? String{
            components.androidPackageName = packageName
        }
        if let androidDeepLink = androidLinkInfo["androidDeepLink"] as? String{
            components.androidDeepLink = androidDeepLink
        }
        if let openType = androidLinkInfo["androidOpenType"] as? String{
            switch openType {
            case "AppGallery":
                components.androidOpenType = AGCLinkingAndroidOpenType.appGallery
            case "LocalMarket":
                components.androidOpenType = AGCLinkingAndroidOpenType.localMarket
            case "CustomUrl":
                components.androidOpenType = AGCLinkingAndroidOpenType.customURL
            default:
                components.androidOpenType = AGCLinkingAndroidOpenType.appGallery
            }
        }
        if let fallbackUrl = androidLinkInfo["androidFallbackUrl"] as? String{
            components.androidFallbackUrl = fallbackUrl
        }
    }
    
    private func buildiOSLinkInfo(components: AGCAppLinkingComponents, iosLinkInfo: NSDictionary){
        if let iosBundleId = iosLinkInfo["iosBundleId"] as? String{
            components.iosBundleId = iosBundleId
        }
        if let iosDeepLink = iosLinkInfo["iosDeepLink"] as? String{
            components.iosDeepLink = iosDeepLink
        }
        if let iosFallbackUrl = iosLinkInfo["iosFallbackUrl"] as? String{
            components.iosFallbackUrl = iosFallbackUrl
        }
        if let ipadBundleId = iosLinkInfo["ipadBundleId"] as? String{
            components.ipadBundleId = ipadBundleId
        }
        if let ipadFallbackUrl = iosLinkInfo["ipadFallbackUrl"] as? String{
            components.ipadFallbackUrl = ipadFallbackUrl
        }
    }
    
    private func buildiTunesLinkInfo(components: AGCAppLinkingComponents, iTunesLinkInfo: NSDictionary){
        if let iTunesConnectMediaType = iTunesLinkInfo["iTunesConnectMediaType"] as? String{
            components.iTunesConnectMediaType = iTunesConnectMediaType
        }
        if let iTunesConnectAffiliateToken = iTunesLinkInfo["iTunesConnectAffiliateToken"] as? String{
            components.iTunesConnectAffiliateToken = iTunesConnectAffiliateToken
        }
        if let iTunesConnectProviderToken = iTunesLinkInfo["iTunesConnectProviderToken"] as? String{
            components.iTunesConnectProviderToken = iTunesConnectProviderToken
        }
        if let iTunesConnectCampaignToken = iTunesLinkInfo["iTunesConnectCampaignToken"] as? String{
            components.iTunesConnectCampaignToken = iTunesConnectCampaignToken
        }
    }
}
