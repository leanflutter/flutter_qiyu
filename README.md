# flutter_qiyu

Qiyu plugin for Flutter.

## Getting Started

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_qiyu:
    git:
      url: https://github.com/blankapp/flutter_qiyu.git
      ref: master
```

You can install packages from the command line:

```bash
$ flutter packages get
```

### Usage

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_qiyu/flutter_qiyu.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initQiYuSDK();

    super.initState();
  }

  Future<void> initQiYuSDK() async {
    QiYu.registerApp(
      appKey: '<AppKey>',
      appName: '<AppName>',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                child: Text('联系客服'),
                onPressed: () {
                  QYServiceWindowParams serviceWindowParams = QYServiceWindowParams.fromJson({
                    'source': {
                      'sourceTitle': '网易七鱼ReactNative',
                      'sourceUrl': 'http://www.qiyukf.com',
                      'sourceCustomInfo': '我是来自自定义的信息'
                    },
                    'commodityInfo': {
                      'commodityInfoTitle': 'ReactNative商品',
                      'commodityInfoDesc': '这是来自网易七鱼ReactNative的商品描述',
                      'pictureUrl': 'http://qiyukf.com/res/img/companyLogo/blmn.png',
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

                  QYUserInfoParams userInfoParams = QYUserInfoParams.fromJson({
                    'userId':'uid10101010',
                    'data':'[{\"key\":\"real_name\", \"value\":\"土豪\"},{\"key\":\"mobile_phone\", \"hidden\":true},{\"key\":\"email\", \"value\":\"13800000000@163.com\"},{\"index\":0, \"key\":\"account\", \"label\":\"账号\", \"value\":\"zhangsan\", \"href\":\"http://example.domain/user/zhangsan\"},{\"index\":1, \"key\":\"sex\", \"label\":\"性别\", \"value\":\"先生\"},{\"index\":5, \"key\":\"reg_date\", \"label\":\"注册日期\", \"value\":\"2015-11-16\"},{\"index\":6, \"key\":\"last_login\", \"label\":\"上次登录时间\", \"value\":\"2015-12-22 15:38:54\"}]'
                  });
                  QiYu.setUserInfo(userInfoParams);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

## Related Links

- https://github.com/qiyukf/react-native-qiyu
- https://github.com/qiyukf/QIYU_iOS_SDK

## License

```
MIT License

Copyright (c) 2020 LiJianying <lijy91@foxmail.com>

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
