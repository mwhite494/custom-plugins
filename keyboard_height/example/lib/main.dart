import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:keyboard_height/keyboard_height.dart';

void main() {
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FocusNode _focusNode = new FocusNode();
  KeyboardHeightListener keyboardHeightListener;
  int _keyboardHeight;

  @override
  void initState() {
    super.initState();
    _initKeyboardHeight();
    keyboardHeightListener = KeyboardHeightListener(onHeightChanged: _updateKeyboardHeight);
    keyboardHeightListener.start();
  }

  @override
  void dispose() {
    keyboardHeightListener.stop();
    super.dispose();
  }

  Future<void> _initKeyboardHeight() async {
    int height = await getKeyboardHeight();
    setState(() => _keyboardHeight = height);
  }

  void _updateKeyboardHeight(height) {
    setState(() => _keyboardHeight = height);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('KeyboardHeight example app'),
        ),
        body: new Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: Alignment.center,
          child: new Column(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: EditableText(
                  controller: TextEditingController(),
                  focusNode: _focusNode,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    fontSize: 48.0,
                    color: Colors.black
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: new Text(
                  'Height in pixels: '+_keyboardHeight.toString(),
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    FocusScope.of(context).reparentIfNeeded(_focusNode);
                    FocusScope.of(context).requestFocus(_focusNode);
                  });
                },
                child: new Container(
                  padding: const EdgeInsets.all(5.0),
                  color: Colors.grey,
                  child: const Text(
                    'OPEN',
                    style: const TextStyle(fontSize: 24.0),
                  )
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
