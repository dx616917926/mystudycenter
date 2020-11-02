//
//  DownloadManager.m
//  DownloadManager
//
//  Created by aliyun on 2019/2/25.
//  Copyright © 2019年 com.alibaba. All rights reserved.
//

#import "DownloadManager.h"
#import "FMDB.h"
#import <AliyunMediaDownloader/AliyunMediaDownloader.h>

#define DEFAULT_DB   [DownloadDBManager shareManager]

NSString * const TXDownloadSourceCompleteNotification = @"TXDownloadSourceCompleteNotification";
NSString * const TXDownloadSourceDeleteNotification = @"TXDownloadSourceDeleteNotification";

typedef void(^downloadTypeChangeBlock)(DownloadSource *source);

@interface DownloadSource()

@property (nonatomic,strong)AliMediaDownloader *downloader;
@property (nonatomic,strong)downloadTypeChangeBlock downloadTypeChangeCallBack;

@end

@implementation DownloadSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.downloadStatus = DownloadTypeStoped;
        self.percent = 0;
        self.trackIndex = -2;
        
    }
    return self;
}

- (instancetype)initWithMedia:(AVPMediaInfo *)media{
    self = [super init];
    if (self) {
        _mediaInfo = media;
        _title = media.title;
       
    }
    return self;
}

- (void)setTrackIndex:(int)trackIndex {
    _trackIndex = trackIndex;
    _video_trackIndex = @(trackIndex);
}

- (void)setPercent:(int)percent {
    _percent = percent;
    _video_percent = @(percent);
}
- (void)setDownloadStatus:(DownloadType)downloadStatus {
    
    if (_downloadStatus  != downloadStatus) {
        _downloadStatus = downloadStatus;
        _video_status = @(downloadStatus);
        if (self.downloadTypeChangeCallBack) {
            self.downloadTypeChangeCallBack(self);
        }
    }
}

//
//- (void)setStsSource:(AVPVidStsSource *)stsSource {
//    if (_stsSource != stsSource) {
//        _stsSource = stsSource;
//        if (stsSource.vid.length != 0) {
//            self.vid = stsSource.vid;
//        }
//    }
//}

- (void)setAuthSource:(AVPVidAuthSource *)authSource {
    if (_authSource != authSource) {
        _authSource = authSource;
        if (authSource.vid.length != 0) {
            self.vid = authSource.vid;
        }
    }
}

- (BOOL)isEqualToSource:(DownloadSource *)source {
    if ([self.vid isEqualToString:source.vid] && [self.catalogID isEqualToString:source.catalogID]) {
        return YES;
    }
    return NO;
}

- (UIImage *__nullable)statusImage{
    return [DownloadSource imageWithStatus:self.downloadStatus];
}

+ (UIImage *__nullable)imageWithStatus:(DownloadType)status{
    switch (status) {
        case DownloadTypeLoading:
            return [UIImage imageNamed:@"avcDownloadPause"];
            break;
        case DownloadTypeStoped:
            return [UIImage imageNamed:@"avcDownload"];
            break;
        case DownloadTypePrepared:
            return [UIImage imageNamed:@"avcDownload"];
            break;
        case DownloadTypeWaiting:
            return [UIImage imageNamed:@"avcWait"];
            break;
        case DownloadTypeFailed:
            return [UIImage imageNamed:@"avcDownload"];
            break;
        default:
            return  nil;
            break;
    }
    
}

- (NSString *__nullable)statusString{
    return [DownloadSource stringWithStatus:self.downloadStatus];
}

+ (NSString *__nullable)stringWithStatus:(DownloadType )status{
    switch (status) {
        case DownloadTypeLoading:
            return @"下载中";
            break;
        case DownloadTypeWaiting:
            return @"等待中";
            break;
        case DownloadTypeFailed:
            return @"下载错误";
            break;
        case DownloadTypeStoped:
            return @"已暂停";
        default:
            return  nil;
            break;
    }
}

- (void)stopDownLoad{
    AliMediaDownloader * downLoader = self.downloader;
    [downLoader stop];

    self.downloadStatus = DownloadTypeStoped;
}

@end



@interface DownloadDBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property (nonatomic, strong) FMDatabase *database;

