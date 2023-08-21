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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agconnect_core/agconnect_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _log = '';
  late AGConnectOptions agConnectOptions;
  final optionsBuilder = AGConnectOptionsBuilder()
    ..productId = "productId"
    ..appId = "appId"
    ..cpId = "cpId"
    ..clientId = "clientId"
    ..clientSecret = "clientSecret"
    ..apiKey = "apiKey"
    ..routePolicy = AGCRoutePolicy.UNKNOWN
    ..packageName = "packageName";

  _buildInstance() async {
    agConnectOptions = AGConnectOptions(optionsBuilder);
    AGConnectInstance.instance
        .buildInstance(agConnectOptions)
        .then((value) {
    }).catchError((error) => print(error));
  }

  _getPackageName() async{
    AGConnectOptions(optionsBuilder)
        .getPackageName()
        .then((value) {
      setState(() {
        _log = 'getPackageName = ${value}';
        print(_log);
      });
    }).catchError((error) => print(error));

  }

  _getRoutePolicy() async{
    AGConnectOptions(optionsBuilder)
        .getRoutePolicy()
        .then((value) {
      setState(() {
        _log = 'getRoutePolicy = ${value}';
        print(_log);
      });
    }).catchError((error) => print(error));

  }

  _getString() async{
    AGConnectOptions(optionsBuilder)
        .getString("/client/app_id", "defValue")
        .then((value) {
      setState(() {
        _log = 'getString = ${value}';
        print(_log);
      });
    }).catchError((error) => print(error));

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Builder(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Agconnect Core Demo'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: <Widget>[
              ElevatedButton(child: Text('buildInstance'), onPressed: (){
                _buildInstance();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('buildInstance function called successfully check logs!'),
                  duration: Duration(seconds: 3),
                ));
              }),
              ElevatedButton(child: Text('getPackageName'), onPressed:(){
                _getPackageName();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('getPackageName called successfully check logs!'),
                  duration: Duration(seconds: 3),
                ));
              } ),
              ElevatedButton(child: Text('getRoutePolicy'), onPressed:(){
                _getRoutePolicy();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('getRoutePolicy called successfully check logs!'),
                  duration: Duration(seconds: 3),
                ));
              }),
              ElevatedButton(child: Text('getString'), onPressed:(){
                _getString();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('getString called successfully check logs!'),
                  duration: Duration(seconds: 3),
                ));
              }),
            ]),
          ),
        ),
      );
      }),

    );
  }
}
