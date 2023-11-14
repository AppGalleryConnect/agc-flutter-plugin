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

/// Obtains the verification code request result.
class VerifyCodeResult {
  String? _shortestInterval;
  String? _validityPeriod;

   VerifyCodeResult(this._shortestInterval, this._validityPeriod);

   VerifyCodeResult.fromMap(Map map) {
    _shortestInterval = map['shortestInterval'];
    _validityPeriod = map['validityPeriod'];
  }

  /// Obtains the minimum interval for sending a verification code.
  String? get shortestInterval {
    return _shortestInterval;
  }

  /// Obtains the validity period of a verification code.
  String? get validityPeriod {
    return _validityPeriod;
  }
}
