import 'dart:async';

import 'package:flutter/services.dart';

import './qy_service_window_params.dart';
import './qy_user_info_params.dart';

typedef UnreadCountChangeListener(int unreadCount);

class QiYuMethodCallHandler {
  QiYuMethodCallHandler();

  List<UnreadCountChangeListener> _unreadCountChangeListeners = [];

  void register(dynamic listener) {
    if (listener is UnreadCountChangeListener) {
      _unreadCountChangeListeners.add(listener);
    }
  }

  void unregister(dynamic listener) {
    if (listener is UnreadCountChangeListener) {
      _unreadCountChangeListeners.removeWhere((v) => v == listener);
    }
  }

  Future<dynamic> handler(MethodCall call) {
    switch (call.method) {
      case 'onUnreadCountChange':
        for (var unreadCountChangeListener in _unreadCountChangeListeners) {
          int unreadCount = call.arguments['unreadCount'];
          unreadCountChangeListener(unreadCount);
        }
        break;
      default:
        throw new UnsupportedError("Unrecognized Method");
    }
    return null;
  }
}

class QiYu {
  static const MethodChannel _channel = const MethodChannel('flutter_qiyu');

  static QiYuMethodCallHandler _methodCallHandler = QiYuMethodCallHandler();

  static void registerListener(dynamic listener) {
    _methodCallHandler.register(listener);
  }

  static void unregisterListener(dynamic listener) {
    _methodCallHandler.unregister(listener);
  }

  static void onUnreadCountChange(UnreadCountChangeListener listener) {
    _methodCallHandler.register(listener);
  }

  static Future<bool> registerApp({String appKey, String appName}) async {
    _channel.setMethodCallHandler(_methodCallHandler.handler);

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

  static Future<int> getUnreadCount() async {
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
