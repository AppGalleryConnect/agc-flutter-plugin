/*
 * Copyright 2020. Huawei Technologies Co., Ltd. All rights reserved.
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

#import "AGConnectRemoteConfigPlugin.h"
#import <AGConnectRemoteConfig/AGConnectRemoteConfig.h>

@implementation AGConnectRemoteConfigPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.huawei.flutter/agconnect_remote_config"
            binaryMessenger:[registrar messenger]];
  AGConnectRemoteConfigPlugin* instance = [[AGConnectRemoteConfigPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
}

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    @try {
        [AGCInstance startUp];
    } @catch (NSException *exception) {
        NSLog(@"Exception: AGConnectRemoteConfigPlugin init failed, exception name: %@, exception reason: %@", exception.name, exception.reason);
        @throw exception;
    } @finally {

    }
    return YES;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"applyDefaults" isEqualToString:call.method]) {
      NSDictionary<NSString *, id> *defaults =  call.arguments[@"defaults"];
      [[AGCRemoteConfig sharedInstance] applyDefaults:defaults];
      result(nil);
  } else if ([@"setCustomAttributes" isEqualToString:call.method]) {
      NSDictionary<NSString *, id> *customAttributes =  call.arguments[@"customAttributes"];
      [[AGCRemoteConfig sharedInstance] setCustomAttributes:customAttributes];
       result(nil);
  } else if ([@"getCustomAttributes" isEqualToString:call.method]) {
      NSDictionary *value = [[AGCRemoteConfig sharedInstance] getCustomAttributes];
      result(value);
  } else if ([@"applyLastFetched" isEqualToString:call.method]) {
      AGCConfigValues *values = [AGCRemoteConfig sharedInstance].loadLastFetched;
      [[AGCRemoteConfig sharedInstance] apply:values];
      result(nil);
  } else if ([@"fetch" isEqualToString:call.method]) {
      NSNumber *intervalSeconds = call.arguments[@"intervalSeconds"];
      HMFTask<AGCConfigValues *> *task = nil;
      if ([intervalSeconds isKindOfClass:NSNumber.class]) {
          NSTimeInterval interval = intervalSeconds.doubleValue;
          task = [[AGCRemoteConfig sharedInstance] fetch:interval];
      } else {
          task = [[AGCRemoteConfig sharedInstance] fetch];
      }
      [[task addOnSuccessCallback:^(AGCConfigValues * _Nullable values) {
          result(nil);
      }] addOnFailureCallback:^(NSError * _Nonnull error) {
          result([self generateFlutterError:error]);
      }];
  } else if ([@"getValue" isEqualToString:call.method]) {
      NSString *key = call.arguments[@"key"];
      NSString *value = [[AGCRemoteConfig sharedInstance] valueAsString:key];
      result(value);
  } else if ([@"getSource" isEqualToString:call.method]) {
      NSString *key = call.arguments[@"key"];
      NSInteger value = [[AGCRemoteConfig sharedInstance] getSource:key];
      result(@(value));
  } else if ([@"getMergedAll" isEqualToString:call.method]) {
     NSDictionary *value = [[AGCRemoteConfig sharedInstance] getMergedAll];
     result(value);
  } else if ([@"clearAll" isEqualToString:call.method]) {
      [[AGCRemoteConfig sharedInstance] clearAll];
      result(nil);
  } else if ([@"setDeveloperMode" isEqualToString:call.method]) {
      result(nil);
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (FlutterError *)generateFlutterError:(NSError *)error {
    if ([error isKindOfClass:AGCRemoteConfigError.class]) {
             AGCRemoteConfigError *configError = (AGCRemoteConfigError *)error;
             NSInteger timeMillis = (NSInteger)(configError.throttleEndTime * 1000);
             return [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)configError.code]
                                        message:configError.localizedDescription
                                        details:@{@"throttleEndTime":@(timeMillis)}];
         }else{
             return [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                        message:error.localizedDescription
                                        details:nil];
         }
}

@end
