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


#define     KP_SERVER_KEY         @"_KHX_URL_MAIN__"

#pragma mark- ——————————————————--——————————— APP版本定义Begain ———--——————————————————————————

///////////////////////// 提交App Store 审核时需要修改的内容 ////////////////////////
#define     kHXReleaseEdition       0     //生产版本
#define     kHXDevelopOPEdition     1     //开发OP版本
#define     kHXDevelopMDEdition     2     //开发MD版本
#define     kHXDevelopLWJEdition    3     //李文军主机
#define     kHXChangeEdition        100   //支持切换服务器(长按登陆界面logo，切换服务器地址，双击自定义输入地址，便于开发调试)

#define     kHXAPPEdition          kHXChangeEdition

#if (kHXAPPEdition == kHXChangeEdition)
#define    kHXCanChangeServer       1   //长按切换登陆界面logo，切换服务器地址，双击自定义输入地址，便于开发调试
#endif

//域名定义
#define     kHXReleasServer         @"https://demo.hlw-study.com"
#define     kHXDevelopOPServer      @"https://testop.edu-cj.com"
#define     kHXDevelopMDServer      @"https://testmd.hlw-study.com"
#define     kHXDevelopLWJEServer    @"http://192.168.1.131:85" //李文军主机

#if kHXCanChangeServer
#define kHXChangeServer      ([HXCommonUtil isNull:KHXUserDefaultsForValue(KP_SERVER_KEY)] ? kHXDevelopMDServer : KHXUserDefaultsForValue(KP_SERVER_KEY))
#endif


#if (kHXAPPEdition == kHXReleaseEdition)
#   define     KHX_URL_MAIN      kHXReleasServer  // 正式环境服务器地址
static BOOL PRODUCTIONMODE  =   YES;             //APNs 证书类型，NO开发证书，YES生产证书
#elif (kHXAPPEdition == kHXDevelopOPEdition)
#   define     KHX_URL_MAIN      kHXDevelopOPServer
static BOOL PRODUCTIONMODE  =   NO;
#elif (kHXAPPEdition == kHXDevelopMDEdition)
#   define     KHX_URL_MAIN      kHXDevelopMDServer
static BOOL PRODUCTIONMODE  =   NO;
#elif (kHXAPPEdition == kHXDevelopLWJEdition)
#   define     KHX_URL_MAIN      kHXDevelopLWJEServer
static BOOL PRODUCTIONMODE  =   NO;
#else
#   define     KHX_URL_MAIN      kHXChangeServer
static BOOL  PRODUCTIONMODE  =  NO;
#endif



//更新地址
#define APP_URL @"https://app.edu-edu.com.cn/minedu/ios/minedu.json"

//用户隐私政策网址
#define APP_PrivacyPolicy_URL @"https://testop.edu-cj.com/privacy.html"

#endif /* SetUp_h */


