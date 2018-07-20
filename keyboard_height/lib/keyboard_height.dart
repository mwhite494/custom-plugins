import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final MethodChannel _channel = const MethodChannel('keyboard_height');

Future<int> getKeyboardHeight() async {
  final int height = await _channel.invokeMethod('getKeyboardHeight');
  return height;
}

class KeyboardHeightListener {
  final Function onHeightChanged;

  static const _stream = const EventChannel('com.crater.plugins.keyboardheight/stream');
  StreamSubscription _subscription;

  KeyboardHeightListener({@required this.onHeightChanged});

  void start() {
    if (_subscription == null) {
      _subscription = _stream.receiveBroadcastStream().listen(onHeightChanged);
    }
  }

  void stop() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

}
