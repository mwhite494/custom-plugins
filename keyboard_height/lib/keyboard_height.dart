import 'dart:async';

import 'package:flutter/services.dart';

class KeyboardHeight {
  static const MethodChannel _channel =
      const MethodChannel('keyboard_height');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
