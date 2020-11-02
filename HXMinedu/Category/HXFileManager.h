//
//  HXFileManager.h
//  eplatform-edu
//
//  Created by iMac on 16/8/24.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXFileManager : NSObject

/**
 *  获得app文档目录
 *
 *  @return 目录地址
 */
+ (NSString *)appDocumentsPath;

+ (NSString *)appDocumentsFilePath:(NSString *)fileName;

/**
 *  判断文件是否存在
 *
 *  @param aPath 地址
 *
 *  @return BOOL
 */
+ (BOOL)isFileExsit:(NSString *)aPath;

/**
 *  判断Doc目录中是否存在某文件
 *
 *  @param aPath 地址
 *
 *  @return BOOL
 */
+ (BOOL)isFileExsitInDocuments:(NSString *)aPath;

@end
