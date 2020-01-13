#import <UIKit/UIKit.h>
#import <QIYU_iOS_SDK/QYSDK.h>
#import "FlutterQiyuPlugin.h"
#import "UIBarButtonItem+blocks.h"

@interface FlutterQiyuPlugin () <QYConversationManagerDelegate>
@end

@implementation FlutterQiyuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_qiyu"
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterQiyuPlugin* instance = [[FlutterQiyuPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
    
    instance.channel = channel;

    [[[QYSDK sharedSDK] conversationManager] setDelegate:instance];
    [[QYSDK sharedSDK] registerPushMessageNotification:^(QYPushMessage *message) {
        // TODO:
    }];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *options = call.arguments;
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"registerApp" isEqualToString:call.method]) {
        NSString *appKey = call.arguments[@"appKey"];
        NSString *appName = call.arguments[@"appName"];
        [self registerApp:appKey appName:appName];
        result([NSNumber numberWithBool:YES]);
    } else if ([@"openServiceWindow" isEqualToString:call.method]) {
        [self openServiceWindow:options];
        result([NSNumber numberWithBool:YES]);
    } else if ([@"setCustomUIConfig" isEqualToString:call.method]) {
        [self setCustomUIConfig:options];
        result([NSNumber numberWithBool:YES]);
    } else if ([@"getUnreadCount" isEqualToString:call.method]) {
        NSInteger* unreadCount = [self getUnreadCount];
        result([NSNumber numberWithInteger:unreadCount]);
    } else if ([@"setUserInfo" isEqualToString:call.method]) {
        [self setUserInfo:options];
        result([NSNumber numberWithBool:YES]);
    } else if ([@"logout" isEqualToString:call.method]) {
        [self logout];
        result([NSNumber numberWithBool:YES]);
    } else if ([@"cleanCache" isEqualToString:call.method]) {
        [self cleanCache];
        result([NSNumber numberWithBool:YES]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)registerApp:(NSString*) appKey
            appName:(NSString*) appName
{
    [[QYSDK sharedSDK] registerAppId:appKey appName:appName];
}

- (void)openServiceWindow:(NSDictionary *)options
{
    NSDictionary *paramDict = options;
    QYSessionViewController *sessionVC = [[QYSDK sharedSDK] sessionViewController];

    QYSource *source = nil;
    if ([paramDict objectForKey:@"source"]) {
        NSDictionary *sourceDict = [paramDict objectForKey:@"source"];
        if ([sourceDict objectForKey:@"sourceTitle"] || [sourceDict objectForKey:@"sourceUrl"]
            || [sourceDict objectForKey:@"sourceCustomInfo"]) {
            source = [[QYSource alloc] init];
            if ([sourceDict objectForKey:@"sourceTitle"]) {
                source.title = [sourceDict objectForKey:@"sourceTitle"];
            }
            if ([sourceDict objectForKey:@"sourceUrl"]) {
                source.urlString = [sourceDict objectForKey:@"sourceUrl"];
            }
            if ([sourceDict objectForKey:@"sourceCustomInfo"]) {
                source.customInfo = [sourceDict objectForKey:@"sourceCustomInfo"];
            }
        }
    }
    QYCommodityInfo *commodityInfo = nil;
    if ([paramDict objectForKey:@"commodityInfo"]) {
        NSDictionary *commodityInfoDict = [paramDict objectForKey:@"commodityInfo"];
        if ([commodityInfoDict objectForKey:@"commodityInfoTitle"] || [commodityInfoDict objectForKey:@"commodityInfoDesc"]
            || [commodityInfoDict objectForKey:@"pictureUrl"] || [commodityInfoDict objectForKey:@"commodityInfoUrl"]
            || [commodityInfoDict objectForKey:@"note"] || [commodityInfoDict objectForKey:@"show"]
            || [commodityInfoDict objectForKey:@"sendByUser"]) {
            commodityInfo = [[QYCommodityInfo alloc] init];
            if ([commodityInfoDict objectForKey:@"commodityInfoTitle"]) {
                commodityInfo.title = [commodityInfoDict objectForKey:@"commodityInfoTitle"];
            }
            if ([commodityInfoDict objectForKey:@"commodityInfoDesc"]) {
                commodityInfo.desc = [commodityInfoDict objectForKey:@"commodityInfoDesc"];
            }
            if ([commodityInfoDict objectForKey:@"pictureUrl"]) {
                commodityInfo.pictureUrlString = [commodityInfoDict objectForKey:@"pictureUrl"];
            }
            if ([commodityInfoDict objectForKey:@"commodityInfoUrl"]) {
                commodityInfo.urlString = [commodityInfoDict objectForKey:@"commodityInfoUrl"];
            }
            if ([commodityInfoDict objectForKey:@"note"]) {
                commodityInfo.note = [commodityInfoDict objectForKey:@"note"];
            }
            if ([commodityInfoDict objectForKey:@"show"]) {
                commodityInfo.show = [[commodityInfoDict objectForKey:@"show"] boolValue];
            }
            if ([commodityInfoDict objectForKey:@"sendByUser"]) {
                commodityInfo.sendByUser = [[commodityInfoDict objectForKey:@"sendByUser"] boolValue];
            }
        }
    }
    if (source) {
        sessionVC.source = source;
    }
    if (commodityInfo) {
        sessionVC.commodityInfo = commodityInfo;
    }
    if ([paramDict objectForKey:@"sessionTitle"]) {
        sessionVC.sessionTitle = [paramDict objectForKey:@"sessionTitle"];
    }
    if ([paramDict objectForKey:@"groupId"]) {
        sessionVC.groupId = [[paramDict objectForKey:@"groupId"] intValue];
    }
    if ([paramDict objectForKey:@"staffId"]) {
        sessionVC.staffId = [[paramDict objectForKey:@"staffId"] intValue];
    }
    if ([paramDict objectForKey:@"robotId"]) {
        sessionVC.robotId = [[paramDict objectForKey:@"robotId"] intValue];
    }
    if ([paramDict objectForKey:@"vipLevel"]) {
        sessionVC.vipLevel = [[paramDict objectForKey:@"vipLevel"] intValue];
    }
    if ([paramDict objectForKey:@"robotFirst"]) {
        sessionVC.openRobotInShuntMode = [paramDict objectForKey:@"robotFirst"];
    }
    if ([paramDict objectForKey:@"faqTemplateId"]) {
        sessionVC.commonQuestionTemplateId = [[paramDict objectForKey:@"faqTemplateId"] intValue];
    }

    [sessionVC.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain actionHandler:^{
        [self.viewController dismissViewControllerAnimated:true completion:nil];
    }]];

    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:sessionVC];
    [rootNavigationController setNavigationBarHidden:YES];
    rootNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;

    [self.viewController presentViewController:rootNavigationController animated:YES completion:nil];
}

