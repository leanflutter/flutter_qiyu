import 'dart:async';

import 'package:flutter/services.dart';

import './qy_service_window_params.dart';
import './qy_user_info_params.dart';

class QiYu {
  static const MethodChannel _channel = const MethodChannel('flutter_qiyu');

  static Future<bool> registerApp({String appKey, String appName}) async {
    return await _channel.invokeMethod('registerApp', {
      'appKey': appKey,
      'appName': appName,
    });
  }

  static Future<bool> openServiceWindow(QYServiceWindowParams params) async {
    return await _channel.invokeMethod('openServiceWindow', params.toJson());
  }

  static Future<bool> setCustomUIConfig(Map params) async {
    return await _channel.invokeMethod('setCustomUIConfig', params);
  }

  static Future<String> getUnreadCount() async {
    return await _channel.invokeMethod('getUnreadCount', {});
  }

  static Future<bool> setUserInfo(QYUserInfoParams params) async {
    return await _channel.invokeMethod('setUserInfo', params.toJson());
  }

  static Future<bool> logout() async {
    return await _channel.invokeMethod('logout', {});
  }

  static Future<bool> cleanCache() async {
    return await _channel.invokeMethod('cleanCache', {});
  }
}
