//
//  AppDelegate.m
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "HXLoginViewController.h"
#import "HXIntroViewManager.h"
#import "HXCheckUpdateTool.h"
#import "IQKeyboardManager.h"
#import "WXApi.h"
#import "UIDevice+HXDevice.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef IOS10Later
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>
@property(nonatomic, strong) NSString *registrationID;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self firstEnterHandle];
    //第三方配置
    [self thirdPartyConfiguration:launchOptions ];
    
#if !TARGET_OS_SIMULATOR
    //检测当前程序运行的环境变量，防止通过DYLD_INSERT_LIBRARIES注入链接异常动态库，来更改相关工具名称
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if(env) {
        exit(0);
    }
#endif
    
    //检查更新
    [self checkAppUpdate];
    
    //推送内容获取：
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {//点击通知启动
        NSLog(@"点击通知启动");
        NSString *title = remoteNotification[@"aps"][@"alert"][@"title"];
        NSString *content = remoteNotification[@"aps"][@"alert"][@"body"];
        [self alertTitle:title content:content isLaunch:NO];
    }else{
        NSLog(@"点击应用图标通知启动");
    }
    
   
    
    return YES;
}

- (JPUSHRegisterEntity *)pushRegisterEntity {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
      entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
      entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        if (@available(iOS 10.0, *)) {
//          NSSet<UNNotificationCategory *> *categories;
//          entity.categories = categories;
//        }else {
//          NSSet<UIUserNotificationCategory *> *categories;
//          entity.categories = categories;
//        }
//      }
    return entity;
}

#pragma mark -第三方配置
- (void)thirdPartyConfiguration:(NSDictionary *)launchOptions  {

    /*******************************************极光推送配置****************************************/
    //只有在前端运行的时候才能收到自定义消息的推送。从JPush服务器获取用户推送的自定义消息内容和标题以及附加字段等。
    [HXNotificationCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //【注册通知】通知回调代理（可选）
    [JPUSHService registerForRemoteNotificationConfig:[self pushRegisterEntity] delegate:self];
    //【初始化sdk】如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY
                          channel:@""
                 apsForProduction:PRODUCTIONMODE
            advertisingIdentifier:nil];
    
    /*集成了 JPush SDK 的应用程序在第一次成功注册到 JPush 服务器时，JPush 服务器会给客户端返回一个唯一的该设备的标识 - RegistrationID。JPush SDK 会以广播的形式发送 RegistrationID 到应用程序。
     应用程序可以把此 RegistrationID 保存以自己的应用服务器上，然后就可以根据 RegistrationID 来向设备推送消息或者通知
     */
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            self.registrationID = registrationID;
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    /*******************************************极光推送配置****************************************/
    
    ///友盟配置
    [UMConfigure initWithAppkey:APPKEY channel:@"fir"];
    [UMConfigure setEncryptEnabled:YES];
    
#ifdef DEBUG
    //测试环境
    [UMConfigure setLogEnabled:YES];
#else
    //正式环境
    [UMConfigure setLogEnabled:NO];
#endif
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //判断设备是否越狱，依据是否存在apt和Cydia.app
        //判断App是否被破解
        if ([MobClick isJailbroken] || [MobClick isPirated]) {
            exit(0);
        }
    });
    
    //崩溃回调
    [UMCrashConfigure setCrashCBBlock:^NSString * _Nullable{
        
        NSString* deviceModel = [[UIDevice currentDevice] deviceModelName];//手机型号
        NSString *str = [NSString stringWithFormat:@"%@\n%@",deviceModel,[HXPublicParamTool sharedInstance].username];
        return str;
    }];
    
#if 0
    //微信配置
#ifdef DEBUG
    //在register之前打开log, 后续可以根据log排查问题
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
        NSLog(@"WeChatSDK: %@", log);
    }];
#endif
    //向微信注册
    [WXApi registerApp:kHXWechatOpenKey universalLink:UNIVERSAL_LINK];
    
    if (!PRODUCTIONMODE) {
        //调用自检函数,仅用于新接入SDK时调试使用，请勿在正式环境的调用
        [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
            NSLog(@"自检函数:%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
        }];
    }
#endif
    
    ///键盘（IQKeyboardManager）全局管理，针对键盘遮挡问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.enableAutoToolbar = NO;///是否显示键盘上方工具条
    manager.shouldResignOnTouchOutside = YES;///是否点击空白区域收起键盘
    manager.keyboardDistanceFromTextField = IS_iPhoneX?30:20;/// 键盘距离文本输入框距离
    
}

