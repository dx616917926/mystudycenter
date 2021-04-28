//
//  AppDelegate.m
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "HXLoginViewController.h"
#import "HXIntroViewManager.h"
#import "HXCheckUpdateTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self firstEnterHandle];
    
    [self setUMengTrack];
    
    //检查更新
    [self checkAppUpdate];
    
    return YES;
}

/**
 *  @author wangxuanao
 *
 *  友盟统计分析
 */
- (void)setUMengTrack {
    
    [UMConfigure initWithAppkey:APPKEY channel:@"fir"];
    [UMConfigure setEncryptEnabled:YES];
    
#ifdef DEBUG
    //测试环境
    [UMConfigure setLogEnabled:YES];
#else
    //正式环境
    [UMConfigure setLogEnabled:NO];
#endif
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
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
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


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    
    if ([url.host isEqualToString:@"safepay"]) {//  判断一下这个host，safepay就是支付宝的
        NSString * urlNeedJsonStr = url.absoluteString;
        NSArray * afterComStr = [urlNeedJsonStr componentsSeparatedByString:@"?"];
        //  这个decode方法，在上面找哈
        NSString * lastStr = [self URLDecodedString:afterComStr.lastObject];
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
    }
    
    return YES;
}

-  (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString*)URLDecodedString:(NSString*)str {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}


@end
