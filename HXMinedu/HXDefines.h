//
//  HXDefines.h
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#ifndef HXDefines_h
#define HXDefines_h

#define SHOWLOGIN @"HXShowLoginVC"
#define LOGINSUCCESS @"HXLoginSuccess"
#define NeedReAuthorize @"HXNeedReAuthorize"
///报考类型专业改变通知
#define VersionAndMajorChangeNotification    @"VersionAndMajorChangeNotification"


#define NETWORK_AVAILIABLE ([[AFNetworkReachabilityManager sharedManager] isReachable])
#define NETWORK_ViaWWAN    ([[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN])
#define NETWORK_ViaWiFi    ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi])

//判断是否是刘海屏
#define IS_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

//非DEBUG模式不打印日志⚠️
#ifndef DEBUG
#define NSLog(...)
#endif

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IsIOS14 ({BOOL isIOS14 = NO; if(@available(iOS 14.0, *)){isIOS14 = YES;}(isIOS14);})

//当前版本号
#define kCurrentVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])


#pragma mark - 新版新定义的常用宏

///弱引用和强引用
#define WeakSelf(weakSelf)      __weak __typeof(&*self)     weakSelf  = self;
#define StrongSelf(strongSelf)  __strong __typeof(&*self)   strongSelf = weakSelf;

///字符串保护
#define HXSafeString(__string_) ([__string_ isKindOfClass:[NSNull class]] ? @"" : (__string_ ? __string_ : @""))

///自定义颜色
#define COLOR_WITH_ALPHA(colorValue, alphaValue) [UIColor colorWithRed:((float)((colorValue & 0xFF0000) >> 16))/255.0 green:((float)((colorValue & 0xFF00) >> 8))/255.0 blue:((float)(colorValue & 0xFF))/255.0 alpha:alphaValue]

//自定义字体
#define HXFont(fontSize)      [UIFont systemFontOfSize:fontSize];
#define HXBoldFont(fontSize)  [UIFont boldSystemFontOfSize:fontSize];


// 美工的标准375
#define _kpw(__width_) ([UIScreen mainScreen].bounds.size.width * (__width_) / 375.0)
// 美工的标准667
#define _kph(__height_) ([UIScreen mainScreen].bounds.size.height * (__height_) / 667.0)
// 根据屏幕宽度适配字体大小
#define _kpAdaptationWidthFont(__font_) ([UIScreen mainScreen].bounds.size.width * (__font_) / 375.0)
// 根据高度度适配字体大小
#define _kpAdaptationHeightFont(__font_) ([[UIScreen mainScreen].bounds.size.height * (__font_) / 667.0)



#endif /* HXDefines_h */
