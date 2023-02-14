/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressed;

  CustomButton(this._text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blueGrey,
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      splashColor: Colors.blueAccent,
      child: Text(_text, style: TextStyle(fontSize: 14)),
      onPressed: _onPressed,
    );
  }
}
