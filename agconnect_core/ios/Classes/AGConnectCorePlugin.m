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
#import "AGConnectCorePlugin.h"

@implementation AGConnectCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.huawei.flutter/agconnect_core"
            binaryMessenger:[registrar messenger]];
  AGConnectCorePlugin* instance = [[AGConnectCorePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"buildInstance" isEqualToString:call.method]) {
    result(nil);
  }else if ([@"getRoutePolicy" isEqualToString:call.method]) {
    result(nil);
  }else if ([@"getPackageName" isEqualToString:call.method]) {
    result(nil);
  }else if ([@"getString" isEqualToString:call.method]) {
       result(nil);
  }else {
    result(FlutterMethodNotImplemented);
  }
}

@end
