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

library agconnect_clouddb;

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'src/constants/key_constants.dart';
part 'src/constants/method_constants.dart';
part 'src/constants/query_constants.dart';
part 'src/constants/transaction_constants.dart';
part 'src/enums/zone_access_property.dart';
part 'src/enums/zone_query_policy.dart';
part 'src/enums/zone_sync_property.dart';
part 'src/exceptions/exception.dart';
part 'src/models/zone_config.dart';
part 'src/models/zone_snapshot.dart';
part 'src/agconnect_clouddb.dart';
part 'src/agconnect_clouddbzone.dart';
part 'src/query.dart';
part 'src/transaction.dart';
part 'src/models/agc_server_status.dart';

const MethodChannel _methodChannel = MethodChannel(
  'com.huawei.agconnectclouddb/methodChannel/',
);
const EventChannel _onDataEncryptionKeyChangeEventChannel = EventChannel(
  'com.huawei.agconnectclouddb/eventChannel/onDataEncryptionKeyChange',
);
const EventChannel _onEventEventChannel = EventChannel(
  'com.huawei.agconnectclouddb/eventChannel/onEvent',
);
