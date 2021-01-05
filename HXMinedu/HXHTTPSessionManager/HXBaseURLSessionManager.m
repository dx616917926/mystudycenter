//
//  HXBaseURLSessionManager.m
//  HXCloudClass
//
//  Created by Mac on 2020/6/19.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import "HXBaseURLSessionManager.h"

@implementation HXBaseURLSessionManager

+ (instancetype)sharedClient {
    
    static HXBaseURLSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HXBaseURLSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
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

+ (void)doLoginWithUserName:(NSString *)userName
                andPassword:(NSString *)pwd
                   success : (void (^)(NSString *personId))success
                   failure : (void (^)(NSString *message))failure
{
    HXBaseURLSessionManager * client = [HXBaseURLSessionManager sharedClient];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userName forKey:@"username"];
    [parameters setObject:pwd forKey:@"password"];
    
    [client POST:HXPOST_LOGIN parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dictionary) {
        
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        
        if (Success) {
            
            NSDictionary *data = [dictionary dictionaryValueForKey:@"Data"];
            
            NSString *personId = [data stringValueForKey:@"personId"];
            
            [HXPublicParamTool sharedInstance].personId = personId;
            
            success(personId);
            
        }else
        {
            failure([dictionary stringValueForKey:@"Message"]);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取personId失败！");
        failure(error.localizedDescription);
    }];
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
            success(dictionary);
        }else
        {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        if (response.statusCode == 401) {
            failure(nil);
            [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"授权过期，请重新登录！" completionBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGIN object:nil];
            }];
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
        if(dictionary)
        {
            success(dictionary);
        }else
        {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        if (response.statusCode == 401) {
            failure(nil);
            [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"授权过期，请重新登录！" completionBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGIN object:nil];
            }];
        }else{
            failure(error);
        }
    }];
}

/// 公共请求参数
- (NSMutableDictionary *)commonParameters{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    NSString *personId = [HXPublicParamTool sharedInstance].personId;
    if (personId) {
        [parameters setObject:personId forKey:@"personId"];
    }
    
    return parameters;
}

@end
