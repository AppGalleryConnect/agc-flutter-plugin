/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

import 'package:agconnect_auth/agconnect_auth.dart';

/// Result returned upon successful sign-in.
class SignInResult {

  ///  Obtains information about the current user.
  AGCUser? user;

  SignInResult.fromMap(Map? map) {
    user = map != null ? AGCUser.fromMap(map) : null;
  }
}
