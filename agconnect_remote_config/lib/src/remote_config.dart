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

import 'dart:io';

import 'package:agconnect_remote_config/src/remote_config_exception.dart';
import 'package:flutter/services.dart';


///Source of the value obtained from the remote configuration.
enum RemoteConfigSource {
  /// The obtained value is the initial value of the type.
  initial,

  /// The obtained value is the local default value.
  local,

  /// The obtained value is a cloud value.
  remote,
}

/// AGConnect RemoteConfig SDK entry class
class AGCRemoteConfig {
  static const MethodChannel _channel =
  const MethodChannel('com.huawei.flutter/agconnect_remote_config');

  /// Obtain AGCRemoteConfig instance
  static final AGCRemoteConfig instance = AGCRemoteConfig();

  /// Setting Local Default Parameters
  Future<void> applyDefaults(Map<String, dynamic>? defaults) {
    Map<String, String> map = Map();
    defaults?.forEach((String key, dynamic value) {
      map[key] = value.toString();
    });
    return _channel
        .invokeMethod('applyDefaults', <String, dynamic>{'defaults': map});
  }

  /// Return to Obtain Custom Attributes
  Future<Map?> getCustomAttributes() {
    return _channel.invokeMethod('getCustomAttributes');
  }

  /// Setting Custom Attribute Parameters
  Future<void> setCustomAttributes(Map<String, dynamic>? customAttributes) {
    Map<String, String> map = Map();
    customAttributes?.forEach((String key, dynamic value) {
      map[key] = value.toString();
    });
    return _channel
        .invokeMethod(
        'setCustomAttributes', <String, dynamic>{'customAttributes': map});
  }

  /// Make the configuration data obtained from the cloud last time take effect.
  Future<void> applyLastFetched() {
    return _channel.invokeMethod('applyLastFetched');
  }

  /// Obtain the latest configuration data from the cloud. The default interval is 12 hours. The cached data is returned within 12 hours.
  Future<void> fetch({int? intervalSeconds}) async {
    try {
      await _channel.invokeMethod('fetch',
          <String, int?>{'intervalSeconds': intervalSeconds});
    }
    on PlatformException catch (e) {
      int? code = int.tryParse(e.code);
      int? throttleEndTime =
      e.details != null ? e.details['throttleEndTime'] : null;
      throw RemoteConfigException(
          code: code,
          message: e.message,
          throttleEndTimeMillis: throttleEndTime);
    }
    on MissingPluginException catch(e){
      throw RemoteConfigException(
          code: 0x0c2a0001,
          message: e.message,
          throttleEndTimeMillis: 0);
    }
  }


  /// Returns the value of the String type corresponding to the key.
  Future<String?> getValue(String key) {
    return _channel.invokeMethod('getValue', <String, String>{'key': key});
  }

  /// Return the source of the key.
  Future<RemoteConfigSource?> getSource(String key) async {
    dynamic value = await _channel
        .invokeMethod('getSource', <String, String>{'key': key});
    switch (value) {
      case 0:
        return RemoteConfigSource.initial;
      case 1:
        return RemoteConfigSource.local;
      case 2:
        return RemoteConfigSource.remote;
      default:
        return null;
    }
  }

  /// Returns all values after the combination of default values and cloud values.
  Future<Map?> getMergedAll() {
    return _channel.invokeMethod('getMergedAll');
  }

  /// Clears all cached data, including data pulled from the cloud and default values.
  Future<void> clearAll() {
    return _channel.invokeMethod('clearAll');
  }

  /// If the developer mode is set, the number of times that the client can obtain data is not limited, and the cloud test system still performs flow control.(Android only)
  Future<void> setDeveloperMode(bool isDeveloperMode) {
    if (Platform.isIOS) {
      print(
          'The setDeveloperMode method only supports Android, please refer to the development guide to set the developer mode on iOS.');
    }
    return _channel.invokeMethod(
        'setDeveloperMode', <String, bool>{'mode': isDeveloperMode});
  }
}
