/*
 * Copyright 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_remote_config/agconnect_remote_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('fetch missing plugin exception test', () {
    const MethodChannel channel =
        MethodChannel('com.huawei.flutter/agconnect_remote_config');
    Future<Object?> handler(MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'fetch':
          return throw MissingPluginException('Test exception');
        default:
          return null;
      }
    }

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, handler);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('missing plugin exception', () async {
      expect(() async => await AGCRemoteConfig.instance.fetch(),
          throwsA(isA<RemoteConfigException>()));
    });
  });
}
