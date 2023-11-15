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

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:agconnect_cloudstorage/agconnect_cloudstorage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final AGCStorage _storage = AGCStorage.getInstance();
  bool _isBusy = false;
  double? _progressValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AGC Cloud Storage Demo"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              _buildGroup(
                children: <Widget>[
                  const Text('Storage'),
                  _buildButton(
                    text: 'getArea',
                    onTap: () async => await _storage.getArea(),
                  ),
                  const Divider(height: 0),
                  TextField(
                    controller: _controller1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Enter a positive number here',
                    ),
                  ),
                  const Divider(height: 0),
                  const Text('RetryTimes'),
                  _buildButton(
                    text: 'getRetry',
                    onTap: () async => await _storage.getRetryTimes(),
                  ),
                  _buildButton(
                    text: 'setRetry',
                    onTap: () async => await _storage
                        .setRetryTimes(int.parse(_controller1.text)),
                  ),
                  const Divider(height: 0),
                  const Text('MaxRequestTimeout'),
                  _buildButton(
                    text: 'getMaxRequest',
                    onTap: () async => await _storage.getMaxRequestTimeout(),
                  ),
                  _buildButton(
                    text: 'setMaxRequest',
                    onTap: () async => await _storage
                        .setMaxRequestTimeout(int.parse(_controller1.text)),
                  ),
                  const Divider(height: 0),
                  const Text('MaxUploadTimeout'),
                  _buildButton(
                    text: 'getMaxUpload',
                    onTap: () async => await _storage.getMaxUploadTimeout(),
                  ),
                  _buildButton(
                    text: 'setMaxUpload',
                    onTap: () async => await _storage
                        .setMaxUploadTimeout(int.parse(_controller1.text)),
                  ),
                  const Divider(height: 0),
                  const Text('MaxDownloadTimeout'),
                  _buildButton(
                    text: 'getMaxDownload',
                    onTap: () async => await _storage.getMaxDownloadTimeout(),
                  ),
                  _buildButton(
                    text: 'setDownload',
                    onTap: () async => await _storage
                        .setMaxDownloadTimeout(int.parse(_controller1.text)),
                  ),
                ],
              ),
              _buildGroup(
                children: <Widget>[
                  TextField(
                    controller: _controller2,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Enter object path here',
                    ),
                  ),
                  const Divider(height: 0),
                  const Text('List'),
                  _buildButton(
                    text: 'max:2',
                    onTap: () async =>
                        await _storage.reference(_controller2.text).list(2),
                  ),
                  _buildButton(
                    text: 'all',
                    onTap: () async =>
                        await _storage.reference(_controller2.text).listAll(),
                  ),
                  const Divider(height: 0),
                  const Text('Metadata'),
                  _buildButton(
                    text: 'getMeta',
                    onTap: () async => await _storage
                        .reference(_controller2.text)
                        .getMetadata(),
                  ),
                  _buildButton(
                    text: 'updateMeta',
                    onTap: () async => await _storage
                        .reference(_controller2.text)
                        .updateMetadata(
                          AGCStorageSettableMetadata(
                            customMetadata: <String, String>{
                              'randomValue':
                                  Random.secure().nextInt(1000).toString(),
                            },
                          ),
                        ),
                  ),
                  const Divider(height: 0),
                  _buildButton(
                    text: 'getDownloadUrl',
                    onTap: () async => await _storage
                        .reference(_controller2.text)
                        .getDownloadUrl(),
                  ),
                  _buildButton(
                    text: 'delete',
                    onTap: () async => await _storage
                        .reference(_controller2.text)
                        .deleteFile(),
                  ),
                  const Divider(height: 0),
                  const Text('Data'),
                  _buildButton(
                    text: 'upload',
                    onTap: () async {
                      final AGCStorageUploadTask uploadTask = await _storage
                          .reference(_controller2.text)
                          .uploadData(
                            Uint8List.fromList(
                              List<int>.generate(
                                2 * 1024 * 1024, // megabyte
                                (_) => Random().nextInt(256),
                              ),
                            ),
                          );
                      uploadTask.onEvent().listen((_) {
                        if (uploadTask.result != null) {
                          setState(() {
                            _progressValue = 1.0 *
                                uploadTask.result!.bytesTransferred /
                                uploadTask.result!.totalByteCount;
                          });
                        }
                      });
                      await uploadTask.whenComplete();
                      if (uploadTask.exception != null) {
                        throw uploadTask.exception!;
                      } else {
                        return uploadTask.result;
                      }
                    },
                  ),
                  _buildButton(
                    text: 'download',
                    onTap: () async => (await _storage
                            .reference(_controller2.text)
                            .downloadData())
                        ?.length,
                  ),
                  const Divider(height: 0),
                  const Text('File'),
                  _buildButton(
                    text: 'upload',
                    onTap: () async {
                      final XFile? xFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (xFile != null) {
                        final AGCStorageUploadTask uploadTask = await _storage
                            .reference(_controller2.text)
                            .uploadFile(File(xFile.path));

                        uploadTask.onEvent().listen((_) {
                          if (uploadTask.result != null) {
                            setState(() {
                              _progressValue = 1.0 *
                                  uploadTask.result!.bytesTransferred /
                                  uploadTask.result!.totalByteCount;
                            });
                          }
                        });
                        await uploadTask.whenComplete();
                        if (uploadTask.exception != null) {
                          throw uploadTask.exception!;
                        } else {
                          return uploadTask.result;
                        }
                      }
                    },
                  ),
                  _buildButton(
                    text: 'download',
                    onTap: () async {
                      final Directory dir =
                          await getApplicationDocumentsDirectory();

                      final AGCStorageDownloadTask downloadTask = await _storage
                          .reference(_controller2.text)
                          .downloadToFile(
                              File('${dir.path}/${_controller2.text}'));

                      downloadTask.onEvent().listen((_) {
                        if (downloadTask.result != null) {
                          setState(() {
                            _progressValue = 1.0 *
                                downloadTask.result!.bytesTransferred /
                                downloadTask.result!.totalByteCount;
                          });
                        }
                      });
                      await downloadTask.whenComplete();
                      if (downloadTask.exception != null) {
                        throw downloadTask.exception!;
                      } else {
                        return "File has been downloaded to the"+ dir.path+"/"+_controller2.text + "\n"+ downloadTask.result.toString();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          if (_isBusy)
            Container(
              color: Colors.black87,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                value: _progressValue,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGroup({required List<Widget> children}) {
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

  Widget _buildButton(
      {required String text, required Future<dynamic> Function() onTap}) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () async {
        try {
          setState(() {
            _progressValue = null;
            _isBusy = true;
          });
          final dynamic result = await onTap();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('SUCCESS'),
                content: result != null
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text('$result'),
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
                content: Text(e.toString()),
              );
            },
          );
        } finally {
          setState(() {
            _progressValue = null;
            _isBusy = false;
          });
        }
      },
    );
  }
}
