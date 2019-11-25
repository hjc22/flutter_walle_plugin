import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io' show Platform;
class FlutterWallePlugin {
  static const MethodChannel _channel =
      const MethodChannel('plugins.hjc.com/flutter_walle_plugin');

  static Future<Map> getWalleChannelInfo() async {
    if(!Platform.isAndroid) {
      return null;
    }
    return await _channel.invokeMethod('getWalleChannelInfo');
  }
  static Future<String> getWalleChannel() async {
    if(!Platform.isAndroid) {
      return null;
    }
    return await _channel.invokeMethod('getWalleChannel');
  }
}
