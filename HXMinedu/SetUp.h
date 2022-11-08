//
//  SetUp.h
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#ifndef SetUp_h
#define SetUp_h

//极光推送appkey
#define JPUSHAPPKEY  @"13b2c607f0752ebbaf70f8d9"

//友盟统计appkey
#define APPKEY @"5f9f69ea45b2b751a920c0d1"

//微信授权
#define kHXWechatOpenKey            @"wx4f5db3101ba7caf2"    
#define UNIVERSAL_LINK              @"https://xsjy.hlw-study.com/minedu/"

//默认主题
#define Default_Theme HXThemeBlue  //蓝色


#define     KP_SERVER_KEY         @"_KHX_URL_MAIN__"

#pragma mark- ——————————————————--——————————— APP版本定义Begain ———--——————————————————————————

///////////////////////// 提交App Store 审核时需要修改的内容 ////////////////////////

#define     kHXISFenKuLogin         1   //是否分库登录:   1:是   0:否

////获取测试分库的域名
#define     KHX_API_DevelopDomain          @"http://lwjcenter.edu-cj.com"
////获取正式分库的域名
#define     KHX_API_ReleaseDomain          @"https://midapi.hlw-study.com"

#define     KHX_API_Domain          KHX_API_ReleaseDomain

#define     kHXReleaseEdition       0     //生产版本
#define     kHXDevelopOPEdition     1     //开发OP版本
#define     kHXDevelopMDEdition     2     //开发MD版本
#define     kHXDevelopLWJEdition    3     //李文军主机
#define     kHXChangeEdition        100   //支持切换服务器(长按登陆界面logo，切换服务器地址，双击自定义输入地址，便于开发调试)

#define     kHXAPPEdition           kHXReleaseEdition

#if (kHXAPPEdition == kHXChangeEdition)
#define    kHXCanChangeServer       1   //长按切换登陆界面logo，切换服务器地址，双击自定义输入地址，便于开发调试
#endif

//域名定义
#define     kHXReleasServer         @"https://demo.hlw-study.com"
#define     kHXDevelopOPServer      @"https://lwjtest.edu-cj.com"  //http://lwjcenter.edu-cj.com
#define     kHXDevelopMDServer      @"https://testmd.hlw-study.com"
#define     kHXDevelopLWJEServer    @"http://192.168.1.131:84" //李文军主机

#if kHXCanChangeServer
#define kHXChangeServer      ([HXCommonUtil isNull:KHXUserDefaultsForValue(KP_SERVER_KEY)] ? kHXDevelopOPServer : KHXUserDefaultsForValue(KP_SERVER_KEY))
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

//APP Store更新地址
#define APPStore_URL @"https://itunes.apple.com/cn/lookup?id=1628475102"

//用户隐私政策网址
#define APP_PrivacyPolicy_URL @"https://testop.edu-cj.com/privacy.html"

#endif /* SetUp_h */


