package org.blankapp.flutterplugins.flutter_qiyu;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import com.qiyukf.nimlib.sdk.RequestCallback;
import com.qiyukf.nimlib.sdk.StatusBarNotificationConfig;
import com.qiyukf.unicorn.api.ConsultSource;
import com.qiyukf.unicorn.api.OnBotEventListener;
import com.qiyukf.unicorn.api.ProductDetail;
import com.qiyukf.unicorn.api.UICustomization;
import com.qiyukf.unicorn.api.Unicorn;
import com.qiyukf.unicorn.api.UnreadCountChangeListener;
import com.qiyukf.unicorn.api.YSFOptions;
import com.qiyukf.unicorn.api.YSFUserInfo;
import com.qiyukf.unicorn.api.lifecycle.SessionLifeCycleOptions;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterQiyuPlugin
 */
public class FlutterQiyuPlugin implements FlutterPlugin, MethodCallHandler {
    private static final String CHANNEL_NAME = "flutter_qiyu";

    public static void initSDK(Context context, String appKey) {
        YSFOptions ysfOptions = new YSFOptions();
        ysfOptions.statusBarNotificationConfig = new StatusBarNotificationConfig();
        ysfOptions.onBotEventListener = new OnBotEventListener() {
            @Override
            public boolean onUrlClick(Context context, String url) {
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                context.startActivity(intent);
                return true;
            }
        };
        // 如果项目中使用了 Glide 可以通过设置 gifImageLoader 去加载 gif 图片
        ysfOptions.gifImageLoader = new GlideGifImagerLoader(context);

        Unicorn.init(context.getApplicationContext(), appKey, ysfOptions, new GlideImageLoader(context));
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final FlutterQiyuPlugin plugin = new FlutterQiyuPlugin();
        plugin.setupChannel(registrar.messenger(), registrar.activeContext());
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    private Context context;
    private YSFOptions ysfOptions;
    private UnreadCountChangeListener unreadCountChangeListener = new UnreadCountChangeListener() {
        @Override
        public void onUnreadCountChange(int unreadCount) {
            Map<String, Object> map = new HashMap<>();
            map.put("unreadCount", unreadCount);

            channel.invokeMethod("onUnreadCountChange", map);
        }
    };

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.setupChannel(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        this.teardownChannel();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("registerApp")) {
            String appKey = call.argument("appKey");
            String appName = call.argument("appName");

            this.registerApp(appKey, appName);
            result.success(true);
        } else if (call.method.equals("openServiceWindow")) {
            this.openServiceWindow(call);
            result.success(true);
        } else if (call.method.equals("setCustomUIConfig")) {
            this.setCustomUIConfig(call);
            result.success(true);
        } else if (call.method.equals("getUnreadCount")) {
            this.getUnreadCount(call, result);
        } else if (call.method.equals("setUserInfo")) {
            this.setUserInfo(call);
        } else if (call.method.equals("logout")) {
            this.logout();
        } else if (call.method.equals("cleanCache")) {
            this.cleanCache();
        } else {
            result.notImplemented();
        }
    }

    private void registerApp(String appKey, String appName) {
        if (ysfOptions == null) {
            ysfOptions = new YSFOptions();
            ysfOptions.statusBarNotificationConfig = new StatusBarNotificationConfig();
            ysfOptions.onBotEventListener = new OnBotEventListener() {
                @Override
                public boolean onUrlClick(Context context, String url) {
                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                    context.startActivity(intent);
                    return true;
                }
            };
            // 如果项目中使用了 Glide 可以通过设置 gifImageLoader 去加载 gif 图片
            ysfOptions.gifImageLoader = new GlideGifImagerLoader(this.context);
        }

        Unicorn.init(this.context.getApplicationContext(), appKey, ysfOptions, new GlideImageLoader(this.context));
        Unicorn.addUnreadCountChangeListener(unreadCountChangeListener, true);
    }

