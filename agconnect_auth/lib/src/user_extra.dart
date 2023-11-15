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

/// Extra information about a user.
class AGCUserExtra {
  String? _createTime;
  String? _lastSignInTime;

  AGCUserExtra(this._createTime, this._lastSignInTime);

  AGCUserExtra.fromMap(Map map) {
    _createTime = map['createTime'];
    _lastSignInTime = map['lastSignInTime'];
  }

  /// Obtains the time when a user is created.
  String? get createTime {
    return _createTime;
  }

  /// Obtains the time of a user's last sign-in.
  String? get lastSignInTime {
    return _lastSignInTime;
  }
}
