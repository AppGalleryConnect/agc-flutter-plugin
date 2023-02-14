/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2021. All rights reserved.
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
  final String _defaultFunctionText = 'testfunc-\$latest';
  final String _defaultResultText = 'Change the function name as you wish and click \'Call Function\' button to get response.';

  late TextEditingController _functionTextController;
  late TextEditingController _resultTextController;

  @override
  void initState() {
    super.initState();
    _functionTextController = TextEditingController(text: _defaultFunctionText);
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
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                      final FunctionCallable functionCallable = FunctionCallable(_functionTextController.text);
                      final FunctionResult functionResult = await functionCallable.call(
                        const <String, dynamic>{
                          'number1': 10,
                          'number2': 15,
                        },
                      );
                      setState(() => _resultTextController.text = functionResult.getValue());
                    } on PlatformException catch (e) {
                      setState(() => _resultTextController.text = FunctionError.fromException(e).toJson());
                    }
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Text('Reset'),
                  onPressed: () {
                    setState(() {
                      _functionTextController.text = _defaultFunctionText;
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