@end

@implementation DownloadDBManager

+ (instancetype)shareManager {
    static DownloadDBManager *dbManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[DownloadDBManager alloc]init];
    });
    return dbManager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSLog(@"%@",homePath);
        NSString *dbPath = [homePath stringByAppendingPathComponent:@"DownloadDBManager_SQL.sqlite"];
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
            self.database = db;
            if ([db open]){
                NSLog(@"数据库创建成功");
            }else {
                NSLog(@"数据库创建失败！");
            }
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS DownloadSourceTable (IDInteger INTEGER primary key autoincrement, title TEXT, coverURL TEXT, downloadedFilePath TEXT,catalogID TEXT, coursewareCode TEXT, coursewareTitle TEXT, coursewareID TEXT, classID TEXT, vid TEXT,trackIndex INTEGER, percent INTEGER,totalDataString TEXT,downloadStatus INTEGER,orderNum INTEGER)"];
        }];
    }
    return self;
}

- (void)addSource:(DownloadSource *)source {
    if ([self hasSource:source]) { return; }
    
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO DownloadSourceTable (title ,coverURL ,downloadedFilePath ,catalogID ,coursewareCode ,coursewareID ,coursewareTitle ,classID ,vid ,trackIndex ,percent, totalDataString,downloadStatus,orderNum) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%d','%d','%@','%ld','%ld')",source.title,source.coverURL,source.downloadedFilePath,source.catalogID,source.coursewareCode,source.coursewareId,source.coursewareTitle,source.classID,source.vid,source.trackIndex,source.percent,source.totalDataString,(long)source.downloadStatus,source.orderNum];
    [self.database executeUpdate:sqlStr];
    
}

- (void)deleteSource:(DownloadSource *)source {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM DownloadSourceTable WHERE vid = '%@' AND trackIndex = '%d' AND catalogID = '%@'",source.vid,source.trackIndex,source.catalogID];
        [db executeUpdate:sqlStr];
    }];
}

- (void)deleteAll {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM DownloadSourceTable"];
    }];
}

- (void)updateSource:(DownloadSource *)source {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = [NSString stringWithFormat:@"UPDATE DownloadSourceTable SET title = '%@' , coverURL = '%@' , downloadedFilePath = '%@' , percent = '%d', totalDataString = '%@', downloadStatus = '%ld' WHERE vid = '%@'  AND trackIndex = '%d' AND catalogID = '%@'",source.title,source.coverURL,source.downloadedFilePath,source.percent,source.totalDataString,(long)source.downloadStatus,source.vid,source.trackIndex,source.catalogID];
        [db executeUpdate:sqlStr];
    }];
}

- (NSArray <DownloadSource *>*)allSource {
    NSMutableArray *backArray = [NSMutableArray array];
    FMResultSet * set = [self.database executeQuery:@"SELECT * FROM DownloadSourceTable"];
    while ([set next]) {
        DownloadSource *model = [[DownloadSource alloc] init];
        NSString *title = [set stringForColumn:@"title"];
        if (title && ![title isEqualToString:@"(null)"]) {
            model.title = title;
        }
        NSString *coverURL = [set stringForColumn:@"coverURL"];
        if (coverURL && ![coverURL isEqualToString:@"(null)"]) {
            model.coverURL = coverURL;
        }
        NSString *downloadedFilePath = [set stringForColumn:@"downloadedFilePath"];
        if (downloadedFilePath && ![downloadedFilePath isEqualToString:@"(null)"]) {
            model.downloadedFilePath = downloadedFilePath;
        }
        model.vid = [set stringForColumn:@"vid"];
        model.catalogID = [set stringForColumn:@"catalogID"];
        model.coursewareCode = [set stringForColumn:@"coursewareCode"];
        model.trackIndex = [set intForColumn:@"trackIndex"] ;
        model.percent = [set intForColumn:@"percent"];
        model.downloadStatus = [set intForColumn:@"downloadStatus"];
        model.totalDataString = [set stringForColumn:@"totalDataString"];
        model.coursewareTitle = [set stringForColumn:@"coursewareTitle"];
        model.coursewareId = [set stringForColumn:@"coursewareId"];
        model.classID = [set stringForColumn:@"classID"];
        model.orderNum = [set intForColumn:@"orderNum"];
       
        [backArray addObject:model];
    }
    return backArray.copy;
}

