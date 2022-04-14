//
//  HXFileDownloadManager.m
//  HXMinedu
//
//  Created by mac on 2022/4/11.
//

#import "HXFileDownloadManager.h"


@interface HXFileDownloadManager ()<NSURLSessionDownloadDelegate>
//下载session
@property (nonatomic, strong) NSURLSession *session;


//保存下载任务对应的进度block 和 完成的block 和下载任务
@property (nonatomic, strong) NSMutableDictionary *progressBlocks;
@property (nonatomic, strong) NSMutableDictionary *completeBlocks;
@property (nonatomic, strong) NSMutableDictionary *downloadTasks;

@property (nonatomic, assign) NSInteger downloadIndex;
@end

@implementation HXFileDownloadManager

static id _instance;

+(instancetype)shared{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.progressBlocks = [NSMutableDictionary dictionary];
        self.completeBlocks = [NSMutableDictionary dictionary];
        self.downloadTasks = [NSMutableDictionary dictionary];
        self.downloadIndex = 0;
    }
    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

////判断是否正在下载
- (BOOL)isDownloadingFileWithURL:(NSURL *)url {
    
    if (self.completeBlocks[url]) {
        return YES;
    }
    return NO;
}

- (void)cancelDownloadingFileWithURL:(NSURL *)url andFormat:(NSString *)format complete:(void (^)(void))completeBlock {
    
    NSURLSessionDownloadTask *currentTask = _downloadTasks[url];
    
    // 2.cancel
    if (currentTask) {
        
        [currentTask cancelByProducingResumeData:^(NSData *_Nullable resumeData) {
            
            [resumeData writeToFile:[self getResumeDataPathWithURL:url] atomically:YES];
            
            //把取消成功的结果返回
            if (completeBlock) {
                completeBlock();
            }
            
            self.progressBlocks[url] = nil;
            self.completeBlocks[url] = nil;
            self.downloadTasks[url] = nil;
            
        }];
    }
}

//入口
- (void)downloadFileWithURL:(NSURL *)url  progress:(void (^)(float progress))progressBlock complete:(void (^)(NSString *fileSavePath, NSError *error))completeBlock {
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *fileSavePath = [self getFileSavePathWithURL:url];
    if ([fileMan fileExistsAtPath:fileSavePath]) {
        NSLog(@"文件已经存在");
        if (completeBlock) {
            completeBlock(fileSavePath, nil);
        }
        return;
    }
    
    if ([self isDownloadingFileWithURL:url]) {
        NSLog(@"正在下载");
        return;
    }
    //根据url设置
    [self.progressBlocks setObject:progressBlock forKey:url];
    [self.completeBlocks setObject:completeBlock forKey:url];
    
    //获取临时文件
    NSString *resumeDataPath = [self getResumeDataPathWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask;
    if ([fileMan fileExistsAtPath:resumeDataPath]) {
        NSData *resumeData = [NSData dataWithContentsOfFile:resumeDataPath];
        downloadTask = [self.session downloadTaskWithResumeData:resumeData];
    } else {
        downloadTask = [self.session downloadTaskWithURL:url];
    }
    
    [self.downloadTasks setObject:downloadTask forKey:url];
    //开启
    [downloadTask resume];
}

#pragma mark - 获取文件
//获取临时文件
- (NSString *)getResumeDataPathWithURL:(NSURL *)url {
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *suffix = [url.absoluteString pathExtension];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[url.absoluteString md5String],suffix];
    return [tmpPath stringByAppendingPathComponent:fileName];
}

