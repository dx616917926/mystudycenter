//
//  AppDelegate.m
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import "HXLoginViewController.h"
#import "HXNewFeatureViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self firstEnterHandle];
    
    [self setUMengTrack];
    
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //关闭网络监控
//    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //检测新版本
//    if (!donotCheckVersionAgain) {
//        [self checkAppUpdate];
//    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //开启网络监控
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//
//    isFirstLaunch = NO;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark – private function

/**
 * 通过比较上次使用的版本进行判断，是否是第一次使用这个版本
 * 如果是第一次使用则开启轮播图，如果不是正常进入root controller
 */
- (void)firstEnterHandle {
    //如何知道是否是第一次使用这个版本？可以通过比较上次使用的版本进行判断
    NSString *versionKey = @"CFBundleShortVersionString";
    //从沙盒中取出上次存储的软件版本号（取出用户上次的使用记录）
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    //获得当前打开软件的版本号
    NSString *currentVersion = kCurrentVersion;

    if ([currentVersion isEqualToString:lastVersion]) {
        if ([HXPublicParamTool sharedInstance].isLogin) {
            [self.window setRootViewController:self.tabBarController];
        }else{
            HXLoginViewController * loginVC = [[HXLoginViewController alloc]init];
            loginVC.sc_navigationBarHidden = YES;
            HXNavigationController *navVC = [[HXNavigationController alloc] initWithRootViewController:loginVC];
            [self.window setRootViewController:navVC];
        }
    }else{//当前版本号 != 上次使用的版本号：显示新版本的特性
        self.window.rootViewController = [[HXNewFeatureViewController alloc]init];
        //存储这个使用的软件版本
        [defaults setObject:currentVersion forKey:versionKey];
        //立刻写入
        [defaults synchronize];
    }
}

- (HXTabBarController *)tabBarController {
    
    if (!_tabBarController) {
        _tabBarController = [[HXTabBarController alloc] init];
    }
    
    return _tabBarController;
    
}

@end
