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

#import "AGConnectCrashPlugin.h"
#import <AGConnectCore/AGConnectCore.h>
#import <AGConnectCrash/AGConnectCrash.h>
#import <HiAnalytics/HiAnalytics.h>

@implementation AGConnectCrashPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.huawei.flutter/agconnect_crash"
            binaryMessenger:[registrar messenger]];
  AGConnectCrashPlugin* instance = [[AGConnectCrashPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    @try {
        [AGCInstance startUp];
        [HiAnalytics config];
    } @catch (NSException *exception) {
        NSLog(@"Exception: AGConnectCrashPlugin init failed, exception name: %@, exception reason: %@", exception.name, exception.reason);
        @throw exception;
    } @finally {

    }
    return YES;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"testIt" isEqualToString:call.method]) {
    [[AGCCrash sharedInstance] testIt];
    result(nil);
  }else if ([@"enableCrashCollection" isEqualToString:call.method]) {
      BOOL enable = [call.arguments[@"enable"] boolValue];
    [[AGCCrash sharedInstance] enableCrashCollection:enable];
    result(nil);
  }else if ([@"setUserId" isEqualToString:call.method]) {
      NSString *userId = call.arguments[@"userId"];
    [[AGCCrash sharedInstance] setUserId:userId];
    result(nil);
  }else if ([@"setCustomKey" isEqualToString:call.method]) {
      NSString *key = call.arguments[@"key"];
      NSString *value = call.arguments[@"value"];
    [[AGCCrash sharedInstance] setCustomValue:value forKey:key];
    result(nil);
  }else if ([@"customLog" isEqualToString:call.method]) {
      NSInteger level = [call.arguments[@"level"] integerValue];
      NSInteger iosLevel = [self convertToIosLevel:level];
      NSString *message = call.arguments[@"message"];
    [[AGCCrash sharedInstance] logWithLevel:iosLevel message:message];
    result(nil);
  }else if ([@"recordError" isEqualToString:call.method]) {
      BOOL fatal = [call.arguments[@"fatal"] boolValue];
      NSString *reason = call.arguments[@"reason"];
      NSString *stack = call.arguments[@"stack"];
      AGCExceptionModel *exception = [[AGCExceptionModel alloc] initWithName:reason reason:reason stackTrace:stack];
      [exception setValue:@"Flutter" forKey:@"type"];
      exception.isFatal = fatal;
        if (fatal) {
           [[AGCCrash sharedInstance] recordFatalExceptionModel:exception];
        } else {
           [[AGCCrash sharedInstance] recordExceptionModel:exception];
        }

     result(nil);

  }else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSInteger)convertToIosLevel:(NSInteger)level {
    return level + 2;
}


@end