    private void openServiceWindow(MethodCall call) {
        Map sourceMap = call.argument("source");
        Map commodityInfoMap = call.argument("commodityInfo");

        String sourceTitle = (String) sourceMap.get("sourceTitle");
        String sourceUrl = (String) sourceMap.get("sourceUrl");
        String sourceCustomInfo = (String) sourceMap.get("sourceCustomInfo");

        ProductDetail productDetail = null;
        if (commodityInfoMap != null) {
            String commodityInfoTitle = (String) commodityInfoMap.get("commodityInfoTitle");
            String commodityInfoDesc = (String) commodityInfoMap.get("commodityInfoDesc");
            String pictureUrl = (String) commodityInfoMap.get("pictureUrl");
            String commodityInfoUrl = (String) commodityInfoMap.get("commodityInfoUrl");
            String note = (String) commodityInfoMap.get("note");
            boolean show = false;
            if (commodityInfoMap.containsKey("show"))
                show = (boolean) commodityInfoMap.get("show");
            boolean sendByUser = false;
            if (commodityInfoMap.containsKey("sendByUser"))
                sendByUser = (boolean) commodityInfoMap.get("sendByUser");

            productDetail = new ProductDetail.Builder()
                    .setTitle(commodityInfoTitle)
                    .setDesc(commodityInfoDesc)
                    .setPicture(pictureUrl)
                    .setUrl(commodityInfoUrl)
                    .setNote(note)
                    .setShow(show ? 1 : 0)
                    .setSendByUser(sendByUser)
                    .build();
        }

        String sessionTitle = call.argument("sessionTitle");
        long groupId = (int) call.argument("groupId");
        long staffId = (int) call.argument("staffId");
        long robotId = (int) call.argument("robotId");
        boolean robotFirst = false;
        if (call.hasArgument("robotFirst"))
            robotFirst = (boolean) call.argument("robotFirst");
        long faqTemplateId = (int) call.argument("faqTemplateId");
        int vipLevel = (int) call.argument("vipLevel");
        boolean showQuitQueue = false;
        if (call.hasArgument("showQuitQueue"))
            call.argument("showQuitQueue");
        boolean showCloseSessionEntry = false;
        if (call.hasArgument("showCloseSessionEntry"))
            call.argument("showCloseSessionEntry");

        // 启动聊天界面
        ConsultSource source = new ConsultSource(sourceUrl, sourceTitle, sourceCustomInfo);
        source.productDetail = productDetail;
        source.groupId = groupId;
        source.staffId = staffId;
        source.robotId = robotId;
        source.robotFirst = robotFirst;
        source.faqGroupId = faqTemplateId;
        source.vipLevel = vipLevel;
        source.sessionLifeCycleOptions = new SessionLifeCycleOptions();
        source.sessionLifeCycleOptions.setCanQuitQueue(showQuitQueue);
        source.sessionLifeCycleOptions.setCanCloseSession(showCloseSessionEntry);
        Unicorn.openServiceActivity(context, sessionTitle, source);
    }