- (BOOL)hasSource:(DownloadSource *)source {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM DownloadSourceTable WHERE vid = '%@' AND trackIndex = '%d' AND catalogID = '%@'",source.vid,source.trackIndex,source.catalogID];
    FMResultSet * set = [self.database executeQuery:sqlStr];
    while ([set next]) { return YES; }
    return NO;
}

@end



@interface DownloadManager() <AMDDelegate>

@property (nonatomic,strong)NSMutableArray<DownloadSource*> *allSourcesArray;
@property (nonatomic,assign)NSInteger downloadCount;//正在下载个数

@end

@implementation DownloadManager

- (void)setMaxDownloadCount:(NSInteger)maxDownloadCount {
    if (_maxDownloadCount != maxDownloadCount) {
        _maxDownloadCount = maxDownloadCount;
        [self startDownloadTask];
    }
}

+ (instancetype)shareManager {
    static DownloadManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *encrptyFilePath = [[NSBundle mainBundle] pathForResource:@"encryptedApp" ofType:@"dat"];
        [AliPrivateService initKey:encrptyFilePath];
        manager = [[DownloadManager alloc]init];
        manager.region = @"cn-shanghai";
        manager.downloadCount = 0;
        manager.maxDownloadCount = 20;
        manager.allSourcesArray = [NSMutableArray array];
        manager.downLoadPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSArray *allArray = [DEFAULT_DB allSource];
        __weak typeof(DownloadManager *) weakManager = manager;
        for (DownloadSource *source in allArray) {
            if (source.percent == 100) {
                source.downloadStatus = DownloadTypefinish;
            }else {
                source.downloadTypeChangeCallBack = ^(DownloadSource *source) {
                    if ([weakManager.delegate respondsToSelector:@selector(onSourceStateChanged:)]) {
                        [weakManager.delegate onSourceStateChanged:source];
                    }
                };
            }
            [manager.allSourcesArray addObject:source];
        }
    });
    return manager;
}

- (void)prepareDownloadSource:(DownloadSource *)source {
    DownloadSource *hasSource = [self hasDownloadSource:source];
    if (hasSource) {
        hasSource.authSource = nil;
        [hasSource.downloader stop];
        hasSource.downloader = nil;
        [self.allSourcesArray removeObject:hasSource];
    }
    if (!source.authSource) {
        source.authSource = [self getAuthSourceFromVid:source.vid];
    }
    if (source.authSource) {
        AliMediaDownloader *downloader = [[AliMediaDownloader alloc] init];
        [downloader setSaveDirectory:self.downLoadPath];
        [downloader setDelegate:self];
        [downloader prepareWithPlayAuth:source.authSource];
        source.downloader = downloader;
        source.downloadStatus = DownloadTypePrepared;
        [self.allSourcesArray addObject:source];
    }else {
        [self onErrorWithNoAuth:source];
    }
}

- (AVPVidStsSource *)getStsSourceFromVid:(NSString *)vid {
    if (!vid || !self.securityToken) { return nil; }
    AVPVidStsSource* stsSource = [[AVPVidStsSource alloc] init];
    stsSource.vid = vid;
    stsSource.region = self.region;
    stsSource.securityToken = self.securityToken;
    stsSource.accessKeySecret = self.accessKeySecret;
    stsSource.accessKeyId = self.accessKeyId;
    return stsSource;
}

- (AVPVidAuthSource *)getAuthSourceFromVid:(NSString *)vid {
    if (!vid) { return nil; }
    AVPVidAuthSource* authSource = [[AVPVidAuthSource alloc] init];
    authSource.vid = vid;
    authSource.region = self.region;
    authSource.playAuth = self.playAuth;
    authSource.format = @"mp4";
    return authSource;
}

