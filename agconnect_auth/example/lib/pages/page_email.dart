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

class PageEmailAuth extends StatefulWidget {
  const PageEmailAuth({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageEmailAuthState();
  }
}

class _PageEmailAuthState extends State<PageEmailAuth> {
  String _log = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();

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

  _createEmailUser() async {
    bool? result = await _showEmailDialog(VerifyCodeAction.registerLogin);
    if (result == null) {
      debugPrint("cancel");
      return;
    }
    String email = _emailController.text;
    String verifyCode = _verifyCodeController.text;
    String password = _passwordController.text;
    AGCAuth.instance
        .createEmailUser(EmailUser(email, verifyCode, password))
        .then((value) {
      setState(() {
        _log =
            'createEmailUser = ${value.user?.uid} , ${value.user?.providerId}';
      });
    }).catchError((error) {
      debugPrint('error: $error');
    });
  }

  _signInWithPassword() async {
    bool? result = await _showEmailDialog(VerifyCodeAction.registerLogin);
    if (result == null) {
      debugPrint("cancel");
      return;
    }
    String email = _emailController.text;
    String password = _passwordController.text;
    AGCAuthCredential credential =
        EmailAuthProvider.credentialWithPassword(email, password);
    AGCAuth.instance.signIn(credential).then((value) {
      setState(() {
        _log =
            'signInWithPassword = ${value.user?.uid} , ${value.user?.providerId}';
      });
    });
  }

  _signInWithVerifyCode() async {
    bool? result = await _showEmailDialog(VerifyCodeAction.registerLogin);
    if (result == null) {
      debugPrint("cancel");
      return;
    }
    String email = _emailController.text;
    String verifyCode = _verifyCodeController.text;
    String password = _passwordController.text;
    AGCAuthCredential credential = EmailAuthProvider.credentialWithVerifyCode(
        email, verifyCode,
        password: password);
    AGCAuth.instance.signIn(credential).then((value) {
      setState(() {
        _log =
            'signInWithVerifyCode = ${value.user?.uid} , ${value.user?.providerId}';
      });
    });
  }

  _resetEmailPassword() async {
    bool? result = await _showEmailDialog(VerifyCodeAction.resetPassword);
    if (result == null) {
      debugPrint("cancel");
      return;
    }
    String email = _emailController.text;
    String verifyCode = _verifyCodeController.text;
    String password = _passwordController.text;
    AGCAuth.instance
        .resetPasswordWithEmail(email, password, verifyCode)
        .then((value) => debugPrint('resetEmailPassword'));
  }

  _signOut() {
    AGCAuth.instance.signOut().then((value) {
      setState(() {
        _log = 'signOut';
      });
    }).catchError((error) {
      debugPrint(error);
    });
  }

  _deleteUser() {
    AGCAuth.instance.deleteUser().then((value) {
      setState(() {
        _log = 'deleteUser';
      });
    }).catchError((error) {
      debugPrint(error);
    });
  }

  _link() async {
    AGCUser? user = await AGCAuth.instance.currentUser;
    if (user == null) {
      debugPrint("no user signed in");
      return;
    }
    bool? result = await _showEmailDialog(VerifyCodeAction.registerLogin);
    if (result == null) {
      debugPrint("cancel");
      return;
    }
    String email = _emailController.text;
    String verifyCode = _verifyCodeController.text;
    String password = _passwordController.text;
    AGCAuthCredential credential = EmailAuthProvider.credentialWithVerifyCode(
        email, verifyCode,
        password: password);
    try {
      SignInResult signInResult = await user.link(credential);
      setState(() {
        _log = 'link email = ${signInResult.user?.email}';
      });
    } catch (error) {
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
      SignInResult result = await user.unlink(AuthProviderType.email);
      setState(() {
        _log = 'unlink email = ${result.user?.uid}';
      });
    } catch (error) {
      debugPrint('error: $error');
    }
  }

  _updateEmail() async {
    AGCUser? user = await AGCAuth.instance.currentUser;
    if (user == null) {
      debugPrint("no user signed in");
      return;
    }
    bool? result = await _showEmailDialog(VerifyCodeAction.registerLogin);
    if (result == null) {
      debugPrint("cancel");
      return;
    }
    String email = _emailController.text;
    String verifyCode = _verifyCodeController.text;
    await user.updateEmail(email, verifyCode).catchError((error) {
      debugPrint('error: $error');
    });
    debugPrint('updateEmail');
  }

  _updatePassword() async {
    AGCUser? user = await AGCAuth.instance.currentUser;
    if (user == null) {
      debugPrint("no user signed in");
      return;
    }
    bool? result = await _showEmailDialog(VerifyCodeAction.resetPassword);
    if (result == null) {
      debugPrint("cancel");
      return;
    }
    String verifyCode = _verifyCodeController.text;
    String password = _passwordController.text;
    await user
        .updatePassword(password, verifyCode, AuthProviderType.email)
        .catchError((error) {
      debugPrint('error: $error');
    });
    debugPrint('updatePassword');
  }

  _isAutoCollectionId() async {
    var isAuto = await AGCAuth.instance.isAutoCollectionAAID();
    debugPrint('AutoCollectionID $isAuto');
  }

  _setAutoCollectionAAID() async {
    await AGCAuth.instance.setAutoCollectionAAID(false);
  }

  Future<bool?> _showEmailDialog(VerifyCodeAction action) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Input"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CupertinoTextField(
                controller: _emailController,
                placeholder: 'email',
              ),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'password',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CupertinoTextField(
                      controller: _verifyCodeController,
                      placeholder: 'verification code',
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 32,
                    child: TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        child: const Text('send'),
                        onPressed: () => _requestEmailVerifyCode(action)),
                  ),
                ],
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
    );
  }

  void _showDialog(BuildContext context, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: const Key("dialog"),
            title: const Text("Result"),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _requestEmailVerifyCode(VerifyCodeAction action) {
    String email = _emailController.text;
    VerifyCodeSettings settings = VerifyCodeSettings(action, sendInterval: 30);
    AGCAuth.instance
        .requestVerifyCodeWithEmail(email, settings)
        .then((value) => _showDialog(context, "Verification code sent"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Auth'),
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
                            CustomButton('createEmailUser', _createEmailUser),
                            CustomButton(
                                'signInWithPassword', _signInWithPassword),
                            CustomButton(
                                'signInWithVerifyCode', _signInWithVerifyCode),
                            CustomButton(
                                'resetEmailPassword', _resetEmailPassword),
                            CustomButton('signOut', _signOut),
                            CustomButton('deleteUser', _deleteUser),
                            CustomButton('link email', _link),
                            CustomButton('unlink email', _unlink),
                            CustomButton('updateEmail', _updateEmail),
                            CustomButton('updatePassword', _updatePassword),
                            CustomButton(
                                'isAutoCollectionAAID', _isAutoCollectionId),
                            CustomButton('setAutoCollectionAAID',
                                _setAutoCollectionAAID),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
