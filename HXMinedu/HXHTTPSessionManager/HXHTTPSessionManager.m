//
//  HXHTTPSessionManager.m
//  gk_anhui
//
//  Created by iMac on 2016/11/16.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "HXHTTPSessionManager.h"

@implementation HXHTTPSessionManager

+ (instancetype)sharedClient {

    static HXHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HXHTTPSessionManager alloc] init];
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
        HXHTTPSessionManager * client = [HXHTTPSessionManager sharedClient];
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
             withDictionary : (NSDictionary *) nsDic
                    success : (void (^)(NSDictionary* dictionary))success
                    failure : (void (^)(NSError *error))failure
{
    HXHTTPSessionManager * client = [HXHTTPSessionManager sharedClient];
    
    [client GET:actionUrlStr parameters:nsDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        if(dictionary)
        {
            success(dictionary);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        
        if (response.statusCode == 401) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NeedReAuthorize object:nil];
        }
        
        failure(error);
    }];
}

+ (void)postDataWithNSString : (NSString *)actionUrlStr
              withDictionary : (NSDictionary *) nsDic
                     success : (void (^)(NSDictionary* dictionary))success
                     failure : (void (^)(NSError *error))failure
{
    HXHTTPSessionManager * client = [HXHTTPSessionManager sharedClient];

    [client POST:actionUrlStr parameters:nsDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        if(dictionary)
        {
            success(dictionary);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        
        if (response.statusCode == 401) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NeedReAuthorize object:nil];
        }
        
        failure(error);
    }];
}

//大视频和三分屏播放下载和提交学习记录前必须先调用此接口
+ (void)getDataWithCoursewareId:(NSString *)cid
                        success:(void (^)(NSDictionary * dic))success
                        failure:(void (^)(NSError *error))failure
{
    
    NSString *url = [NSString stringWithFormat:HXCOURESWARE_PLAY_JSON,cid];
    
    [self getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dictionary) {
        success(dictionary);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//三分屏flash播放前要调用这个接口 拼接 flv 的有效 url
+ (void)getTokenSuccess:(void (^)(NSDictionary * dic))success
                failure:(void (^)(NSError *error))failure
{
    [self getDataWithNSString:HXRUNTIME_AUTH_TOKEN withDictionary:nil success:^(NSDictionary *dictionary) {
        success(dictionary);
    } failure:^(NSError *error) {
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
