//
//  TXHTTPSessionManager.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/23.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXHTTPSessionManager.h"

@implementation TXHTTPSessionManager

+ (instancetype)sharedClient {
    
    static TXHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TXHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:TXBaseUrl]];
        
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.requestSerializer.timeoutInterval = 10;
    });
    
    return _sharedClient;
}

//获取课件章节目录
+ (void)requestCatalogsWithParam:(NSDictionary *)param
                         success:(void (^)(NSDictionary* dictionary))success
                         failure:(void (^)(NSString *failureMessage))failure {
    
    TXHTTPSessionManager * client = [TXHTTPSessionManager sharedClient];
    
    NSString *requestUrl = TXAPI_CATALOGS;
    //动态判断是否参数里指定了服务器域名
    NSString *serverUrl = [param objectForKey:@"serverUrl"];
    if (serverUrl) {
        requestUrl = [NSString stringWithFormat:@"%@%@",serverUrl,requestUrl];
    }
    
    [client POST:requestUrl parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        if(dictionary)
        {
            NSString *isSuccess = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
            if ([isSuccess isEqualToString:@"1"]) {
                success(dictionary);
            }else
            {
                NSString *message = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];
                failure(message);
            }
        }else
        {
            failure(@"数据格式错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSString *errorInfo = [self errorInfoWithRequest:task];
        failure(errorInfo);
    }];
}

//根据章节ID 获取媒体信息
+ (void)requestCatalogInfoWithId:(NSString *)catalogId
                           param:(NSDictionary *)param
                         success:(void (^)(NSDictionary* dictionary))success
                         failure:(void (^)(NSString *failureMessage))failure {
    
    TXHTTPSessionManager * client = [TXHTTPSessionManager sharedClient];
    
    NSString *requestUrl = [NSString stringWithFormat:TXAPI_CATALOG_INFO,catalogId];
    //动态判断是否参数里指定了服务器域名
    NSString *serverUrl = [param objectForKey:@"serverUrl"];
    if (serverUrl) {
        requestUrl = [NSString stringWithFormat:@"%@%@",serverUrl,requestUrl];
    }
    
    [client POST:requestUrl parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        if(dictionary)
        {
            NSString *isSuccess = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
            if ([isSuccess isEqualToString:@"1"]) {
                success(dictionary);
            }else
            {
                NSString *message = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];
                failure(message);
            }
        }else
        {
            failure(@"数据格式错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSString *errorInfo = [self errorInfoWithRequest:task];
        failure(errorInfo);
    }];
}

//同步听课记录
+ (void)uploadLearnRecordWithParam:(NSDictionary *)param
                           success:(void (^)(NSDictionary* dictionary))success
                           failure:(void (^)(NSString *failureMessage))failure {
    
    TXHTTPSessionManager * client = [TXHTTPSessionManager sharedClient];
    
    NSString *requestUrl = TXAPI_LEARNRECORD;
    //动态判断是否参数里指定了服务器域名
    NSString *serverUrl = [param objectForKey:@"serverUrl"];
    if (serverUrl) {
        requestUrl = [NSString stringWithFormat:@"%@%@",serverUrl,requestUrl];
    }
    
    [client PUT:requestUrl parameters:param headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        if(dictionary)
        {
            NSString *isSuccess = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
            if ([isSuccess isEqualToString:@"1"]) {
                success(dictionary);
            }else
            {
                NSString *message = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];
                failure(message);
            }
        }else
        {
            failure(@"数据格式错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSString *errorInfo = [self errorInfoWithRequest:task];
        failure(errorInfo);
    }];
}

//网络错误提示语
+ (NSString *)errorInfoWithRequest:(NSURLSessionDataTask *)task {
    
    NSString * info = @"正常!";
    if (task && task.error) {
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        
        if (task.error.code==NSURLErrorNotConnectedToInternet) {
            info = @"请检查网络!";
        }else if (task.error.code==NSURLErrorTimedOut) {
            info = @"请求超时,请重试!";
        }else if (response.statusCode == 401) {
            info = @"授权已失效，请重新登录!";
        }else if (response.statusCode == 403) {
            info = @"您没有权限!";
        }else if (response.statusCode == 404) {
            info = @"获取数据失败!";
        }else if (response.statusCode == 500) {
            info = @"数据异常，请稍后重试!";
        }else
        {
            info = @"获取数据失败,请重试!";
        }
    }
    return info;
}
    
@end
