import 'dart:async';

import 'package:flutter/services.dart';

final MethodChannel _channel = const MethodChannel('keyboard_height');

Future<int> getKeyboardHeight() async {
  final int height = await _channel.invokeMethod('getKeyboardHeight');
  return height;
}
