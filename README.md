# flutter_qiyu

适用于 Flutter 的七鱼客服插件

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [快速开始](#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B)
  - [安装](#%E5%AE%89%E8%A3%85)
  - [用法](#%E7%94%A8%E6%B3%95)
    - [初始化 SDK](#%E5%88%9D%E5%A7%8B%E5%8C%96-sdk)
    - [上报用户信息](#%E4%B8%8A%E6%8A%A5%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF)
    - [打开服务窗口](#%E6%89%93%E5%BC%80%E6%9C%8D%E5%8A%A1%E7%AA%97%E5%8F%A3)
    - [获取未读消息数](#%E8%8E%B7%E5%8F%96%E6%9C%AA%E8%AF%BB%E6%B6%88%E6%81%AF%E6%95%B0)
    - [自定义客服聊天窗口 UI](#%E8%87%AA%E5%AE%9A%E4%B9%89%E5%AE%A2%E6%9C%8D%E8%81%8A%E5%A4%A9%E7%AA%97%E5%8F%A3-ui)
- [相关链接](#%E7%9B%B8%E5%85%B3%E9%93%BE%E6%8E%A5)
- [许可证](#%E8%AE%B8%E5%8F%AF%E8%AF%81)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 快速开始

### 安装

将此添加到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flutter_qiyu: ^0.1.1
```

您可以从命令行安装软件包：

```bash
$ flutter packages get
```

### 用法

#### 初始化 SDK

```dart
QiYu.registerApp(
  appKey: '<appKey>',
  appName: 'qiyu example',
);
```

> 由于七鱼版本升级，Android 平台需要在 `Application#onCreate` 中调用初始化 SDK 方法，请修改以下文件（完整示例参见 example 目录）。

AndroidManifest.xml

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="org.leanflutter.plugins.flutter_qiyu_example">

    ...

    <application
-        android:name="io.flutter.app.FlutterApplication"
+        android:name=".MainApplication"
        android:icon="@mipmap/ic_launcher"
        android:label="flutter_qiyu_example"
+        android:networkSecurityConfig="@xml/network_security_config">

        ...

    </application>
</manifest>
```

MainApplication.java

```java
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
```

#### 上报用户信息

```dart
QYUserInfoParams userInfoParams = QYUserInfoParams.fromJson({
  'userId': 'uid10101010',
  'data':
      '[{\"key\":\"real_name\", \"value\":\"土豪\"},{\"key\":\"mobile_phone\", \"hidden\":true},{\"key\":\"email\", \"value\":\"13800000000@163.com\"},{\"index\":0, \"key\":\"account\", \"label\":\"账号\", \"value\":\"zhangsan\", \"href\":\"http://example.domain/user/zhangsan\"},{\"index\":1, \"key\":\"sex\", \"label\":\"性别\", \"value\":\"先生\"},{\"index\":5, \"key\":\"reg_date\", \"label\":\"注册日期\", \"value\":\"2015-11-16\"},{\"index\":6, \"key\":\"last_login\", \"label\":\"上次登录时间\", \"value\":\"2015-12-22 15:38:54\"}]'
});
QiYu.setUserInfo(userInfoParams);
```

#### 打开服务窗口

```dart

QYServiceWindowParams serviceWindowParams =
    QYServiceWindowParams.fromJson({
  'source': {
    'sourceTitle': '网易七鱼Flutter',
    'sourceUrl': 'http://www.qiyukf.com',
    'sourceCustomInfo': '我是来自自定义的信息'
  },
  'commodityInfo': {
    'commodityInfoTitle': 'Flutter商品',
    'commodityInfoDesc': '这是来自网易七鱼Flutter的商品描述',
    'pictureUrl':
        'http://qiyukf.com/res/img/companyLogo/blmn.png',
    'commodityInfoUrl': 'http://www.qiyukf.com',
    'note': '￥1000',
    'show': true
  },
  'sessionTitle': '网易七鱼123',
  'groupId': 0,
  'staffId': 0,
  'robotId': 0,
  'robotFirst': false,
  'faqTemplateId': 0,
  'vipLevel': 0,
  'showQuitQueue': true,
  'showCloseSessionEntry': true
});
QiYu.openServiceWindow(serviceWindowParams);
```

#### 获取未读消息数

```dart
// 直接获取未读消息数
QiYu.getUnreadCount().then((unreadCount) {
  setState(() {
    _unreadCount = unreadCount;
  });
});
// 监听未读消息数变化
QiYu.onUnreadCountChange((unreadCount) {
  setState(() {
    _qiyuUnreadCount = unreadCount;
  });
});
```

#### 自定义客服聊天窗口 UI

```dart
var params = {
  //
};
QiYu.setCustomUIConfig(params)
```

详情参数说明同官方 react-native-qiyu 插件：
https://github.com/qiyukf/react-native-qiyu#-setcustomuiconfig

## 相关链接

- https://qiyukf.com
- https://github.com/qiyukf/react-native-qiyu
- https://github.com/qiyukf/QIYU_iOS_SDK

## 许可证

```
MIT License

Copyright (c) 2021 LiJianying <lijy91@foxmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
