//
//  HXDefines.h
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#ifndef HXDefines_h
#define HXDefines_h

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

#endif /* HXDefines_h */
