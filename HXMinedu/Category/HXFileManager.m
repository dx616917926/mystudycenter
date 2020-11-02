//
//  HXFileManager.m
//  eplatform-edu
//
//  Created by iMac on 16/8/24.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "HXFileManager.h"

@implementation HXFileManager

+ (NSString *)appDocumentsPath
{
    NSString* documentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];
    
    return documentRoot;
}

+ (NSString *)appDocumentsFilePath:(NSString *)fileName
{
    NSString* documentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];
    
    return [documentRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
}

+ (BOOL)isFileExsit:(NSString *)aPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:aPath];
}

+ (BOOL)isFileExsitInDocuments:(NSString *)aPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [self appDocumentsPath];
    [path stringByAppendingPathComponent:aPath];
    return [manager fileExistsAtPath:path];
}

@end
