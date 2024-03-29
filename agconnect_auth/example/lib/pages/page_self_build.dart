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


import 'dart:async';

import 'package:agconnect_auth/agconnect_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom_button.dart';

class PageSelfBuildAuth extends StatefulWidget {
  const PageSelfBuildAuth({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageSelfBuildAuthState();
  }
}

class _PageSelfBuildAuthState extends State<PageSelfBuildAuth> {
  String _log = '';
  final TextEditingController _selfBuildController = TextEditingController();

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
    bool result = await _showSelfBuildDialog(VerifyCodeAction.registerLogin);
    if (result == false) {
      debugPrint("cancel");
      return;
    }
    String token = _selfBuildController.text;
    AGCAuthCredential credential =
        SelfBuildAuthProvider.credentialWithToken(token);
    AGCAuth.instance.signIn(credential).then((value) {
      setState(() {
        _log = 'signIn = ${value.user?.uid} , ${value.user?.providerId}';
      });
    });
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
    bool result = await _showSelfBuildDialog(VerifyCodeAction.registerLogin);
    if (result == false) {
      debugPrint("cancel");
      return;
    }
    String token = _selfBuildController.text;
    AGCAuthCredential credential =
        SelfBuildAuthProvider.credentialWithToken(token);
    try {
      SignInResult signInResult = await user.link(credential);
      setState(() {
        _log = 'link self build = ${signInResult.user?.uid}';
      });
    }
    catch (error) {
      debugPrint('error: $error');
    }
  }

  _unlink() async {
    AGCUser? user = await AGCAuth.instance.currentUser;
    if (user == null) {
      debugPrint("no user signed in");
      return;
    }
    try {
      SignInResult result =
      await user.unlink(AuthProviderType.selfBuild);
      setState(() {
        _log = 'unlink self build = ${result.user?.uid}';
      });
    }
    catch (error){
      debugPrint('error: $error');
    }
  }

  Future<dynamic> _showSelfBuildDialog(VerifyCodeAction action) async {
    return (await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Input"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CupertinoTextField(
                    controller: _selfBuildController,
                    placeholder: 'jwt',
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("CANCEL"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Build Auth'),
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
                            CustomButton('signIn', _signIn),
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
