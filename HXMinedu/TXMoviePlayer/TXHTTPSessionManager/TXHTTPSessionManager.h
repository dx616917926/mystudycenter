//
//  TXHTTPSessionManager.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/23.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#define TXBaseUrl @"http://cws.edu-edu.com"

//接口
#define TXAPI_CATALOGS           @"/appApi/catalogs"         //获取课件章节目录
#define TXAPI_CATALOG_INFO       @"/appApi/catalogInfo/%@"   //根据章节ID 获取媒体信息
#define TXAPI_LEARNRECORD        @"/appApi/learnRecords"     //同步听课记录

@interface TXHTTPSessionManager : AFHTTPSessionManager


+ (instancetype)sharedClient;

//获取课件章节目录
+ (void)requestCatalogsWithParam:(NSDictionary *)param
                         success:(void (^)(NSDictionary* dictionary))success
                         failure:(void (^)(NSString *failureMessage))failure;

//根据章节ID 获取媒体信息
+ (void)requestCatalogInfoWithId:(NSString *)catalogId
                           param:(NSDictionary *)param
                         success:(void (^)(NSDictionary* dictionary))success
                         failure:(void (^)(NSString *failureMessage))failure;

//同步听课记录
+ (void)uploadLearnRecordWithParam:(NSDictionary *)param
                           success:(void (^)(NSDictionary* dictionary))success
                           failure:(void (^)(NSString *failureMessage))failure;


@end
