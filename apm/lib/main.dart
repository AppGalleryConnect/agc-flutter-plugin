/*
 * Copyright 2020. Huawei Technologies Co., Ltd. All rights reserved.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

import 'dart:io';

import 'package:agconnect_apm/agconnect_apm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AGConnectAPM.getInstance().enableCollection();
  if (Platform.isAndroid) {
    await AGConnectAPM.getInstance().enableAnrMonitor();
  }
  runApp(_App());
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  @override
  __HomeScreenState createState() => __HomeScreenState();
}

class __HomeScreenState extends State<_HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGC APM Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          _buildGroup(
            title: 'Collection',
            children: <Widget>[
              _buildButton(
                text: 'Enable',
                onTap: () async {
                  await AGConnectAPM.getInstance().enableCollection(true);
                },
              ),
              _buildButton(
                text: 'Disable',
                onTap: () async {
                  await AGConnectAPM.getInstance().enableCollection(false);
                },
              ),
            ],
          ),
          _buildGroup(
            title: 'ANR Monitor',
            children: <Widget>[
              _buildButton(
                text: 'Enable',
                onTap: () async {
                  await AGConnectAPM.getInstance().enableAnrMonitor(true);
                },
              ),
              _buildButton(
                text: 'Disable',
                onTap: () async {
                  await AGConnectAPM.getInstance().enableAnrMonitor(false);
                },
              ),
            ],
          ),
          _buildGroup(
            title: 'Custom Trace',
            children: <Widget>[
              _buildButton(
                text: 'Create - Start - Process - Stop',
                onTap: () async {
                  final AGConnectAPMCustomTrace customTrace = await AGConnectAPM.getInstance().createCustomTrace('CustomTrace1');
                  await customTrace.start();
                  await customTrace.putMeasure('ProcessingTimes', 0);
                  await Future.forEach(
                    List.generate(50, (_) => _),
                    (int i) async {
                      await customTrace.incrementMeasure('ProcessingTimes', i);
                    },
                  );
                  await customTrace.putProperty('ProcessResult', 'Success');
                  await customTrace.putProperty('Status', 'Normal');
                  await customTrace.stop();
                  return await customTrace.getProperties();
                },
              ),
            ],
          ),
          _buildGroup(
            title: 'Network Measure',
            children: <Widget>[
              _buildButton(
                text: 'Create - Start - Process - Stop',
                onTap: () async {
                  final String url = 'https://www-file.huawei.com/-/media/corporate/images/home/logo/huawei_logo.png';
                  final AGConnectAPMNetworkMeasure networkMeasure = await AGConnectAPM.getInstance().createNetworkMeasure(
                    url: url,
                    method: AGConnectAPMNetworkMeasureMethods.GET,
                  );
                  await networkMeasure.start();
                  final http.Response response = await http.get(Uri.parse(url));

                  await networkMeasure.setStatusCode(response.statusCode);
                  if (response.request?.contentLength != null) {
                    await networkMeasure.setBytesSend(response.request!.contentLength!);
                  }
                  if (response.contentLength != null) {
                    await networkMeasure.setBytesReceived(response.contentLength!);
                    await networkMeasure.putProperty("BytesReceived", response.contentLength!.toString());
                  }
                  await networkMeasure.stop();
                  return await networkMeasure.getProperties();
                },
              ),
            ],
          ),
          _buildGroup(
            title: 'User Identifier',
            children: <Widget>[
              _buildButton(
                text: 'Set',
                onTap: () async {
                  await AGConnectAPM.getInstance().setUserIdentifier('UserIdentifier1');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFDDDDDD),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Future<dynamic> Function() onTap,
  }) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () async {
        try {
          final dynamic result = await onTap();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('SUCCESS'),
                content: result != null
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(result.toString()),
                      )
                    : null,
              );
            },
          );
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('ERROR'),
                content: Text(
                  e is AssertionError ? e.message.toString() : AGConnectAPMException.from(e).message,
                ),
              );
            },
          );
        }
      },
    );
  }
}
