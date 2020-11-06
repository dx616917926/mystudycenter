//
//  HXBaseURLSessionManager.m
//  HXCloudClass
//
//  Created by Mac on 2020/6/19.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import "HXBaseURLSessionManager.h"
#import "NSString+md5.h"
#import <UTDID/UTDevice.h>

@implementation HXBaseURLSessionManager

+ (instancetype)sharedClient {
    
    static HXBaseURLSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HXBaseURLSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        _sharedClient.requestSerializer.timeoutInterval = 10;
    });
    
    return _sharedClient;
}

-(void)clearCookies
{
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie* cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

+ (void)getDataWithNSString : (NSString *)actionUrlStr
             withDictionary : (NSDictionary *) nsDic
                    success : (void (^)(NSDictionary* dictionary))success
                    failure : (void (^)(NSError *error))failure
{

    HXBaseURLSessionManager * client = [HXBaseURLSessionManager sharedClient];
    
    NSMutableDictionary * parameters = [client commonParameters];
    
    [parameters addEntriesFromDictionary:nsDic];
    
    [client GET:actionUrlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dictionary) {
        if(dictionary)
        {
            if ([dictionary  isKindOfClass:[NSNull class]] && [[dictionary objectForKey:@"statusCode"] isEqualToString:@"401"]) {
                failure(nil);
                NSLog(@"登录信息已经过期 请重新登录");
//                [[KQPublicParamTool sharedInstance] exitAction:KQPublicParamToolExitActionTypeExpired];
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"授权过期，请重新登录！"];
            }else
            {
                success(dictionary);
            }
        }else
        {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        if (response.statusCode == 401) {
//            [[KQPublicParamTool sharedInstance] exitAction:KQPublicParamToolExitActionTypeExpired];
            [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"授权过期，请重新登录！"];
            failure(nil);
        }else{
            failure(error);
        }
    }];
}

+ (void)postDataWithNSString : (NSString *)actionUrlStr
              withDictionary : (NSDictionary *) nsDic
                     success : (void (^)(NSDictionary* dictionary))success
                     failure : (void (^)(NSError *error))failure
{
    HXBaseURLSessionManager * client = [HXBaseURLSessionManager sharedClient];
    
    NSMutableDictionary * parameters = [client commonParameters];
    
    [parameters addEntriesFromDictionary:nsDic];
    
    [client POST:actionUrlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dictionary) {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        if (response.statusCode == 401) {
//            [[KQPublicParamTool sharedInstance] exitAction:KQPublicParamToolExitActionTypeExpired];
            [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"授权过期，请重新登录！"];
        }else{
            if(dictionary)
            {
                if ([dictionary[@"success"] isEqualToString:@"False"] && [dictionary[@"message"] isEqualToString:@"账号处理离线状态"]) {
                    failure(nil);
                    NSLog(@"登录信息已经过期 请重新登录");
//                    [[KQPublicParamTool sharedInstance] exitAction:KQPublicParamToolExitActionTypeExpired];
                    [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"授权过期，请重新登录！"];
                }else
                {
                    success(dictionary);
                }
            }else
            {
                success(nil);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        if (response.statusCode == 401) {
            failure(nil);
            
//            [[KQPublicParamTool sharedInstance] exitAction:KQPublicParamToolExitActionTypeExpired];

            [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"授权过期，请重新登录！"];
        }else{
            failure(error);

        }
    }];
}

/// 公共请求参数
- (NSMutableDictionary *)commonParameters{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    NSString *UDID = [UTDevice utdid];
    if (UDID) {
        parameters[@"uniqueId"] = UDID;
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timestamp= [NSString stringWithFormat:@"%.f",time];
    parameters[@"timestamp"] = timestamp;
    
    return parameters;
}


@end
