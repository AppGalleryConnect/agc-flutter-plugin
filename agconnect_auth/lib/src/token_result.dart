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

/// Access token of a user after successful sign-in.
class TokenResult {
  String? _token;
  int? _expirePeriod;

  TokenResult(this._token, this._expirePeriod);

  TokenResult.fromMap(Map map) {
    _token = map['token'];
    _expirePeriod = map['expirePeriod'];
  }

  /// Obtains the validity period of an access token.
  int? get expirePeriod {
    return _expirePeriod;
  }

  /// Obtains the access token of a user.
  String? get token {
    return _token;
  }
}
