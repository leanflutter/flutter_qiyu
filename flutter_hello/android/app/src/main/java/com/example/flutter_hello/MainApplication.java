/*
 * @Description: 
 * @Author: 琢磨先生
 * @Date: 2021-10-26 16:36:56
 * @LastEditors: 琢磨先生
 * @LastEditTime: 2021-10-26 16:44:32
 */
package com.example.flutter_hello;

import org.leanflutter.plugins.flutter_qiyu.FlutterQiyuPlugin;

import io.flutter.app.FlutterApplication;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterQiyuPlugin.initSDK(this, "e2ed971895607489b23f9cb01082492f");
    }
}