/// 检查更新
- (void)checkAppUpdate {
    
    [[HXCheckUpdateTool sharedInstance] checkUpdate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //关闭网络监控
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    //重置脚标(为0)
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //重置脚标(为0)
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    //检测新版本
    [self checkAppUpdate];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //开启网络监控
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //    isFirstLaunch = NO;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"杀掉App进程！！！！");
}

#pragma mark – private function

/**
 * 判断是否登录、是否需要显示引导页
 */
- (void)firstEnterHandle {
    
    if ([HXPublicParamTool sharedInstance].isLogin) {
        [self.window setRootViewController:self.tabBarController];
    }else{
        HXLoginViewController * loginVC = [[HXLoginViewController alloc]init];
        loginVC.sc_navigationBarHidden = YES;
        HXNavigationController *navVC = [[HXNavigationController alloc] initWithRootViewController:loginVC];
        [self.window setRootViewController:navVC];
    }
    
    [self.window makeKeyAndVisible];
    
    //是否需要显示引导页
    [[HXIntroViewManager sharedInstance] checkAndShowIntroViewInView:self.window];
}

- (HXTabBarController *)tabBarController {
    
    if (!_tabBarController) {
        _tabBarController = [[HXTabBarController alloc] init];
    }
    return _tabBarController;
}




#pragma mark - <UIApplicationDelegate>
//低于iOS 13版本，微信处理通用链接，会走此回调
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    if ([url.host isEqualToString:@"safepay"]) {//  判断一下这个host，safepay就是支付宝的
        NSString * urlNeedJsonStr = url.absoluteString;
        NSArray * afterComStr = [urlNeedJsonStr componentsSeparatedByString:@"?"];
        //  这个decode方法，在上面找哈
        NSString * lastStr = [HXCommonUtil strDecodedString:afterComStr.lastObject];
        //  这个lastStr，其实是一个jsonStr，转一下，就看到了数据
        NSDictionary * resultDict = [self  dictionaryWithJsonString:lastStr];
        //  和支付宝SDK的返回结果一次，这个ResultStatus，就是我们要的数据
        //  9000 ：支付成功
        //  8000 ：订单处理中
        //  4000 ：订单支付失败
        //  6001 ：用户中途取消
        //  6002 ：网络连接出错
        //  这里的话，就可以根据状态，去处理自己的业务了
        NSLog(@"%@",resultDict);
    }else if ([url.absoluteString rangeOfString:@"www.edu-edu.com"].location != NSNotFound) {//微信支付
        //此处发送通知，哪里需要接受通知处理，哪里就接受
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatH5PayNotification" object:url.absoluteString];
    }else if ([url.scheme rangeOfString:kHXWechatOpenKey].length!=0) {////低于iOS 13版本，这里处理通用链接回调
        NSLog(@"再次跳回。。。");
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

//iOS 13以上版本，微信处理通用链接，会走此回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable
                                                                                                                                 restorableObjects))restorationHandler {
    
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webUrl = userActivity.webpageURL;
        NSLog(@"continueUserActivity:%@",webUrl);
    }
    
    //处理通用链接
    //当APP被UniversalLink调起后，
    BOOL ret = [WXApi handleOpenUniversalLink:userActivity delegate:self];
    NSLog(@"处理微信通过Universal Link启动App时传递的数据:%d",ret);
    return ret;
}

#pragma mark - 通知注册
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
        NSLog(@"从通知界面直接进入应用");
    }else{
        //
        NSLog(@"从通知设置界面进入应用");
    }
    
}
#ifdef IOS10Later
//App状态为正在前台 iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程通知
        [JPUSHService handleRemoteNotification:userInfo];
    }else{
        // 本地通知
    }
    /// 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    if (@available(iOS 14.0, *)) {
        completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner);
    } else {
        if (@available(iOS 10.0, *)) {
            completionHandler(UNNotificationPresentationOptionAlert);
        } else {
            [self alertTitle:title content:body isLaunch:NO];
        }
    }
    
    
}

//点击通知栏的通知消息 iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程通知
        [JPUSHService handleRemoteNotification:userInfo];
    }else{
        // 本地通知
    }
    completionHandler();  // 系统要求执行这个方法
    [self alertTitle:title content:body isLaunch:NO];
}

#endif

// Required, iOS 7 Support
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

//自定义消息,实现回调方法 networkDidReceiveMessage
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    [self alertTitle:title content:content isLaunch:NO];
}



#pragma mark - <WXApiDelegate>
//收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
- (void)onReq:(BaseReq*)req
{
    NSLog(@"微信请求App提供内容onReq:%@",req);
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        //        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        NSLog(@"%@ %@",strTitle,strMsg);
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        NSLog(@"%@ %@",strTitle,strMsg);
    }
}

//收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
- (void)onResp:(BaseResp *)resp {
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    //微信支付的类
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        if (resp.errCode == 0) {
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            
        }else{
            strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            
        }
        
    }
    
    //微信登录的类
    if([resp isKindOfClass:[SendAuthResp class]]){
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            
        }
    }
    
    //微信分享的类
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        if (resp.errCode == 0) {//成功。
            //这里处理回调的方法
            
        }else{ //失败
            
        }
    }
}




-  (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)alertTitle:(NSString *)title content:(NSString *)content isLaunch:(BOOL)isLaunch{
   
    
    if (!isLaunch) {// 后台或者前台时给出提示弹窗
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:okAction];
//        [alertVC addAction:cancelAction];
        [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
        }else{// 如果是打开APP，则直接跳转
            
        }
}


@end
