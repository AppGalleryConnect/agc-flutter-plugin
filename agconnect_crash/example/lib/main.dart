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

import 'package:flutter/material.dart';
import 'package:agconnect_crash/agconnect_crash.dart';

void main() {
  FlutterError.onError = AGCCrash.instance.onFlutterError;
  runZonedGuarded<Future<void>>(
    () async {
      runApp(MyApp());
    },
    (dynamic error, StackTrace stackTrace) {
      AGCCrash.instance.recordError(error, stackTrace);
    },
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _enableCollection() async {
    await AGCCrash.instance.enableCrashCollection(true);
  }

  _disableCollection() async {
    await AGCCrash.instance.enableCrashCollection(false);
  }

  _testCrash() async {
    try {
      throw Exception('test exception');
    } catch (e, stack) {
      AGCCrash.instance.recordError(e, stack);
    }
  }

  _testFatalCrash() async {
    try {
      AGCCrash.instance.testIt();
    } catch (e, stack) {
      AGCCrash.instance.recordError(e, stack, fatal: true);
    }
  }

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
    minimumSize: Size(180, 40),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AGC Crash Demo'),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: elevatedButtonStyle,
                key: Key('Enable'),
                onPressed: () {
                  _enableCollection();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.orangeAccent,
                    content: Text('Enabled Crash Collection'),
                    duration: Duration(seconds: 3),
                  ));
                },
                child: const Text('Enable Crash Collection'),
              ),
              ElevatedButton(
                style: elevatedButtonStyle,
                onPressed: () {
                  _disableCollection();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.orangeAccent,
                    content: Text('Disabled Crash Collection'),
                    duration: Duration(seconds: 3),
                  ));
                },
                child: const Text('Disable Crash Collection'),
              ),
              ElevatedButton(
                style: elevatedButtonStyle,
                onPressed: () {
                  _testCrash();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.orangeAccent,
                    content: Text('Test crash successful, check logs 💥'),
                    duration: Duration(seconds: 3),
                  ));
                },
                child: const Text('Test Crash'),
              ),
              ElevatedButton(
                style: elevatedButtonStyle,
                onPressed: () {
                  _testFatalCrash();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.orangeAccent,
                    content: Text('Fatal crash successful, check logs 💥'),
                    duration: Duration(seconds: 3),
                  ));
                },
                child: const Text('Test fatal Crash'),
              ),
            ],
          )),
        );
      }),
    );
  }
}
