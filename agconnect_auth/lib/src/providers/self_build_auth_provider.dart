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

import '../../agconnect_auth.dart';

/// Provider of the credential from your own account system.
class SelfBuildAuthProvider {

  /// Creates a sign-in credential. By default, an account is automatically created.
  static AGCAuthCredential credentialWithToken(String token,
      {bool autoCreateUser = true}) {
    return SelfBuildCredential(
        token, autoCreateUser, AuthProviderType.selfBuild);
  }
}

class SelfBuildCredential extends AGCAuthCredential {
  bool autoCreateUser;
  String token;

  SelfBuildCredential(
      this.token, this.autoCreateUser, AuthProviderType provider)
      : super(provider);

  @override
  Map toMap() {
    return {
      'provider': provider.index,
      'autoCreateUser': autoCreateUser,
      'token': token
    };
  }
}
