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

import 'dart:ui';

/// Type of verify code request
enum VerifyCodeAction {
  registerLogin,
  resetPassword,
}
/// Set verify code settings
class VerifyCodeSettings {

  /// Sets the verification code type.
  VerifyCodeAction action;

  /// Sets the language in which the verification code message is sent.
  Locale? locale;

  /// Sets the interval for sending verification codes.
  int sendInterval;

  VerifyCodeSettings(this.action, {this.sendInterval = 0, this.locale});

  Map toMap() {
    return {
      'action': action.index,
      'localeLanguage': locale?.languageCode,
      'localeCountry': locale?.countryCode,
      'sendInterval': sendInterval
    };
  }
}