    private void setCustomUIConfig(MethodCall call) {
        // 会话窗口上方提示条中的文本字体颜色
        String sessionTipTextColor = call.argument("sessionTipTextColor");
        // 会话窗口上方提示条中的文本字体大小
        int sessionTipTextFontSize = call.argument("sessionTipTextFontSize");
        // 访客文本消息字体颜色
        String customMessageTextColor = call.argument("customMessageTextColor");
        // 客服文本消息字体颜色
        String serviceMessageTextColor = call.argument("serviceMessageTextColor");
        // 消息文本消息字体大小
        int messageTextFontSize = call.argument("messageTextFontSize");
        // 提示文本消息字体颜色
        String tipMessageTextColor = call.argument("tipMessageTextColor");
        // 提示文本消息字体大小
        int tipMessageTextFontSize = call.argument("tipMessageTextFontSize");
        // 输入框文本消息字体颜色
        String inputTextColor = call.argument("inputTextColor");
        // 输入框文本消息字体大小
        int inputTextFontSize = call.argument("inputTextFontSize");
        // 客服聊天窗口背景图片
        String sessionBackgroundImage = call.argument("sessionBackgroundImage");
        // 会话窗口上方提示条中的背景颜色
        String sessionTipBackgroundColor = call.argument("sessionTipBackgroundColor");
        // 访客头像
        String customerHeadImage = call.argument("customerHeadImage");
        // 客服头像
        String serviceHeadImage = call.argument("serviceHeadImage");
        // 消息竖直方向间距
        float sessionMessageSpacing = (float) call.argument("sessionMessageSpacing");
        // 是否显示头像
        boolean showHeadImage = true;
        if (call.hasArgument("showHeadImage"))
            showHeadImage = call.argument("showHeadImage");
        // 显示发送语音入口，设置为false，可以修改为隐藏
        boolean showAudioEntry = true;
        if (call.hasArgument("showAudioEntry"))
            showAudioEntry = call.argument("showAudioEntry");
        // 显示发送表情入口，设置为false，可以修改为隐藏
        boolean showEmoticonEntry = true;
        if (call.hasArgument("showEmoticonEntry")) call.argument("showEmoticonEntry");
        // 进入聊天界面，是文本输入模式的话，会弹出键盘，设置为false，可以修改为不弹出
        boolean autoShowKeyboard = true;
        if (call.hasArgument("autoShowKeyboard ")) call.argument("autoShowKeyboard ");

        UICustomization uiCustomization = ysfOptions.uiCustomization;
        if (uiCustomization == null) {
            uiCustomization = ysfOptions.uiCustomization = new UICustomization();
        }
        uiCustomization.topTipBarTextColor = QiYuUtils.parseColor(sessionTipTextColor);
        uiCustomization.topTipBarTextSize = sessionTipTextFontSize;
        uiCustomization.textMsgColorRight = QiYuUtils.parseColor(customMessageTextColor);
        uiCustomization.textMsgColorLeft = QiYuUtils.parseColor(serviceMessageTextColor);
        uiCustomization.textMsgSize = messageTextFontSize;
        uiCustomization.tipsTextColor = QiYuUtils.parseColor(tipMessageTextColor);
        uiCustomization.tipsTextSize = tipMessageTextFontSize;
        uiCustomization.inputTextColor = QiYuUtils.parseColor(inputTextColor);
        uiCustomization.inputTextSize = inputTextFontSize;
        uiCustomization.msgBackgroundUri = QiYuUtils.getImageUri(this.context, sessionBackgroundImage);
        uiCustomization.topTipBarBackgroundColor = QiYuUtils.parseColor(sessionTipBackgroundColor);
        uiCustomization.rightAvatar = QiYuUtils.getImageUri(this.context, customerHeadImage);
        uiCustomization.leftAvatar = QiYuUtils.getImageUri(this.context, serviceHeadImage);
        uiCustomization.msgListViewDividerHeight = (int) sessionMessageSpacing;
        uiCustomization.hideLeftAvatar = !showHeadImage;
        uiCustomization.hideRightAvatar = !showHeadImage;
        uiCustomization.hideAudio = !showAudioEntry;
        uiCustomization.hideEmoji = !showEmoticonEntry;
        uiCustomization.hideKeyboardOnEnterConsult = !autoShowKeyboard;
    }

    private void getUnreadCount(MethodCall call, Result result) {
        int count = Unicorn.getUnreadCount();

        result.success(count);
    }

    private void setUserInfo(MethodCall call) {
        String userId = call.argument("userId");
        String data = call.argument("data");
        YSFUserInfo userInfo = new YSFUserInfo();
        userInfo.userId = userId;
        userInfo.data = data;
        Unicorn.setUserInfo(userInfo, new RequestCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                Log.d("FLUTTER_QIYU", "SUCCESS");
            }

            @Override
            public void onFailed(int i) {
                Log.d("FLUTTER_QIYU", "I");
            }

            @Override
            public void onException(Throwable throwable) {


            }
        });
    }

    private void logout() {
        Unicorn.setUserInfo(null);
    }

    private void cleanCache() {
        Unicorn.clearCache();
    }

    private void setupChannel(BinaryMessenger messenger, Context context) {
        this.context = context;
        this.channel = new MethodChannel(messenger, CHANNEL_NAME);
        this.channel.setMethodCallHandler(this);
    }

    private void teardownChannel() {
        this.channel.setMethodCallHandler(null);
        this.channel = null;
    }
}
