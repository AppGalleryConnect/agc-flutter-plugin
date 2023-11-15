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


import 'package:agconnect_auth/agconnect_auth.dart';
import 'package:agconnect_auth_example/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:huawei_account/huawei_account.dart';

class PageHuaweiAuth extends StatefulWidget {
  const PageHuaweiAuth({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageHuaweiAuthState();
  }
}

class _PageHuaweiAuthState extends State<PageHuaweiAuth> {
  String _log = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  _getCurrentUser() async {
    AGCAuth.instance.currentUser.then((value) {
      setState(() {
        _log = 'current user = ${value?.uid} , ${value?.providerId}';
      });
    });
  }

  _signIn() async {
    final helper = AccountAuthParamsHelper();
    helper
      ..setAccessToken()
      ..setEmail()
      ..setIdToken()
      ..setAuthorizationCode()
      ..setProfile();

    try {
      AuthAccount huaweiId = await AccountAuthService.signIn(helper);
      if (huaweiId.accessToken != null) {
        AGCAuthCredential credential =
            HuaweiAuthProvider.credentialWithToken(huaweiId.accessToken!);
        AGCAuth.instance.signIn(credential).then((value) {
          setState(() {
            _log =
                'signInHuaweiId = ${value.user?.uid} , ${value.user?.providerId}';
          });
        });
      } else {
        throw "AccessToken is null";
      }
    } on Exception catch (e) {
      debugPrint('error: $e');
    }
  }

  _signOut() async {
    try {
      await AGCAuth.instance.signOut();
      setState(() {
        _log = 'signOut';
      });
    } catch (error) {
      debugPrint('error: $error');
    }
  }

  _deleteUser() async {
    try {
      await AGCAuth.instance.deleteUser();
      setState(() {
        _log = 'deleteUser';
      });
    } catch (error) {
      debugPrint('error: $error');
    }
  }

  _link() async {
    AGCUser? user = await AGCAuth.instance.currentUser;
    if (user == null) {
      debugPrint("no user signed in");
      return;
    }

    final helper = AccountAuthParamsHelper();
    helper
      ..setAccessToken()
      ..setEmail()
      ..setIdToken()
      ..setAuthorizationCode()
      ..setProfile();

    try {
      AuthAccount huaweiId = await AccountAuthService.signIn(helper);
      if (huaweiId.accessToken != null) {
        AGCAuthCredential credential =
            HuaweiAuthProvider.credentialWithToken(huaweiId.accessToken!);
        AGCAuth.instance.signIn(credential).then((value) {
          setState(() {
            _log =
                'signInHuaweiId = ${value.user?.uid} , ${value.user?.providerId}';
          });
        });
        SignInResult signInResult = await user.link(credential);
        setState(() {
          _log = 'link HuaweiId = ${signInResult.user?.uid}';
        });
      } else {
        throw "AccessToken is null";
      }
    } on Exception catch (e) {
      debugPrint('error: $e');
    }
  }

  _unlink() async {
    AGCUser? user = await AGCAuth.instance.currentUser;
    if (user == null) {
      debugPrint("no user signed in");
      return;
    }
    try {
      SignInResult result = await user.unlink(AuthProviderType.hms);
      setState(() {
        _log = 'unlink HuaweiId = ${result.user?.uid}';
      });
    } catch (error) {
      debugPrint('error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HuaweiId Auth'),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                height: 90,
                child: Text(_log),
              ),
              const Divider(
                thickness: 0.1,
                color: Colors.black,
              ),
              Expanded(
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            CustomButton('getCurrentUser', _getCurrentUser),
                            CustomButton('signInHuawei', _signIn),
                            CustomButton('signOut', _signOut),
                            CustomButton('deleteUser', _deleteUser),
                            CustomButton('link', _link),
                            CustomButton('unlink', _unlink)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
