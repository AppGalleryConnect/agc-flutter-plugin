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

enum TokenState { signedIn, tokenUpdated, tokenInvalid, signedOut }

/// Snapshot of Token
class TokenSnapshot {
  TokenState? _state;
  String? _token;

  TokenSnapshot(this._state, this._token);

  TokenSnapshot.fromMap(Map map) {
    _token = map['token'];
    int stateNum = map['state'];
    _state = TokenState.values[stateNum];
  }

  /// Obtains state of token
  TokenState? get state {
    return _state;
  }

  /// Obtains token
  String? get token {
    return _token;
  }
}