- (void)onErrorWithNoAuth:(DownloadSource *)source {
    if ([self.delegate respondsToSelector:@selector(downloadManagerOnError:errorModel:)]) {
        AVPErrorModel *errorModel = [[AVPErrorModel alloc]init];
        errorModel.message = NSLocalizedString(@"认证信息缺失", nil);
        [self.delegate downloadManagerOnError:source errorModel:errorModel];
    }
}

- (void)addDownloadSource:(DownloadSource *)source {
    DownloadSource *hasSource = [self hasDownloadSource:source];
    if (!hasSource){
        hasSource = source;
    }
    
    if (hasSource.downloadStatus == DownloadTypePrepared) {
        __weak typeof(self) weakSelf = self;
        hasSource.downloadTypeChangeCallBack = ^(DownloadSource *backSource) {
            if ([weakSelf.delegate respondsToSelector:@selector(onSourceStateChanged:)]) {
                [weakSelf.delegate onSourceStateChanged:backSource];
            }
        };
        hasSource.downloadStatus = DownloadTypeStoped;
        [DEFAULT_DB addSource:hasSource];
    }
}

- (void)startDownloadSource:(DownloadSource *)source {
    DownloadSource *hasSource = [self hasDownloadSource:source];
    if (hasSource && (hasSource.downloadStatus == DownloadTypeStoped || hasSource.downloadStatus == DownloadTypeFailed)) {
        [self startSourceTask:hasSource];
        [self startDownloadTask];
    }
}

- (void)startAllDownloadSources {
    for (DownloadSource *source in self.allSourcesArray) {
        if (source.downloadStatus == DownloadTypeStoped) {
            [self startSourceTask:source];
        }
    }
    [self startDownloadTask];
}

- (void)startSourceTask:(DownloadSource *)source {
    if (!source.authSource) {
        source.authSource = [self getAuthSourceFromVid:source.vid];
    }
    if (source.authSource) {
        source.downloadStatus = DownloadTypeWaiting;
    }else {
        [self onErrorWithNoAuth:source];
    }
}

- (void)stopDownloadSource:(DownloadSource *)source {
    DownloadSource *hasSource = [self hasDownloadSource:source];
    if (hasSource) {
        if (hasSource.downloadStatus == DownloadTypeLoading) {
            self.downloadCount --;
            [hasSource.downloader stop];
            hasSource.downloadStatus = DownloadTypeStoped;
        }else if (source.downloadStatus == DownloadTypeWaiting) {
            hasSource.downloadStatus = DownloadTypeStoped;
        }
        [self startDownloadTask];
    }
}

- (void)stopAllDownloadSources {
    for (DownloadSource *source in self.allSourcesArray) {
        if (source.downloadStatus == DownloadTypeLoading) {
            self.downloadCount --;
            [source.downloader stop];
            source.downloadStatus = DownloadTypeStoped;
        }else if (source.downloadStatus == DownloadTypeWaiting) {
            source.downloadStatus = DownloadTypeStoped;
        }
    }
}

- (NSArray<DownloadSource*> *)downloadingdSources {
    NSMutableArray *backArray = [NSMutableArray array];
    for (DownloadSource *source in self.allSourcesArray) {
        if (source.downloadStatus == DownloadTypeLoading || source.downloadStatus == DownloadTypeWaiting || source.downloadStatus == DownloadTypeStoped) {
            [backArray addObject:source];
        }
    }
    return backArray.copy;
}

- (NSArray<DownloadSource*> *)doneSources {
    NSMutableArray *backArray = [NSMutableArray array];
    for (DownloadSource *source in self.allSourcesArray) {
        if (source.downloadStatus == DownloadTypefinish) {
            [backArray addObject:source];
        }
    }
    return backArray.copy;
}

- (NSArray<DownloadSource*> *)allReadySources {
    NSMutableArray *backArray = [NSMutableArray array];
    for (DownloadSource *source in self.allSourcesArray) {
        if (source.downloadStatus != DownloadTypePrepared) {
            [backArray addObject:source];
        }
    }
    return backArray.copy;
}

- (NSArray<DownloadSource*> *)allDoneSourcesWithClassId:(NSString *)classId {
    NSMutableArray *backArray = [NSMutableArray array];
    for (DownloadSource *source in self.allSourcesArray) {
        if (source.downloadStatus == DownloadTypefinish && [source.classID isEqualToString:classId]) {
            [backArray addObject:source];
        }
    }
    return backArray.copy;
}

