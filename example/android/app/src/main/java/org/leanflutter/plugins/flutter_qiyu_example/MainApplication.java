package org.leanflutter.plugins.flutter_qiyu_example;

import org.leanflutter.plugins.flutter_qiyu.FlutterQiyuPlugin;

import io.flutter.app.FlutterApplication;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterQiyuPlugin.initSDK(this, "<appKey>");
    }
}
