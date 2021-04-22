//
//  HXPublicParamTool.h
//  HXCloudClass
//
//  Created by Mac on 2020/7/22.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMajorModel.h"

@interface HXPublicParamTool : NSObject

+ (instancetype)sharedInstance;

//是否登录成功
@property(nonatomic,assign) BOOL isLogin;
//是否是运行过
@property(nonatomic,assign) BOOL isLaunch;

//personId
@property (nonatomic, copy) NSString *personId;
//token
@property (nonatomic, copy) NSString *accessToken;



/******** 机构信息 **********/
// 合作机构Id
@property (nonatomic, copy) NSString *partnerId;
// 合作机构主页地址
@property (nonatomic, copy) NSString *homeUrl;
// 合作机构Logo
@property (nonatomic, copy) NSString *logoUrl;
// 合作机构名称
@property (nonatomic, copy) NSString *partnerName;
// 合作机code值
@property (nonatomic, copy) NSString *code;


/******** 登录返回信息 **********/
//currentYear
@property (nonatomic, copy) NSString *currentYear;

//accountantNoDate
@property (nonatomic, copy) NSString *accountantNoDate;
//skillGrade
@property (nonatomic, copy) NSString *skillGrade;
//userCode
@property (nonatomic, copy) NSString *userCode;
//mobilePhone
@property (nonatomic, copy) NSString *mobilePhone;
//email
@property (nonatomic, copy) NSString *email;

//用户名
@property (nonatomic, copy) NSString *username;
//头像
@property (nonatomic, copy) NSString *avatarImageUrl;
//微博用户头像
@property (nonatomic, copy) NSString *avatar_hd;
//积分
@property (nonatomic, copy) NSString *nowIntegral;
//等级
@property (nonatomic, copy) NSString *level;
//等级名称
@property (nonatomic, copy) NSString *levelName;
//个人成长值
@property (nonatomic, copy) NSString *growthValue;

//保存年份列表
@property (nonatomic, strong) NSArray *yearArray;

#pragma mark - 新增字段
//token
@property (nonatomic, copy) NSString *token;
//隐私协议url
@property (nonatomic, copy) NSString *privacyUrl;

//报考类型数组
@property (nonatomic, strong) NSArray *versionList;
@property (nonatomic, strong) HXMajorModel *selectMajorModel;
@property (nonatomic, strong) NSString *jiGouLogoUrl;

//退出登录
- (void)logOut;

@end