-(int)clearMedia:(DownloadSource *)source {
    int result = 0;
    if (source.downloader) {
        if (source.downloadStatus == DownloadTypeLoading) {
            self.downloadCount --;
        }
        [source.downloader stop];
        [source.downloader deleteFile];
        source.downloader = nil;
        source.downloadStatus = DownloadTypeStoped;
    }else {
        NSArray *pathArray = [source.downloadedFilePath componentsSeparatedByString:@"."];
        NSString *format = pathArray.lastObject;
        result = [AliMediaDownloader deleteFile:DEFAULT_DM.downLoadPath vid:source.vid format:format index:source.trackIndex];
    }
    if (result == 0) {
        [self.allSourcesArray removeObject:source];
        [DEFAULT_DB deleteSource:source];
        [self startDownloadTask];
        
        //发送删除的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TXDownloadSourceDeleteNotification object:source];
    }
    return result;
}

- (void)clearAllPreparedSources {
    for (DownloadSource *source in self.allSourcesArray.copy) {
        if (source.downloadStatus == DownloadTypePrepared) {
            source.downloader = nil;
            [self.allSourcesArray removeObject:source];
        }
    }
}

- (void)clearAllSources {
    for (DownloadSource *source in self.allSourcesArray) {
        if (source.downloader) {
            [source.downloader stop];
            source.downloader = nil;
        }
    }
    self.downloadCount = 0;
    [DEFAULT_DM.allSourcesArray removeAllObjects];
    [DEFAULT_DB deleteAll];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:DEFAULT_DM.downLoadPath error:nil];
}

- (int)clearAllSourcesFromMediaDownloader {
    int result = 0;
    for (DownloadSource *source in self.allSourcesArray.copy) {
        int onceResult = 0;
        if (source.downloader) {
            [source.downloader stop];
            [source.downloader deleteFile];
            source.downloader = nil;
        }else {
            NSArray *pathArray = [source.downloadedFilePath componentsSeparatedByString:@"."];
            NSString *format = pathArray.lastObject;
            onceResult = [AliMediaDownloader deleteFile:DEFAULT_DM.downLoadPath vid:source.vid format:format index:source.trackIndex];
        }
        if (onceResult == 0) {
            [self.allSourcesArray removeObject:source];
            [DEFAULT_DB deleteSource:source];
            
            //发送删除的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:TXDownloadSourceDeleteNotification object:source];
        }else {
            result = onceResult;
        }
    }
    self.downloadCount = 0;
    return result;
}

- (DownloadSource *)findDownloadSourceWithCatalogID:(NSString *)catalogID {
    
    for (DownloadSource *eveSource in self.allSourcesArray) {
        if ([eveSource.catalogID isEqualToString:catalogID]) {
            return eveSource;
        }
    }
    return nil;
}

#pragma mark private

- (void)startDownloadTask {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.downloadCount > self.maxDownloadCount) {
            for (DownloadSource *source in self.allSourcesArray) {
                if (source.downloadStatus == DownloadTypeLoading) {
                    source.downloadStatus = DownloadTypeWaiting;
                    [source.downloader stop];
                    self.downloadCount --;
                    if (self.downloadCount == self.maxDownloadCount) { return; }
                }
            }
        }else if (self.downloadCount < self.maxDownloadCount){
            for (DownloadSource *source in self.allSourcesArray) {
                if (source.downloadStatus == DownloadTypeWaiting) {
                    if (source.downloader) {
                        [source.downloader selectTrack:source.trackIndex];
                        source.downloadStatus = DownloadTypeLoading;
                        [source.downloader start];
                        self.downloadCount ++;
                        if (self.downloadCount == self.maxDownloadCount) { return; }
                    }else {
                        AliMediaDownloader *downloader = [[AliMediaDownloader alloc] init];
                        [downloader setSaveDirectory:self.downLoadPath];
                        
                        [downloader setDelegate:self];
                        [downloader prepareWithPlayAuth:source.authSource];
                        source.downloader = downloader;
                    }
                }
            }
        }
    });
}

