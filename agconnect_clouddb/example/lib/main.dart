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

import 'dart:async';

import 'package:agconnect_auth/agconnect_auth.dart';
import 'package:agconnect_clouddb/agconnect_clouddb.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  final String _zoneName = 'demo';
  final String _objectTypeName = 'BookInfo';
  AGConnectCloudDBZone? _zone;
  String? _currentUserUid;
  StreamSubscription<AGConnectCloudDBZoneSnapshot?>? _snapshotSubscription;
  StreamSubscription<String?>? _onEvent;
  StreamSubscription<bool?>? _onDataEncryptionKeyChanged;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _initCurrentUser();
        await AGConnectCloudDB.getInstance().initialize();
        await AGConnectCloudDB.getInstance().createObjectType();
        _onEvent =
            AGConnectCloudDB.getInstance().onEvent().listen((String? event) {
          _showDialog(context, 'On Event: $event');
        });
        _onDataEncryptionKeyChanged = AGConnectCloudDB.getInstance()
            .onDataEncryptionKeyChanged()
            .listen((bool? data) {
          _showDialog(context, 'Data Encryption Key Changed: $data');
        });
      } catch (e) {
        _showDialog(context, 'ERROR', e is FormatException ? e.message : e);
      }
    });
  }

  @override
  void dispose() {
    _snapshotSubscription?.cancel();
    _onEvent?.cancel();
    _onDataEncryptionKeyChanged?.cancel();
    super.dispose();
  }

  Future<void> _initCurrentUser() async {
    final AGCUser? currentUser = await AGCAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() => _currentUserUid = currentUser.uid);
    } else {
      final SignInResult signInResult =
          await AGCAuth.instance.signInAnonymously();
      if (signInResult.user != null) {
        setState(() => _currentUserUid = signInResult.user?.uid);
      } else {
        setState(() => _currentUserUid = '???');
      }
    }
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text("AGC Cloud DB Demo"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  setState(() => _isBusy = true);
                  await AGCAuth.instance.signOut();
                  setState(() => _currentUserUid = null);
                  await _initCurrentUser();
                  setState(() => _isBusy = false);
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('UserID: $_currentUserUid'),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    _buildGroup(
                      children: <Widget>[
                        _buildButton(
                          text: 'openCloudDBZone',
                          onTap: () async {
                            if (_zone != null) {
                              throw FormatException(
                                  'Zone object is not null. First try close zone.',
                                  _zone);
                            }
                            _zone = await AGConnectCloudDB.getInstance()
                                .openCloudDBZone(
                              zoneConfig: AGConnectCloudDBZoneConfig(
                                  zoneName: _zoneName),
                            );
                          },
                        ),
                        _buildButton(
                          text: 'openCloudDBZone2',
                          onTap: () async {
                            if (_zone != null) {
                              throw FormatException(
                                  'Zone object is not null. First try close zone.',
                                  _zone);
                            }
                            _zone = await AGConnectCloudDB.getInstance()
                                .openCloudDBZone2(
                              zoneConfig: AGConnectCloudDBZoneConfig(
                                  zoneName: _zoneName),
                            );
                          },
                        ),
                        _buildButton(
                          text: 'closeCloudDBZone',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            await AGConnectCloudDB.getInstance()
                                .closeCloudDBZone(zone: _zone!);
                            _zone = null;
                          },
                        ),
                        _buildButton(
                          text: 'deleteCloudDBZone',
                          onTap: () async =>
                              await AGConnectCloudDB.getInstance()
                                  .deleteCloudDBZone(zoneName: _zoneName),
                        ),
                      ],
                    ),
                    _buildGroup(
                      children: <Widget>[
                        _buildButton(
                          text: 'getCloudDBZoneConfig',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.getCloudDBZoneConfig();
                          },
                        ),
                        _buildButton(
                          text: 'getCloudDBZoneConfigs',
                          onTap: () async =>
                              await AGConnectCloudDB.getInstance()
                                  .getCloudDBZoneConfigs(),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildGroup(
                      children: <Widget>[
                        _buildButton(
                          text: 'enableNetwork',
                          onTap: () async =>
                              await AGConnectCloudDB.getInstance()
                                  .enableNetwork(zoneName: _zoneName),
                        ),
                        _buildButton(
                          text: 'disableNetwork',
                          onTap: () async =>
                              await AGConnectCloudDB.getInstance()
                                  .disableNetwork(zoneName: _zoneName),
                        ),
                      ],
                    ),
                    _buildGroup(
                      children: <Widget>[
                        _buildButton(
                          text: 'setUserKey',
                          onTap: () async =>
                              await AGConnectCloudDB.getInstance().setUserKey(
                                  userKey: '123456789', userReKey: ''),
                        ),
                        _buildButton(
                          text: 'updateDataEncryptionKey',
                          onTap: () async =>
                              await AGConnectCloudDB.getInstance()
                                  .updateDataEncryptionKey(),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildGroup(
                      children: <Widget>[
                        _buildButton(
                          text: 'subscribeSnapshot',
                          onTap: () async {
                            if (_snapshotSubscription == null) {
                              if (_zone == null) {
                                throw FormatException(
                                    'Zone object is null. First try open zone.',
                                    _zone);
                              }
                              final Stream<AGConnectCloudDBZoneSnapshot?>
                                  stream = await _zone!.subscribeSnapshot(
                                query: AGConnectCloudDBQuery(_objectTypeName)
                                  ..equalTo('id', 2),
                                policy: AGConnectCloudDBZoneQueryPolicy
                                    .POLICY_QUERY_DEFAULT,
                              );
                              _snapshotSubscription = stream.listen(
                                  (AGConnectCloudDBZoneSnapshot? snapshot) {
                                _showDialog(
                                    context, 'subscribeSnapshot', snapshot);
                              });
                            }
                          },
                        ),
                        _buildButton(
                          text: 'removeSnapshot',
                          onTap: () async => _snapshotSubscription
                              ?.cancel()
                              .then((_) => _snapshotSubscription = null),
                        ),
                      ],
                    ),
                    _buildGroup(
                      children: <Widget>[
                        _buildButton(
                          text: 'executeUpsert',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            final int count = await _zone!.executeUpsert(
                              objectTypeName: _objectTypeName,
                              entries: <Map<String, dynamic>>[
                                <String, dynamic>{
                                  'id': 1,
                                  'bookName': 'Book Name - 1',
                                  'price': 14.80,
                                },
                                <String, dynamic>{
                                  'id': 2,
                                  'bookName': 'Book Name - 2',
                                  'price': 22.99,
                                },
                                <String, dynamic>{
                                  'id': 3,
                                  'bookName': 'Book Name - 3',
                                  'price': 5.60,
                                },
                              ],
                            );
                            return '$count objects successfully written.';
                          },
                        ),
                        _buildButton(
                          text: 'executeDelete',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            final int count = await _zone!.executeDelete(
                              objectTypeName: _objectTypeName,
                              entries: <Map<String, dynamic>>[
                                <String, dynamic>{
                                  'id': 2,
                                },
                              ],
                            );
                            return '$count objects successfully deleted.';
                          },
                        ),
                        _buildButton(
                          text: 'runTransaction',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            await _zone!.runTransaction(
                              transaction: AGConnectCloudDBTransaction()
                                ..executeUpsert(
                                  objectTypeName: _objectTypeName,
                                  entries: <Map<String, dynamic>>[
                                    <String, dynamic>{
                                      'id': 10,
                                      'bookName': 'Book_10',
                                      'price': 5.10,
                                    },
                                    <String, dynamic>{
                                      'id': 20,
                                      'bookName': 'Book_20',
                                      'price': 25.20,
                                    },
                                  ],
                                )
                                ..executeDelete(
                                  objectTypeName: _objectTypeName,
                                  entries: <Map<String, dynamic>>[
                                    <String, dynamic>{
                                      'id': 10,
                                    },
                                  ],
                                ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildGroup(
                      children: <Widget>[
                        _buildButton(
                          text: 'executeQuery',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeQuery(
                              query: AGConnectCloudDBQuery(_objectTypeName)
                                ..orderBy('price'),
                              policy: AGConnectCloudDBZoneQueryPolicy
                                  .POLICY_QUERY_DEFAULT,
                            );
                          },
                        ),
                        _buildButton(
                          text: 'executeQueryUnsynced',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeQueryUnsynced(
                              query: AGConnectCloudDBQuery(_objectTypeName)
                                ..orderBy('price'),
                            );
                          },
                        ),
                      ],
                    ),
                    _buildGroup(
                      children: <Widget>[
                        _buildButton(
                          text: 'executeCountQuery',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeCountQuery(
                              field: 'price',
                              query: AGConnectCloudDBQuery(_objectTypeName),
                              policy: AGConnectCloudDBZoneQueryPolicy
                                  .POLICY_QUERY_DEFAULT,
                            );
                          },
                        ),
                        _buildButton(
                          text: 'executeSumQuery',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeSumQuery(
                              field: 'price',
                              query: AGConnectCloudDBQuery(_objectTypeName),
                              policy: AGConnectCloudDBZoneQueryPolicy
                                  .POLICY_QUERY_DEFAULT,
                            );
                          },
                        ),
                        _buildButton(
                          text: 'executeAverageQuery',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeAverageQuery(
                              field: 'price',
                              query: AGConnectCloudDBQuery(_objectTypeName),
                              policy: AGConnectCloudDBZoneQueryPolicy
                                  .POLICY_QUERY_DEFAULT,
                            );
                          },
                        ),
                        _buildButton(
                          text: 'executeMinimalQuery',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeMinimalQuery(
                              field: 'price',
                              query: AGConnectCloudDBQuery(_objectTypeName),
                              policy: AGConnectCloudDBZoneQueryPolicy
                                  .POLICY_QUERY_DEFAULT,
                            );
                          },
                        ),
                        _buildButton(
                          text: 'executeMaximumQuery',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeMaximumQuery(
                              field: 'price',
                              query: AGConnectCloudDBQuery(_objectTypeName),
                              policy: AGConnectCloudDBZoneQueryPolicy
                                  .POLICY_QUERY_DEFAULT,
                            );
                          },
                        ),
                        _buildButton(
                          text: 'executeServerStatusQuery',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeServerStatusQuery();
                          },
                        ),
                        _buildButton(
                          text: 'executeGreaterThan',
                          onTap: () async {
                            if (_zone == null) {
                              throw FormatException(
                                  'Zone object is null. First try open zone.',
                                  _zone);
                            }
                            return await _zone!.executeQuery(
                                query: AGConnectCloudDBQuery(_objectTypeName)
                                  ..greaterThan('price', 10),
                                policy: AGConnectCloudDBZoneQueryPolicy
                                    .POLICY_QUERY_DEFAULT);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isBusy)
          Container(
            color: Colors.black87,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildGroup({
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8, bottom: 8),
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
          setState(() => _isBusy = true);
          final dynamic result = await onTap();
          _showDialog(context, 'SUCCESS', result);
        } catch (e) {
          _showDialog(context, 'ERROR', e.toString());
        } finally {
          setState(() => _isBusy = false);
        }
      },
    );
  }
}
