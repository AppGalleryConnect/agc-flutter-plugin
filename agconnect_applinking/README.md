# AppGallery Connect Applinking Kit Flutter Plugin

---

## Contents

  - [1. Introduction](#1-introduction)
  - [2. Installation Guide](#2-installation-guide)
    * [Creating a Project in App Gallery Connect](#creating-a-project-in-appgallery-connect)
    * [Integrating the Flutter AppLinking Plugin](#integrating-the-flutter-applinking-plugin)
      - [Android App Development](#android-app-development)
      - [iOS App Development](#ios-app-development)
  - [3. API Reference](#3-api-reference)
      * [AGCAppLinking](#agcapplinking)
  - [4. Configuration and Description](#4-configuration-and-description)
  - [5. Sample Project](#5-sample-project)
  - [6. Licensing and Terms](#6-licensing-and-terms)

---

## 1. Introduction

App Linking allows you to create cross-platform links that can work as defined regardless of whether your app has been installed by a user. A link created in App Linking can be distributed through multiple channels to users. When a user taps the link, the user will be redirected to the specified in-app content. In App Linking, you can create both long and short links.
To identity the source of a user, you can set tracing parameters when creating a link of App Linking to trace traffic sources. By analyzing the link performance of each traffic source based on the tracing parameters, you can find the platform that can achieve the best promotion effect for your app.
This plugin enables communication between AppGallery Connect Applinking Kit SDK and Flutter platform. It exposes all functionality provided by AppGallery Connect  Applinking Kit SDK.

##### **Working Principles**

You can create a link of App Linking in any of the following modes:

Creating a link in AppGallery Connect

Creating a link by calling APIs on the client

Manually constructing a link

When a link is tapped, an action will be triggered based on the link opening mode that you have specified and whether the user has installed your app.

A link can be opened either in a browser or in your app, which is specified by you.

If you set the link as to be opened in a browser, a user can open the link in a browser either from a mobile device or PC.

If you set the link as to be opened in your app, when a user who has not installed the app taps the link, the user will be redirected to AppGallery (or a custom address) and instructed to install your app. After the user installs the app, the app will be launched and the in-app content will be displayed.

If a user who has installed your app taps the link, the user will be directly redirected to the target in-app content.

##### **Use Case**

**Waking Up Inactive Users/Increasing Views of a Specific Page**

You can create a user waking-up activity under Operate > Promotion > Manage promotions > Activities and then create a link of App Linking to direct users to the activity through social media, email, SMS message, or push message. If a user finds the activity attractive and taps the link, your app will be launched and the user will be redirected to the activity page and instructed to complete certain actions required by the activity, for example, sharing or making a payment. In this way, user activity is improved and the view count of the page increases.

**Converting Mobile Website Users into Native App Users**

When a mobile website user opens a common shared link (not a link of App Linking) on a page, the user needs to install the app first, go back to the page, and open the link again. App Linking can greatly improve user experience in this process by directly redirecting a user to the target in-app content after the user installs your app.

**Tracing Traffic Sources in Daily Marketing to Identity the Most Effective Marketing Platform**

You can set tracing parameters for a marketing link of App Linking to be placed on multiple marketing platforms so that you can identity which platform can achieve the best marketing result based on statistics collected for each platform and check whether users on this platform fit the user profile that you have defined at the beginning.

**Tracing Traffic Sources in Daily Marketing to Identity the Most Effective Marketing Platform**

App Linking can work with [Cloud Functions](https://developer.huawei.com/consumer/en/doc/development/AppGallery-connect-Guides/agc-cloudfunction-introduction) and [Cloud DB](https://developer.huawei.com/consumer/en/doc/development/AppGallery-connect-Guides/agc-clouddb-introduction) to encourage users to share links to their friends by offering incentives, effectively boosting user growth for your app.

---

## 2. Installation Guide

Before you get started, you must register as a HUAWEI Developer and complete identity verification on the [HUAWEI Developer](https://developer.huawei.com/consumer/en/) website. For details, please refer to [Register a HUAWEI ID](https://developer.huawei.com/consumer/en/doc/10104).

### Creating a Project in AppGallery Connect
Creating an app in AppGallery Connect is required in order to communicate with the Huawei services. To create an app, perform the following steps:

**Step 1.** Sign in to [AppGallery Connect](https://developer.huawei.com/consumer/en/service/josp/agc/index.html)  and select **My projects**.

**Step 2.** Select your project from the project list or create a new one by clicking the **Add Project** button.

**Step 3.** Go to **Project Setting** > **General information**, and click **Add app**.
If an app exists in the project and you need to add a new one, expand the app selection area on the top of the page and click **Add app**.

**Step 4.** On the **Add app** page, enter the app information, and click **OK**.

###  Integrating the Flutter AppLinking Plugin

####  Android App Development

**Step 1:** Sign in to [AppGallery Connect](https://developer.huawei.com/consumer/en/service/josp/agc/index.html) and select your project from **My Projects**. Then go to **Growing > App Linking Kit** and click **Enable Now** to enable the Huawei App Linking Kit Service. You can also check **Manage APIs** tab on the **Project Settings** page for the enabled AppGallery Connect services on your app.

**Step 2:** Go to **Project Setting > General information** page, under the **App information** field, click **agconnect-services.json** to download the configuration file.

**Step 3:** Copy the **agconnect-services.json** file to the **example/android/app/** directory of your project.

**Step 4:** Open the **build.gradle** file in the **example/android** directory of your project.

- Navigate to the **buildscript** section and configure the Maven repository address and agconnect plugin for the AppGallery Connect SDK.

  ```gradle
  buildscript {
    repositories {
        google()
        jcenter()
        maven { url 'https://developer.huawei.com/repo/' }
    }
  
    dependencies {
        /* 
          * <Other dependencies>
          */
        classpath 'com.huawei.agconnect:agcp:1.7.1.300'
    }
  }
  ```

- Go to **allprojects** and configure the Maven repository address for the AppGallery Connect SDK.

  ```gradle
  allprojects {
    repositories {
        google()
        jcenter()
        maven { url 'https://developer.huawei.com/repo/' }
    }
  }
  ```

**Step 5:** Open the **build.gradle** file in the **example/android/app/** directory.

- Add `apply plugin: 'com.huawei.agconnect'` line after other `apply` entries.

  ```gradle
  apply plugin: 'com.android.application'
  apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
  apply plugin: 'com.huawei.agconnect'
  ```

- Set your package name in **defaultConfig > applicationId** and set **minSdkVersion** to **19** or higher. Package name must match with the **package_name** entry in **agconnect-services.json** file. 

  ```gradle
  defaultConfig {
      applicationId "<package_name>"
      minSdkVersion 19
      /*
      * <Other configurations>
      */
  }
  ```

**Step 6:**  Edit **buildTypes** as follows and add **signingConfigs** below:

```gradle
signingConfigs {
      config {
             storeFile file('<keystore_file>.jks/.keystore')
             storePassword '<keystore_password>'
             keyAlias '<key_alias>'
             keyPassword '<key_password>'
         }
}
buildTypes {
    debug {
        signingConfig signingConfigs.config
    }
    release {
        signingConfig signingConfigs.config
    }
}
```

**NOTE**

  - Before obtaining the agconnect-services.json file, ensure that HUAWEI App Linking Kit has been enabled. For details about how to enable HUAWEI App Linking Kit, please refer to **Enabling Required Services**.
 - If you have made any changes in the development module, such as setting the data storage location and enabling or managing APIs, you need to download the latest agconnect-services.json file and replace the existing file in the app directory.

**Step 7**  To use deep links to receive data, you need to add the following configuration to the activity for processing links. Set **android:host** to the domain name in the **deepLink** and **android:scheme** to the custom scheme. When a user taps a link containing this deep link, your app uses this activity to process the link.

   ```xml
   <!-- AndroidManifest.xml. -->
   <intent-filter>
       <action android:name="android.intent.action.VIEW" />
       <category android:name="android.intent.category.DEFAULT" />
       <category android:name="android.intent.category.BROWSABLE" />
       <!-- Add the custom domain name and scheme -->
       <data android:host="<DeepLink_Host>" android:scheme="https" />
   </intent-filter>
   ```
**Step 8:**  Set Android launch mode in your Manifest file.
 ```xml
 <activity
    android:launchMode="standard">
   ```

**Step 9:** On your Flutter project directory, find and open your **pubspec.yaml** file and add the
 **agconnect_applinking** library to dependencies. For more details please refer to the [Using packages](https://flutter.dev/docs/development/packages-and-plugins/using-packages#dependencies-on-unpublished-packages) document.

  - To download the package from [pub.dev](https://pub.dev/publishers/developer.huawei.com/packages).

    ```yaml
      dependencies:
        agconnect_applinking: {library version}
    ```

**Step 10:** Run the following command to update package info.

```
[project_path]> flutter pub get
```

**Step 11:** Import the library to access the methods.

```dart
import 'package:agconnect_applinking/agconnect_applinking.dart';
```

**Step 12:** Run the following command to start the app.

```
[project_path]> flutter run
```

####  iOS App Development

**Step 1:** Sign in to [AppGallery Connect](https://developer.huawei.com/consumer/en/service/josp/agc/index.html) and select your project from **My Projects**. Then go to **Growing > App Linking Kit** and click **Enable Now** to enable the Huawei App Linking Kit Service. You can also check **Manage APIs** tab on the **Project Settings** page for the enabled AppGallery Connect services on your app.

**Step 2:** Go to **Project Setting > General information** page, under the **App information** field, click **agconnect-services.plist** to download the configuration file.

**Step 3:** Copy the **agconnect-services.plist** file to the app's root directory of your Xcode project.

**NOTE**

  - Before obtaining the agconnect-services.plist file, ensure that HUAWEI App Linking Kit has been enabled. For details
      about how to enable HUAWEI App Linking Kit, please refer to **Enabling Required Services**.

 - If you have made any changes in the development module, such as setting the data storage location and enabling or
    managing APIs, you need to download the latest agconnect-services.plist file and replace the existing file in the app
   directory.

**Step 4:** On your Flutter project directory, find and open your **pubspec.yaml** file and add the **agconnect_applinking** library to dependencies. For more details please refer to the [Using packages](https://flutter.dev/docs/development/packages-and-plugins/using-packages#dependencies-on-unpublished-packages) document.

  - To download the package from [pub.dev](https://pub.dev/publishers/developer.huawei.com/packages).

    ```yaml
      dependencies:
        agconnect_applinking: {library version}
    ```


**Step 5:** Check whether the received link is a link of App Linking and whether the app can process the link

   - If Using **Universal Link**: [Allowing Apps and Websites to Link to Your Content](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content#topics)

   - If using **Custom Scheme**: [Defining a Custom URL Scheme for Your App](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app)

**NOTE** Debugging Flutter

Other launch paths without a host computer, such as deep links or notifications, won't work on iOS 14 physical devices in debug mode.
You can also build the application or add-to-app module in profile or release mode, or on a simulator, which are not affected.
 For more details please refer to [information](https://flutter.dev/docs/development/ios-14)

         
**Step 6:** Run the following command to update package info.

```
[project_path]> flutter pub get
```

**Step 7:** Import the library to access the methods.

```dart
import 'package:agconnect_applinking/agconnect_applinking.dart';
```

**Step 8:** Run the following command to start the app.

```
[project_path]> flutter run
```

---

## 3. API Reference

### AGCAppLinking
Contains classes that provide methods to create cross-platform links that can work as defined regardless of whether your app has been installed by a user. A link created in App Linking can be distributed through multiple channels to users.

#### Public Constructor Summary
| Constructor    | Description          |
| -------------- | -------------------- |
| AGCAppLinking() | Default constructor. |

#### Public Method Summary
| Method                        		       |          Return Type          |                         Description                          |
| ---------------------------------------------------- | ----------------------------- | ------------------------------------------------------------ |
| [buildShortAppLinking(ApplinkingInfo applinkingInfo)](#futureshortapplinking-buildshortapplinkingapplinkinginfo-applinkinginfo-async) | Future\<ShortAppLinking\>                | This API is called to asynchronously generates a short link with a string-type suffix. You can specify the suffix as a long or short one. |
| [buildLongAppLinking(ApplinkingInfo applinkingInfo)](#futurelongapplinking-buildlongapplinkingapplinkinginfo-applinkinginfo-async) | Future\<LongAppLinking\>                | This API is called to obtain a long link. |
| [onResolvedData()](#streamresolvedlinkdata-onresolveddata-async) | Stream\<ResolvedLinkData\>                | This API is called to check whether there is data to be received from a specified link of App Linking.              |

#### Public  Constructors

##### AGCAppLinking()

Constructor for *AGCAppLinking* object.

#### Public Methods

##### Future\<ShortAppLinking> buildShortAppLinking(ApplinkingInfo applinkingInfo) *async*

 Generates a short link and test url.

 | Parameter | Description                                                  |
| --------- | ------------------------------------------------------------ |
| applinkingInfo  | Sets information to be contained in a link of App Linking. |

| Return Type    | Description               |
| -------------- | ------------------------- |
| Future\<ShortAppLinking\> | Short app link and test URL of App Linking. |

###### Call Example

```dart
    try {
      ShortAppLinking shortAppLinking =
          await agcAppLinking.buildShortAppLinking(appLinkingInfo);
      print(shortAppLinking.toString());
      _showDialogShort(context, shortAppLinking);
    } on PlatformException catch (e) {
      _showDialog(context, e.toString());
    }

```

##### Future\<LongAppLinking> buildLongAppLinking(ApplinkingInfo applinkingInfo) *async*

Generates a long link.

 | Parameter | Description                                                  |
| --------- | ------------------------------------------------------------ |
| applinkingInfo  | Sets information to be contained in a link of App Linking. |

| Return Type    | Description               |
| -------------- | ------------------------- |
| Future\<LongAppLinking\> | Long app link of App Linking. |

###### Call Example

```dart
    try {
      LongAppLinking longAppLinking =
          await agcAppLinking.buildLongAppLinking(appLinkingInfo);
      print(longAppLinking.longLink.toString());
      _showDialogLong(context, longAppLinking);
    } on PlatformException catch (e) {
      _showDialog(context, e.toString());
    }

```
##### Stream\<ResolvedLinkData> onResolvedData() *async*

Checks whether there is data to be received from a specified link of App Linking.

| Return Type    | Description                                          |
| -------------- | ---------------------------------------------------- |
| Stream\<ResolvedLinkData\> | App Linking data to be processed, which is returned asynchronously. |

###### Call Example

```dart
    _streamSubscription = agcAppLinking.onResolvedData.listen((event) async {
      print(event.toString());

    });

```

### Public Constants

#### ResolvedLinkData

- Represents the data class of App Linking.

| Field             | Type   | Description                                                   |
| ----------------- | ------ | ------------------------------------------------------------- |
| deepLink          | Uri | Obtains the deep link contained in a link of App Linking.     |
| clickTimeStamp    | int | Obtains the time when a link of App Linking is tapped.        |
| socialTitle       | string | Address of the preview title displayed during social sharing. |
| socialDescription | string | Preview description displayed during social sharing.          |
| socialImageUrl    | string | Address of the preview image displayed during social sharing. |
| campaignName      | string | Activity name.                                                |
| campaignMedium    | string | Activity medium.                                              |
| campaignSource    | string | Activity source.                                              |

#### ShortAppLinking

- Represents the data structure of App Linking short link and test URL.

| Field     | Type   | Description                                                |
| --------- | ------ | ---------------------------------------------------------- |
| shortLink | Uri | Short app link.                                            |
| testUrl   | Uri | URL for previewing the flowchart of a link of App Linking. |

#### LongAppLinking  

- Represents the data structure of App Linking long link.

| Field    | Type   | Description    |
| -------- | ------ | -------------- |
| longLink | Uri | Long app link. |

##### SocialCardInfo

- Represents the data structure of social sharing identifier information in App Linking.

| Field       | Type   | Description                                                   |
| ----------- | ------ | ------------------------------------------------------------- |
| description | string | Preview description displayed during social sharing.          |
| imageUrl    | string | Address of the preview image displayed during social sharing. |
| title       | string | Address of the preview title displayed during social sharing. |

###### Call Example

```dart
 SocialCardInfo socialCardInfo = SocialCardInfo(
        description: 'description short link',
        imageUrl: 'https://avatars2.githubusercontent.com/u/64997192?s=200&v=4',
        title: 'AGC Guides');
```

##### CampignInfo

- Represents the data structure of activity information in App Linking.

| Field  | Type   | Description      |
| ------ | ------ | ---------------- |
| medium | string | Activity medium. |
| name   | string | Activity name.   |
| source | string | Activity source. |

###### Call Example

```dart
    CampaignInfo campaignInfo =
    CampaignInfo(medium: 'JULY', name: 'summer campaign', source: 'Huawei');
```

##### AndroidLinkInfo

- Represents the data structure of Android app information in App Linking.

| Field              | Type                                                                                                    | Description                                                                                                                                                          |
| ------------------ | ------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| androidPackageName | string                                                                                                  | Constructor required when a link of App Linking needs to be opened in the app with the specified APK name. This constructor is reserved and not supported currently. |
| androidDeepLink    | string                                                                                                  | Deep link to an Android app.                                                                                                                                         |
| androidOpenType    | [AppLinkingAndroidLinkInfoAndroidOpenTypeConstants](#applinkingandroidlinkinfoandroidopentypeconstants) | Action triggered when the link of an Android app is tapped but the app is not installed.                                                                             |
| androidFallbackUrl | string                                                                                                  | Custom URL to be accessed when the app is not installed.                                                                                                             |

###### Call Example

```dart
    AndroidLinkInfo androidLinkInfo = new AndroidLinkInfo(
        androidFallbackUrl: 'https://consumer.huawei.com/en/',
        androidOpenType: AppLinkingAndroidLinkInfoAndroidOpenTypeConstants.CUSTOM_URL,
        androidPackageName:
        "<packageName>",
        androidDeepLink: 'https://developer.huawei.com/consumer/en/doc/overview/AppGallery-connect');
```

##### iosLinkInfo

- Represents the data structure of iOS app information in App Linking.

| Field           | Type   | Description                                            |
| --------------- | ------ | ------------------------------------------------------ |
| iosDeepLink     | string | Deep link to an iOS app.                               |
| iosFallbackUrl  | string | Deep link to an iOS app.                               |
| iosBundleId     | string | Bundle ID of an iOS app.                               |
| ipadFallbackUrl | string | URL to be accessed when the iPad app is not installed. |
| ipadBundleId    | string | Bundle ID of an iPad app.                              |

###### Call Example

```dart
    iOSLinkInfo iosLinkInfo = iOSLinkInfo(
        iosDeepLink: 'pages://flutteraplinking.com',
        iosBundleId: '<bundle id>');
```

##### iTunesLinkInfo

- Represents the data structure of App Linking iTunesConnect campaign info.

| Field                       | Type   | Description                       |
| --------------------------- | ------ | --------------------------------- |
| iTunesConnectProviderToken  | string | Provider token of iTunesConnect.  |
| iTunesConnectCampaignToken  | string | Campaign token of iTunesConnect.  |
| iTunesConnectAffiliateToken | string | Affiliate token of iTunesConnect. |
| iTunesConnectMediaType      | string | Media type of iTunesConnect.      |

###### Call Example

```dart
    iTunesLinkInfo tunesLinkInfo = iTunesLinkInfo(
        iTunesConnectAffiliateToken: "<affiliateToken>",
        iTunesConnectCampaignToken: "<campaignToken>",
        iTunesConnectProviderToken: "<providerToken>",
        iTunesConnectMediaType: "<mediatype>");
```

##### AppLinkingWithInfo

- Represents the data structure of App Linking information.

| Field                      | Type                                                                            | Description                                                                                                                                 |
| -------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| socialCardInfo             | [SocialCardInfo](#socialcardinfo)                                               | Represents the data structure of social sharing identifier information in App Linking.                                                      |
| campignInfo                | [CampignInfo](#campigninfo)                                                     | Represents the data structure of activity information in App Linking.                                                                       |
| androidLinkInfo            | [AndroidLinkInfo](#androidlinkinfo)                                             | Represents the data structure of Android app information in App Linking.                                                                    |
| iosLinkInfo                | [iosLinkInfo](#ioslinkinfo)                                                     | Represents the data structure of iOS app information in App Linking.                                                                        |
| itunesLinkInfo | [iTunesLinkInfo](#ituneslinkinfo)                       | iTunesConnect campaign parameters.                                                                                                          |
| expireMinute               | int                                                                          | Validity period of a short link, in minutes. By default, a short link is valid for two years, and the minimum validity period is 5 minutes. |
| previewType                | [AppLinkingLinkingPreviewTypeConstants](#applinkinglinkingpreviewtypeconstants) | Preview page style of a link of App Linking.                                                                                                |
| uriPrefix                  | string                                                                          | Domain name provided by AppGallery Connect for free.                                                                                        |
| deepLink                   | string                                                                          | Deep link is the URL of your app content.                                                                                                   |
| longLink                   | string                                                                          | Long link is the URL of your app content.                                                                                                   |
| shortAppLinkingLength      | [ShortAppLinkingLengthConstants](#shortapplinkinglengthconstants)               | Specifies whether the string-type suffix of a short link is long or short.                                                                  |

###### Call Example

```dart
    ApplinkingInfo appLinkingInfo = ApplinkingInfo(
        socialCardInfo: socialCardInfo,
        androidLinkInfo: androidLinkInfo,
        iosLinkInfo: iosLinkInfo,
        domainUriPrefix: '<uriprefix>',
        deepLink: 'https://developer.huawei.com',
        shortAppLinkingLength: ShortAppLinkingLengthConstants.LONG);
```

#### Constants

##### ShortAppLinkingLengthConstants

- Specifies whether the string-type suffix of a short link is long or short. This class is used to create a short link.

| Field | Type   | Description                                                                                  |
| ----- | ------ | -------------------------------------------------------------------------------------------- |
| SHORT | string | A short link uses a short string-type suffix containing four or more characters as required. |
| LONG  | string | A short link uses a long string-type suffix containing 17 characters.                        |

##### AppLinkingLinkingPreviewTypeConstants

- Preview page style of a link of App Linking.

| Field       | Type   | Description                                                                        |
| ----------- | ------ | ---------------------------------------------------------------------------------- |
| APP_INFO    | string | Displays the preview page with app information.                                    |
| SOCIAL_INFO | string | Displays the preview page with the card of a link displayed during social sharing. |

##### AppLinkingAndroidLinkInfoAndroidOpenTypeConstants

- Action triggered when a link is tapped but the target app is not installed.

| Field        | Type   | Description                                                |
| ------------ | ------ | ---------------------------------------------------------- |
| APP_GALLERY  | string | Displays the app details page on AppGallery.               |
| LOCAL_MARKET | string | Displays the app details page in local app market.         |
| CUSTOM_URL   | string | Displays the app details page using the fallbackUrl field. |

---

## 4. Configuration and Description

### Preparing for Release

Before building the APK, configure obfuscation scripts to prevent the AppGallery Connect SDK from being obfuscated. If obfuscation arises, the AppGallery Connect SDK may not function properly. For more information on this topic refer to [this Android developer guide](https://developer.android.com/studio/build/shrink-code).

**<flutter_project>/android/app/proguard-rules. pro**

```
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keep class com.hianalytics.android.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.hms.**{*;}
-keep class com.huawei.agc.**{*;}
-keep class com.huawei.agconnect.**{*;}

## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
-keep class com.huawei.agc.flutter.** { *; }
-repackageclasses
```

**<flutter_project>/android/app/build.gradle**

```gradle
buildTypes {
    debug {
        signingConfig signingConfigs.config
    }
    release {
        
        // Enables code shrinking, obfuscation and optimization for release builds
        minifyEnabled true
        // Unused resources will be removed, resources defined in the res/raw/keep.xml will be kept.
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
	
	signingConfig signingConfigs.config
    }
}
```

### Accessing Analytics Kit

To use analytics feature, 

- Navigate into your /android/app/build.gradle and add build dependencies in the dependencies section.
   
    ```
    dependencies {
        implementation 'com.huawei.hms:hianalytics:5.1.0.301'
    }
    ```
- Navigate into your /ios file and edit the Podfile file to add the pod dependency 'HiAnalytics'
    
    - Example Podfile file:

        ```
        # Pods for AGCAppLinkingDemo
        pod 'HiAnalytics'
        ```
    
    - Run pod install to install the pods.
    
       ```
       $ pod install
       ```
    
    - Initialize the Analytics SDK using the config API in AppDelegate in iOS platform.

        Sample code for initialization in AppDelegate:
    
  ```
	import UIKit
	import Flutter
    import HiAnalytics

	@UIApplicationMain
	@objc class AppDelegate: FlutterAppDelegate {
    	    override func application(
        	_ application: UIApplication,
        	didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    	    ) -> Bool {
          // Initialize the Analytics SDK.
          HiAnalytics.config();  

        	GeneratedPluginRegistrant.register(with: self)
        	return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    	}
    }
  ```
    
    For further information please refer to [Analytics Kit Service Guide](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/introduction-0000001050745149).

---

## 5. Sample Project

This plugin includes a demo project in the **example** folder, there you can find more usage examples.

---

## 6. Licensing and Terms

AppGallery Connect Applinking Kit Flutter Plugin is licensed under [Apache 2.0 license](LICENSE)