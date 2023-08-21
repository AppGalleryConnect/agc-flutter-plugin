/*
 * Copyright (c) 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
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

import 'package:agconnect_cloudfunctions/agconnect_cloudfunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// HTTP trigger identifier of the Cloud Function which is in Function name-Version number format
// See https://developer.huawei.com/consumer/en/doc/development/AppGallery-connect-Guides/android-call-function-0000001071314156#section11652152615214 for more information.
  final String _defaultFunctionIdentifier =
      'testfunc-\$latest'; // Your trigger handle
  final String _defaultResultText =
      'Change the function name as you wish and click \'Call Function\' button to get response.';

  late TextEditingController _functionTextController;
  late TextEditingController _resultTextController;

  @override
  void initState() {
    super.initState();
    _functionTextController =
        TextEditingController(text: _defaultFunctionIdentifier);
    _resultTextController = TextEditingController(text: _defaultResultText);
  }

  @override
  void dispose() {
    _functionTextController.dispose();
    _resultTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AGC Cloud Functions Example'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: <Widget>[
            TextField(
              controller: _functionTextController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text('Call Function'),
                  onPressed: () async {
                    try {
                      final FunctionCallable functionCallable =
                          FunctionCallable(_functionTextController.text);
                      final FunctionResult functionResult =
                          await functionCallable.call(
                        const <String, dynamic>{
                          'number1': 10,
                          'number2': 15,
                        },
                      );
                      setState(() => _resultTextController.text =
                          functionResult.getValue());
                    } on PlatformException catch (e) {
                      setState(() => _resultTextController.text =
                          FunctionError.fromException(e).toJson());
                    }
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Text('Reset'),
                  onPressed: () {
                    setState(() {
                      _functionTextController.text = _defaultFunctionIdentifier;
                      _resultTextController.text = _defaultResultText;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _resultTextController,
              maxLines: null,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
