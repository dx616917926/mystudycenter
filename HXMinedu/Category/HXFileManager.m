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

	+ (void)calculateSizeWithCompletionBlock:(HXFileManagerCalculateSizeBlock)completionBlock {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSURL *diskCacheURL = [NSURL fileURLWithPath:[paths firstObject] isDirectory:YES];
    
    dispatch_queue_t ioQueue = dispatch_queue_create("com.edu.HXFileManager", DISPATCH_QUEUE_SERIAL);
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    dispatch_async(ioQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
                                                  includingPropertiesForKeys:@[NSFileSize]
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
}

@end
