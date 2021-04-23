//
//  SetUp.h
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#ifndef SetUp_h
#define SetUp_h

//友盟统计appkey
#define APPKEY @"5f9f69ea45b2b751a920c0d1"

//默认主题
#define Default_Theme HXThemeBlue  //蓝色

//#define     BaseUrl      @"https://testmd.hlw-study.com"


#pragma mark- ——————————————————--——————————— APP版本定义Begain ———--——————————————————————————

///////////////////////// 提交App Store 审核时需要修改的内容 ////////////////////////
#define     kHXReleaseEdition       0     //生产版本
#define     kHXDevelopOPEdition     1     //开发OP版本
#define     kHXDevelopMDEdition     2     //开发MD版本
#define     kHXChangeEdition        100   //支持切换服务器

#define      kHXAPPEdition          kHXChangeEdition

#if (kHXAPPEdition == kHXChangeEdition)
#define    kHXCanChangeServer       1   //长按切换登陆界面logo，切换服务器地址，双击自定义输入地址，便于开发调试
#endif

//默认域名
#if TARGET_IPHONE_SIMULATOR//模拟器
#define     ReleaseServer        @"http://demo.hlw-study.com"
#define     DevelopOPServer      @"http://testop.edu-cj.com"
#define     DevelopMDServer      @"http://testmd.hlw-study.com"
#else//真机
#define     ReleasServer         @"https://demo.hlw-study.com"
#define     DevelopOPServer      @"https://testop.edu-cj.com"
#define     DevelopMDServer      @"https://testmd.hlw-study.com"
#endif


#define     KP_SERVER_KEY         @"_KHX_URL_MAIN__"

#if kHXCanChangeServer

#define kHXChangeServer      ([HXCommonUtil isNull:KHXUserDefaultsForValue(KP_SERVER_KEY)] ? DevelopOPServer : KHXUserDefaultsForValue(KP_SERVER_KEY))

#endif


#if (kHXAPPEdition == kHXReleaseEdition)// 线上生产环境服务器地址
#  define     KHX_URL_MAIN      ReleasServer
#elif (kKPAPPEditio == kHXDevelopOPEdition)
#  define     KHX_URL_MAIN      DevelopOPServer
#elif (kKPAPPEdition == kHXDevelopMDEdition)
#  define     KHX_URL_MAIN      DevelopMDServer
#else
#  define     KHX_URL_MAIN      kHXChangeServer
#endif

#pragma mark- ——————————————————--——————————— APP版本定义End ———--——————————————————————————


//更新地址
#define APP_URL @"https://app.edu-edu.com.cn/minedu/ios/minedu.json"

//用户隐私政策网址
#define APP_PrivacyPolicy_URL @"https://testop.edu-cj.com/privacy.html"

#endif /* SetUp_h */