- (DownloadSource *)hasDownloadSource:(DownloadSource *)source {
    
    for (DownloadSource *eveSource in self.allSourcesArray) {
        if ([eveSource isEqualToSource:source]) {
            return eveSource;
        }
    }
    return nil;
}

#pragma mark AMDDelegate

- (DownloadSource *)findSourceFromDownloader:(AliMediaDownloader *)downloader {
    for (DownloadSource *source in self.allSourcesArray) {
        if (source.downloader == downloader) {
            return source;
        }
    }
    return nil;
}

-(void)onPrepared:(AliMediaDownloader *)downloader mediaInfo:(AVPMediaInfo *)info {
    DownloadSource * source = [self findSourceFromDownloader:downloader];
    if (source) {
        [self startDownloadTask];
        source.coverURL = info.coverURL;
        NSArray * tracks = info.tracks;
        if ([source.totalDataString description].length == 0) {
            
            for (AVPTrackInfo * trackInfo in tracks) {
                if ([trackInfo.trackDefinition isEqualToString:@"LD"] ) {
                    CGFloat mSize = trackInfo.vodFileSize/1048576.0;
                    NSString *mString = [NSString stringWithFormat:@"%.1fM",mSize];
                    source.totalDataString = mString;
                    source.format = trackInfo.vodFormat;
                    source.videoSize =@(trackInfo.vodFileSize)  ;
                    source.trackIndex = trackInfo.trackIndex ;
                    
                    break;
                }
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(downloadManagerOnPrepared:mediaInfo:)]) {
            [self.delegate downloadManagerOnPrepared:source mediaInfo:info];
        }
    }
}

-(void)onError:(AliMediaDownloader *)downloader errorModel:(AVPErrorModel *)errorModel {
    DownloadSource * source = [self findSourceFromDownloader:downloader];
    if (source) {
        if (source.downloadStatus == DownloadTypePrepared) {
            [self.allSourcesArray removeObject:source];
        }else if (source.downloadStatus == DownloadTypeWaiting) {
            source.downloadStatus = DownloadTypeStoped;
            [self startDownloadTask];
        }else if (source.downloadStatus == DownloadTypeLoading) {
            self.downloadCount --;
            source.downloadStatus = DownloadTypeStoped;
            [source.downloader stop];
            [self startDownloadTask];
        }
        source.authSource = nil;
        source.downloader = nil;
        if ([self.delegate respondsToSelector:@selector(downloadManagerOnError:errorModel:)]) {
            [self.delegate downloadManagerOnError:source errorModel:errorModel];
        }
    }
}

-(void)onDownloadingProgress:(AliMediaDownloader *)downloader percentage:(int)percent {
    NSLog(@"~~~~~~~~~~~~~~~~~~%d",percent);
    DownloadSource * source = [self findSourceFromDownloader:downloader];
    if (source && percent != source.percent && source.percent  != 100) {
        source.percent = percent;
        NSArray *pathArray = [downloader.downloadedFilePath componentsSeparatedByString:@"/"];
        source.downloadedFilePath = pathArray.lastObject;
        if (percent == 100) {
            source.downloadStatus = DownloadTypefinish;
        }
        [DEFAULT_DB updateSource:source];
        if ([self.delegate respondsToSelector:@selector(downloadManagerOnProgress:percentage:)]) {
            [self.delegate downloadManagerOnProgress:source percentage:percent];
        }
    }
}

-(void)onProcessingProgress:(AliMediaDownloader *)downloader percentage:(int)percent {
    NSLog(@"onProcessingProgress:%d", percent);
}

-(void)onCompletion:(AliMediaDownloader *)downloader {
    DownloadSource *source = [self findSourceFromDownloader:downloader];
    if (source) {
        self.downloadCount --;
        source.downloadStatus = DownloadTypefinish;
        source.downloader = nil;
        source.downloadTypeChangeCallBack = nil;
        [self startDownloadTask];
        if ([self.delegate respondsToSelector:@selector(downloadManagerOnCompletion:)]) {
            [self.delegate downloadManagerOnCompletion:source];
        }

        //发送下载完成的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TXDownloadSourceCompleteNotification object:source];
    }
}

@end