- (void)setCustomUIConfig:(NSDictionary *)options
{
    NSDictionary *paramDict = options;
    if ([paramDict objectForKey:@"sessionTipTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].sessionTipTextColor = [self colorFromHexString:[paramDict objectForKey:@"sessionTipTextColor"]];
    }
    if ([paramDict objectForKey:@"sessionTipTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].sessionTipTextFontSize = [[paramDict objectForKey:@"sessionTipTextFontSize"] floatValue];
    }
    if ([paramDict objectForKey:@"customMessageTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [self colorFromHexString:[paramDict objectForKey:@"customMessageTextColor"]];
    }
    if ([paramDict objectForKey:@"messageTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].customMessageTextFontSize = [[paramDict objectForKey:@"messageTextFontSize"] floatValue];
    }
    if ([paramDict objectForKey:@"serviceMessageTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [self colorFromHexString:[paramDict objectForKey:@"serviceMessageTextColor"]];
    }
    if ([paramDict objectForKey:@"messageTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].serviceMessageTextFontSize = [[paramDict objectForKey:@"messageTextFontSize"] floatValue];
    }
    if ([paramDict objectForKey:@"tipMessageTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].tipMessageTextColor = [self colorFromHexString:[paramDict objectForKey:@"tipMessageTextColor"]];
    }
    if ([paramDict objectForKey:@"tipMessageTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].tipMessageTextFontSize = [[paramDict objectForKey:@"tipMessageTextFontSize"] floatValue];
    }
    if ([paramDict objectForKey:@"inputTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].inputTextColor = [self colorFromHexString:[paramDict objectForKey:@"inputTextColor"]];
    }
    if ([paramDict objectForKey:@"inputTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].inputTextFontSize = [[paramDict objectForKey:@"inputTextFontSize"] floatValue];
    }
    NSString *imageName = nil;
    if ([paramDict objectForKey:@"sessionBackgroundImage"]) {
        imageName = [paramDict objectForKey:@"sessionBackgroundImage"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[QYSDK sharedSDK] customUIConfig].sessionBackground = [[UIImageView alloc] initWithImage:[self getResourceImage:imageName]];
        });
    }
    if ([paramDict objectForKey:@"sessionTipBackgroundColor"]) {
        [[QYSDK sharedSDK] customUIConfig].sessionTipBackgroundColor = [self colorFromHexString:[paramDict objectForKey:@"sessionTipBackgroundColor"]];
    }
    if ([paramDict objectForKey:@"customerHeadImage"]) {
        imageName = [paramDict objectForKey:@"customerHeadImage"];
        [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [self getResourceImage:imageName];
    }
    if ([paramDict objectForKey:@"serviceHeadImage"]) {
        imageName = [paramDict objectForKey:@"serviceHeadImage"];
        [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [self getResourceImage:imageName];
    }
    if ([paramDict objectForKey:@"customerMessageBubbleNormalImage"]) {
        imageName = [paramDict objectForKey:@"customerMessageBubbleNormalImage"];
        [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage = [self getResourceImage:imageName];
    }
    if ([paramDict objectForKey:@"serviceMessageBubbleNormalImage"]) {
        imageName = [paramDict objectForKey:@"serviceMessageBubbleNormalImage"];
        [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage = [self getResourceImage:imageName];
    }
    if ([paramDict objectForKey:@"customerMessageBubblePressedImage"]) {
        imageName = [paramDict objectForKey:@"customerMessageBubblePressedImage"];
        [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage = [self getResourceImage:imageName];
    }
    if ([paramDict objectForKey:@"serviceMessageBubblePressedImage"]) {
        imageName = [paramDict objectForKey:@"serviceMessageBubblePressedImage"];
        [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage = [self getResourceImage:imageName];
    }
    if ([paramDict objectForKey:@"sessionMessageSpacing"]) {
        [[QYSDK sharedSDK] customUIConfig].sessionMessageSpacing = [[paramDict objectForKey:@"sessionMessageSpacing"] floatValue];
    }
    if ([paramDict objectForKey:@"showHeadImage"]) {
        [[QYSDK sharedSDK] customUIConfig].showHeadImage = [paramDict objectForKey:@"showHeadImage"];
    }
//    if ([paramDict objectForKey:@"naviBarColor"]) {
//        self.naviBarColor = [self colorFromString:[paramDict objectForKey:@"naviBarColor"]];
//    }
//    if ([paramDict objectForKey:@"naviBarStyleDark"]) {
//        [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = [[paramDict objectForKey:@"naviBarStyleDark"] boolValue];
//    }
    if ([paramDict objectForKey:@"showAudioEntry"]) {
        [[QYSDK sharedSDK] customUIConfig].showAudioEntry = [[paramDict objectForKey:@"showAudioEntry"] boolValue];
    }
    if ([paramDict objectForKey:@"showEmoticonEntry"]) {
        [[QYSDK sharedSDK] customUIConfig].showEmoticonEntry = [[paramDict objectForKey:@"showEmoticonEntry"] boolValue];
    }
    if ([paramDict objectForKey:@"autoShowKeyboard"]) {
        [[QYSDK sharedSDK] customUIConfig].autoShowKeyboard = [[paramDict objectForKey:@"autoShowKeyboard"] boolValue];
    }
    if ([paramDict objectForKey:@"bottomMargin"]) {
        [[QYSDK sharedSDK] customUIConfig].bottomMargin = [[paramDict objectForKey:@"bottomMargin"] floatValue];
    }
//    if ([paramDict objectForKey:@"showCloseSessionEntry"]) {
//        [[QYSDK sharedSDK] customUIConfig].showCloseSessionEntry = [RCTConvert BOOL:[paramDict objectForKey:@"showCloseSessionEntry"]];
//    }
}

- (NSInteger *)getUnreadCount
{
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    return count;
}

- (void)setUserInfo:(NSDictionary *)options
{
    NSDictionary *paramDict = options;

    QYUserInfo *userInfo = nil;
    if ([paramDict objectForKey:@"userId"] || [paramDict objectForKey:@"data"]) {
        userInfo = [[QYUserInfo alloc] init];
        if ([paramDict objectForKey:@"userId"]) {
            userInfo.userId = [paramDict objectForKey:@"userId"];
        }
        if ([paramDict objectForKey:@"data"]) {
            userInfo.data = [paramDict objectForKey:@"data"];
        }
    }
    if (userInfo) {
        [[QYSDK sharedSDK] setUserInfo:userInfo];
    }
}

- (void)logout
{
    [[QYSDK sharedSDK] logout:nil];
}

- (void)cleanCache
{
    [[QYSDK sharedSDK] cleanResourceCacheWithBlock:nil];
}

- (UIColor *)colorFromHexString:(NSString*)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage*)getResourceImage:(NSString*)imageFilePath
{
    NSString *localImagePath = [imageFilePath substringFromIndex:1];
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    bundlePath = [[bundlePath stringByAppendingPathComponent:@"assets"] stringByAppendingPathComponent:localImagePath];
    
    UIImage *image = [[UIImage imageWithContentsOfFile:bundlePath] resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30) resizingMode:UIImageResizingModeStretch];
    if (image) {
        return image;
    }
    
    return nil;
}

- (void)onUnreadCountChanged:(NSInteger)count
{
    [_channel invokeMethod:@"onUnreadCountChange" arguments: @{@"unreadCount": [NSNumber numberWithInteger:count]}];
}

- (void)application:(UIApplication *)app
                didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

@end
