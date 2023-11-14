/*
 * Copyright 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

import 'package:flutter/material.dart';

import 'package:agconnect_appmessaging/agconnect_appmessaging.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AGCAppMessaging _appMessaging = AGCAppMessaging.getInstance();

  @override
  void initState() {
    super.initState();

    _appMessaging.onMessageDisplay.listen((AppMessage event) {
      _showDialog(context, 'onMessageDisplay', event);
    });
    _appMessaging.onMessageDismiss.listen((AppMessage event) {
      _showDialog(context, 'onMessageDismiss', event);
    });
    _appMessaging.onMessageClick.listen((AppMessage event) {
      _showDialog(context, 'onMessageClick', event);
    });
    _appMessaging.onMessageError.listen((AppMessage event) {
      _showDialog(context, 'onMessageError', event);
    });

    // Uncomment this for use custom view.
    // _appMessaging.onCustomEvent.listen((AppMessage? event) async {
    //   _showDialog(context, 'onCustomEvent', event);

    //   await _appMessaging.handleCustomViewMessageEvent(
    //     AGCAppMessagingEventType.onMessageDismiss,
    //     AGCAppMessagingDismissType.CLICK,
    //   );
    // });
  }

  void _showDialog(BuildContext context, String title, [dynamic content]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content == null
              ? null
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text('$content'),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AGC AppMessaging Demo"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          _buildGroup(
            children: <Widget>[
              _buildButton(
                text: 'isDisplayEnable',
                onTap: () async => await _appMessaging.isDisplayEnable(),
              ),
              const Divider(height: 0),
              _buildButton(
                text: 'Enable Display',
                onTap: () async => await _appMessaging.setDisplayEnable(true),
              ),
              _buildButton(
                text: 'Disable Display',
                onTap: () async => await _appMessaging.setDisplayEnable(false),
              ),
            ],
          ),
          _buildGroup(
            children: <Widget>[
              _buildButton(
                text: 'isFetchMessageEnable',
                onTap: () async => await _appMessaging.isFetchMessageEnable(),
              ),
              const Divider(height: 0),
              _buildButton(
                text: 'Enable Fetch Message',
                onTap: () async =>
                    await _appMessaging.setFetchMessageEnable(true),
              ),
              _buildButton(
                text: 'Disable Fetch Message',
                onTap: () async =>
                    await _appMessaging.setFetchMessageEnable(false),
              ),
            ],
          ),
          _buildGroup(
            children: <Widget>[
              _buildButton(
                text: 'setForceFetch',
                onTap: () async => await _appMessaging.setForceFetch(),
              ),
              const Divider(height: 0),
              _buildButton(
                text: 'setDisplayLocation\nCENTER',
                onTap: () async => await _appMessaging
                    .setDisplayLocation(AGCAppMessagingDisplayLocation.CENTER),
              ),
              const Divider(height: 0),
              _buildButton(
                text: 'removeCustomView',
                onTap: () async => await _appMessaging.removeCustomView(),
              ),
              const Divider(height: 0),
              _buildButton(
                text: 'trigger\n#AppOnForeground',
                onTap: () async =>
                    await _appMessaging.trigger('#AppOnForeground'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroup({
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Future<dynamic> Function() onTap,
  }) {
    return ElevatedButton(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
      onPressed: () async {
        try {
          final dynamic result = await onTap();
          _showDialog(context, 'SUCCESS', result);
        } catch (e) {
          _showDialog(context, 'ERROR', e.toString());
        }
      },
    );
  }
}