//获取文件保存路径
- (NSString *)getFileSavePathWithURL:(NSURL *)url{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *downloadPath = [cachePath stringByAppendingPathComponent:@"HXDownloadFile"];
    if (![fileManager fileExistsAtPath:downloadPath]) {
        [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *suffix = [url.absoluteString pathExtension];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[url.absoluteString md5String],suffix];
    return [downloadPath stringByAppendingPathComponent:fileName];
}

#pragma mark - <NSURLSessionDownloadDelegate>下载代理回调
//下载完成方法
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSURL *currentURL = downloadTask.currentRequest.URL;
    NSString*savePath = [self getFileSavePathWithURL:currentURL];
    if ([fileMan fileExistsAtPath:savePath]) {
        [fileMan removeItemAtPath:savePath error:nil];
    }
    NSError*error;
    [fileMan moveItemAtPath:location.path toPath:savePath error:&error];
    if(error) {
        NSLog(@"Error is %@", error.localizedDescription);
    }else{
        if (self.completeBlocks[currentURL]) {
            void (^tmpCompBlock)(NSString *filePath, NSError *error) = self.completeBlocks[currentURL];
            tmpCompBlock(savePath, nil);
        }
        self.progressBlocks[currentURL] = nil;
        self.completeBlocks[currentURL] = nil;
        self.downloadTasks[currentURL] = nil;
    }
}

//
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    float progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    
    
    NSURL *url = downloadTask.currentRequest.URL;
    if (self.progressBlocks[url]) {
        
        void (^tmpProBlock)(float) = self.progressBlocks[url];
        tmpProBlock(progress);
    }
}

#pragma mark -  公共方法
//获取缓存文件大小
+ (NSString *)getFileCacheSize{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *downloadPath = [cachePath stringByAppendingPathComponent:@"HXDownloadFile"];
    
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:downloadPath];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        filePath =[downloadPath stringByAppendingPathComponent:subPath];
        
        BOOL isDirectory = NO;
        
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            
            continue;
        }
        
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        
        totleSize += size;
    }
    
    
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    
    return totleStr;
    
}

//删除文件
+(void)deleteFileFromCache{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *HXCachePath = [cachePath stringByAppendingPathComponent:@"HXDownloadFile"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:HXCachePath error:nil];
    
    for(NSString *fileName in array){
        
        [fileManager removeItemAtPath:[HXCachePath stringByAppendingPathComponent:fileName] error:nil];
    }
}

///多个文件串行下载
-(void)dealDownload:(filesavedPath _Nonnull)pathBlock
           urlArray:(NSArray * _Nonnull)urlArray
  complitionHandler:(downloadpercent _Nonnull)complitionBlock
      downloadError:(errorReason)errorBlock {
    
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);//信号量，保证一个接一个执行
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    NSURL* URL = [NSURL URLWithString:urlArray[self.downloadIndex]];
    
    dispatch_group_async(group, queue, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            NSLog(@"%d %@ %f",__LINE__,NSStringFromClass(self.class),downloadProgress.fractionCompleted);
            complitionBlock([NSString stringWithFormat:@"%.2f",downloadProgress.fractionCompleted].doubleValue);
            
            if (downloadProgress.fractionCompleted == 1.0) {
                dispatch_semaphore_signal(semaphore);
            }
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                                  inDomain:NSUserDomainMask
                                                                         appropriateForURL:nil
                                                                                    create:NO
                                                                                     error:nil];
            pathBlock([documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]]);
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            NSLog(@"%d %@ %ld",__LINE__,NSStringFromClass(self.class),self.downloadIndex);
            /// 下载完一个，取下一个元素，继续下载。相当于遍历了一遍下载数组。
            self.downloadIndex += 1;
            errorBlock(error.debugDescription);
            if (self.downloadIndex == urlArray.count) {
                return;
            }
            [self dealDownload:pathBlock urlArray:urlArray complitionHandler:complitionBlock downloadError:errorBlock];
        }];
        [downloadTask resume];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%d %@ %@",__LINE__,NSStringFromClass(self.class),@"下载完毕");
        });
    });
}

- (void)downloadStuffWithArray:(NSArray *)urlArray
             complitionHandler:(downloadpercent)complitionBlock
                 filesavedPath:(filesavedPath)pathBlock
                 downloadError:(errorReason)errorBlock {
    /// 有下载元素
    if (self.downloadIndex < urlArray.count) {
        [self dealDownload:pathBlock urlArray:urlArray complitionHandler:complitionBlock downloadError:errorBlock];
    }
}



@end





























