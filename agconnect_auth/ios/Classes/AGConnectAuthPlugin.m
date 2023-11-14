/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */
#import "AGConnectAuthPlugin.h"
#if __has_include(<agconnect_auth/agconnect_auth-Swift.h>)
#import <agconnect_auth/agconnect_auth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "agconnect_auth-Swift.h"
#endif

@implementation AGConnectAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [AGConnectAuthPluginHandler registerWithRegistrar:registrar];
}
@end
