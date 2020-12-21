//
//  HXBaseURLSessionManager.h
//  HXCloudClass
//
//  Created by Mac on 2020/6/19.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

#define HXGET_TOKEN       @"/api/ApiLogin/Login"         //获取token

#define HXPOST_LOGIN       @"/MD/LoginInfo/Login"        //登录
#define HXPOST_LIVELIST    @"/MD/Live/getLiveList"       //直播地址


#define HXGET_FINDPASS    @"/api/v1/findPass"            //找回密码得到邮箱地址
#define HXGET_SENDEMAIL   @"/api/v1/sendEmail"           //发送邮件
#define HXGET_LISTYEAR    @"/api/v1/listYear"            //学习中心首页
#define HXGET_COURSELIST  @"/api/v1/courseWareList"      //课程列表
#define HXGET_EXAMDATA    @"/api/v1/getExamData"         //获取考试数据

@interface HXBaseURLSessionManager : AFHTTPSessionManager

/**
 @return HXBaseURLSessionManager
 */
+ (instancetype)sharedClient;

- (void)clearCookies;

/**
 登录请求
 */
+ (void)doLoginWithUserName:(NSString *)userName
                andPassword:(NSString *)pwd
                    success:(void (^)(NSString *personId))success
                    failure:(void (^)(NSString *messsage))failure;

/**
 普通GET请求
 */
+ (void)getDataWithNSString:(NSString *)actionUrlStr
             withDictionary:(nullable NSDictionary *) nsDic
                    success:(void (^)(NSDictionary* dictionary))success
                    failure:(void (^)(NSError *error))failure;

/**
 普通POST请求
 */
+ (void)postDataWithNSString:(NSString *)actionUrlStr
              withDictionary:(nullable NSDictionary *) nsDic
                     success:(void (^)(NSDictionary* dictionary))success
                     failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
