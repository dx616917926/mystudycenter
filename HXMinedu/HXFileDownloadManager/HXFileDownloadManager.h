//
//  HXFileDownloadManager.h
//  HXMinedu
//
//  Created by mac on 2022/4/11.
//

#import <Foundation/Foundation.h>
#import "HXLoadDownloadFileViewController.h"
#import "NSString+Hash.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^downloadpercent)(double percent);
typedef void(^filesavedPath)(NSURL *path);
typedef void(^errorReason)(NSString *error);

@interface HXFileDownloadManager : NSObject


//单例
+(instancetype)shared;

//异步下载的方法 进度的block
-(void)downloadFileWithURL:(NSURL *)url  progress:(void(^)(float progress))progressBlock complete:(void(^)(NSString *fileSavePath,NSError *error))completeBlock;

//判断是否正在下载
-(BOOL)isDownloadingFileWithURL:(NSURL *)url;


//取消下载
- (void)cancelDownloadingFileWithURL:(NSURL *)url complete:(void (^)(void))completeBlock;


//显示文件占内存大小
+ (NSString *)getFileCacheSize;

//删除文件
+(void)deleteFileFromCache;

//多个文件串行下载
-(void)downloadStuffWithArray:(NSArray *)urlArray
             complitionHandler:(downloadpercent)complitionBlock
                 filesavedPath:(filesavedPath)pathBlock
                downloadError:(errorReason)errorBlock;

@end

NS_ASSUME_NONNULL_END
