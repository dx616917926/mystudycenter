//
//  HXExamSessionManager.m
//  HXCloudClass
//
//  Created by Mac on 2020/8/27.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import "HXExamSessionManager.h"

@implementation HXExamSessionManager

+ (instancetype)sharedClient {
    
    static HXExamSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HXExamSessionManager alloc] init];
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

//手动设置baseURL
-(void)setBaseUrl:(NSString *)url
{
    if (url && url.length > 0) {
        NSURL *baseUrl = [NSURL URLWithString:url];
        baseUrl = [NSURL URLWithString:@"/" relativeToURL:baseUrl];
        HXExamSessionManager * client = [HXExamSessionManager sharedClient];
        [client setValue:baseUrl forKey:@"baseURL"];
    }
}

//得到baseURL
- (NSString *)baseUrlAbsoluteString
{
    NSString *url = [self.baseURL absoluteString];
    //去掉后缀的/
    url = [url substringToIndex:url.length-1];
    return url;
}

+ (void)getDataWithNSString : (NSString *)actionUrlStr
             withDictionary : (NSDictionary *) parameters
                    success : (void (^)(NSDictionary* dictionary))success
                    failure : (void (^)(NSError *error))failure
{

    HXExamSessionManager * client = [HXExamSessionManager sharedClient];
    
    [client GET:actionUrlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dictionary) {
        if(dictionary)
        {
            success(dictionary);
        }else
        {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)postDataWithNSString : (NSString *)actionUrlStr
              withDictionary : (NSDictionary *) parameters
                     success : (void (^)(NSDictionary* dictionary))success
                     failure : (void (^)(NSError *error))failure
{
    HXExamSessionManager * client = [HXExamSessionManager sharedClient];
    
    [client POST:actionUrlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dictionary) {
        if(dictionary)
        {
            success(dictionary);
        }else
        {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//用于考试数据的初始化，得到考试试卷和考试服务器的url
+ (void)getDataWithExamId:(NSString *)examid
                  success:(void (^)(NSDictionary * dic))success
                  failure:(void (^)(NSError *error))failure
{
    
    NSString *url = [NSString stringWithFormat:HXEXAM_START_JSON,examid];
    
    [self getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dictionary) {
        success(dictionary);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
