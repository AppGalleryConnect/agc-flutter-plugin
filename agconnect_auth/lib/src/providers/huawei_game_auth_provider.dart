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

/// Provider of a HUAWEI Game Auth credential.
class HuaweiGameAuthProvider {

  /// Creates a sign-in credential. By default, an account is automatically created.
  static AGCAuthCredential credentialWithToken(
      String playerSign,
      String imageUrl,
      int playerLevel,
      String playerId,
      String displayName,
      String signTs,
      {bool autoCreateUser = true}) {
    return HuaweiGameAuthCredential(
        autoCreateUser,
        playerSign,
        imageUrl,
        playerLevel,
        playerId,
        displayName,
        signTs,
        AuthProviderType.huaweiGame);
  }
}

class HuaweiGameAuthCredential extends AGCAuthCredential {
  bool autoCreateUser;
  String playerSign;
  String imageUrl;
  int playerLevel;
  String playerId;
  String displayName;
  String signTs;

  HuaweiGameAuthCredential(
      this.autoCreateUser,
      this.playerSign,
      this.imageUrl,
      this.playerLevel,
      this.playerId,
      this.displayName,
      this.signTs,
      AuthProviderType provider)
      : super(provider);

  @override
  Map toMap() {
    return {
      'autoCreateUser': autoCreateUser,
      'provider': provider.index,
      'playerSign': playerSign,
      'imageUrl': imageUrl,
      'playerLevel': playerLevel,
      'playerId': playerId,
      'displayName': displayName,
      'signTs': signTs
    };
  }
}
