//
//  HXBaseURLSessionManager.m
//  HXCloudClass
//
//  Created by Mac on 2020/6/19.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import "HXBaseURLSessionManager.h"
#import "HXCheckUpdateTool.h"

@implementation HXBaseURLSessionManager

+ (instancetype)sharedClient {
    
    static HXBaseURLSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HXBaseURLSessionManager alloc] initWithBaseURL:[NSURL URLWithString:KHX_URL_MAIN]];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        //请求头设置
        NSString *version = [NSString stringWithFormat:@"%@_%@",kPlatformName,APP_BUILDVERSION];
        [_sharedClient.requestSerializer  setValue:version forHTTPHeaderField:@"Version"];
        _sharedClient.requestSerializer.timeoutInterval = 10;
       
    });
    
#if kHXCanChangeServer
    //手动设置baseUrl
    [_sharedClient setValue:[NSURL URLWithString:KHX_URL_MAIN] forKey:NSStringFromSelector(@selector(baseURL))];
#endif
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
                   success : (void (^)(NSDictionary* dictionary))success
                   failure : (void (^)(NSString *message))failure
{
    HXBaseURLSessionManager *client = [HXBaseURLSessionManager sharedClient];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:userName forKey:@"username"];
    [parameters setObject:pwd forKey:@"password"];
   
    
    [client POST:HXPOST_LOGIN parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dictionary) {
        
        NSLog(@"请求地址:%@",task.currentRequest.URL);
        NSLog(@"请求参数:%@",parameters);
        if(dictionary){
            NSString*statusCode = [dictionary stringValueForKey:@"StatusCode"];
            NSString*message = [dictionary stringValueForKey:@"Message"];
            if ([statusCode isEqualToString:@"1000"]) {//StatusCode 1000登录失败，1001登录成功
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message completionBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGIN object:nil];
                }];
            }else if([statusCode isEqualToString:@"999"]){//999 强制更新
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message completionBlock:^{
                    [[HXCheckUpdateTool sharedInstance] checkUpdate];
                }];
            }else if(![dictionary boolValueForKey:@"Success"] ){
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message];
            }
            NSDictionary *data = [dictionary dictionaryValueForKey:@"Data"];
            NSString *personId = [data objectForKey:@"personId"];
            [HXPublicParamTool sharedInstance].personId = personId;
            success(dictionary);
        }else{
            failure(nil);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求地址:%@",task.currentRequest.URL);
        NSLog(@"请求参数:%@",parameters);
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
        NSLog(@"请求地址:%@",task.currentRequest.URL);
        NSLog(@"请求参数:%@",parameters);
        if(dictionary){
            NSString*statusCode = [dictionary stringValueForKey:@"StatusCode"];
            NSString*message = [dictionary stringValueForKey:@"Message"];
            if ([statusCode isEqualToString:@"1000"]) {//StatusCode 1000登录失败，1001登录成功
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message completionBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGIN object:nil];
                }];
            }else if([statusCode isEqualToString:@"999"]){//999 强制更新
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message completionBlock:^{
                    [[HXCheckUpdateTool sharedInstance] checkUpdate];
                }];

            }else if(![dictionary boolValueForKey:@"Success"] ){
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message];
            }
            success(dictionary);
        }else{
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求地址:%@",task.currentRequest.URL);
        NSLog(@"请求参数:%@",parameters);
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        NSLog(@"接口错误信息%@",response);
        failure(error);
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
        
        NSLog(@"请求地址:%@",task.currentRequest.URL);
        NSLog(@"请求参数:%@",parameters);
        NSString*statusCode = [dictionary stringValueForKey:@"StatusCode"];
        NSString*message = [dictionary stringValueForKey:@"Message"];

        if(dictionary){
            if ([statusCode isEqualToString:@"1000"]) {
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message completionBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGIN object:nil];
                }];
            }else if([statusCode isEqualToString:@"999"]){//强制更新
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message completionBlock:^{
                    [[HXCheckUpdateTool sharedInstance] checkUpdate];
                }];
            }else if(![dictionary boolValueForKey:@"Success"] ){
                [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:message];
            }
            success(dictionary);
        }else{
            failure(nil);
        }
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求地址:%@",task.currentRequest.URL);
        NSLog(@"请求参数:%@",parameters);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        NSLog(@"接口错误信息%@",response);
        failure(error);
    }];
}

+ (void)doLogout{
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_QUITE withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        //
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            NSLog(@"退出登录成功！");
        }else{
            NSLog(@"退出登录失败！");
        }
    } failure:^(NSError * _Nonnull error) {
        //
        NSLog(@"退出登录失败！");
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
