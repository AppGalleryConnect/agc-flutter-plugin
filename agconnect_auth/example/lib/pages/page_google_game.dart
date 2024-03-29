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
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../custom_button.dart';

class PageGoogleGameAuth extends StatefulWidget {
  const PageGoogleGameAuth({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageGoogleGameAuthState();
  }
}

class _PageGoogleGameAuthState extends State<PageGoogleGameAuth> {
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
    GoogleSignIn googleSignIn = GoogleSignIn(
      signInOption: SignInOption.games,
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    final GoogleSignInAccount googleUser = (await googleSignIn.signIn())!;
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    AGCAuthCredential credential = GoogleGameAuthProvider.credentialWithToken(
        googleAuth.serverAuthCode ?? "");
    AGCAuth.instance.signIn(credential).then((value) {
      setState(() {
        _log =
            'signInGoogleGame = ${value.user?.uid} , ${value.user?.providerId}';
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
    GoogleSignIn googleSignIn = GoogleSignIn(
      signInOption: SignInOption.games,
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    final GoogleSignInAccount googleUser = (await googleSignIn.signIn())!;
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    AGCAuthCredential credential =
        GoogleGameAuthProvider.credentialWithToken(googleAuth.idToken ?? "");
    try{
      SignInResult signInResult = await user.link(credential);
      setState(() {
        _log = 'link GoogleGame = ${signInResult.user?.uid}';
      });
    }
    catch (error){
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
      await user.unlink(AuthProviderType.googleGame);
      setState(() {
        _log = 'unlink googleGame = ${result.user?.uid}';
      });
    }
    catch (error){
      debugPrint('error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoogleGame Auth'),
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
                            CustomButton('signInGoogleGame', _signIn),
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
