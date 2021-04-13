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

//默认域名
#if TARGET_IPHONE_SIMULATOR
#define BaseUrl @"http://testop.edu-cj.com"
#else
#define BaseUrl @"https://testop.edu-cj.com"
#endif

//更新地址
#define APP_URL @"https://app.edu-edu.com.cn/minedu/ios/minedu.json"

//用户隐私政策网址
#define APP_PrivacyPolicy_URL @"https://testop.edu-cj.com/privacy.html"

#endif /* SetUp_h */
