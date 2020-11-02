//
//  DownloadManager.h
//  DownloadManager
//
//  Created by aliyun on 2019/2/25.
//  Copyright © 2019年 com.alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunPlayer/AliyunPlayer.h>

FOUNDATION_EXPORT NSString * const TXDownloadSourceCompleteNotification;
FOUNDATION_EXPORT NSString * const TXDownloadSourceDeleteNotification;

#define DEFAULT_DM  [DownloadManager shareManager]

typedef NS_ENUM(NSInteger, DownloadType) {
    DownloadTypeStoped,    //停止
    DownloadTypeWaiting,   //等待
    DownloadTypeLoading,   //下载中
    DownloadTypefinish,    //已完成
    DownloadTypePrepared,  //准备完成
    DownloadTypeFailed
};

@interface DownloadSource : NSObject

//这些不存数据库
//@property (nonatomic,strong)AVPVidStsSource *stsSource;

@property (nonatomic,strong)AVPVidAuthSource *authSource;

//这些存数据库
@property (nonatomic,copy)NSString *catalogID;        //章节ID
@property (nonatomic,copy)NSString *vid;              //阿里云视频ID
@property (nonatomic,copy)NSString *coursewareCode;   //课件编码
@property (nonatomic,copy)NSString *coursewareTitle;  //课件大标题名称
@property (nonatomic,copy)NSString *coursewareId;
@property (nonatomic, assign) NSInteger orderNum;     //排序用的
@property (nonatomic,copy)NSString *classID;          //班级ID
@property (nonatomic,assign)DownloadType downloadStatus;
@property (nonatomic,assign)int trackIndex;           //视频的质量
@property (nonatomic,assign)int percent;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *coverURL;
@property (nonatomic,copy)NSString *downloadedFilePath;
@property (nonatomic,assign)NSNumber * video_status;
@property (nonatomic,assign)NSNumber * video_trackIndex;        //视频的质量
@property (nonatomic,assign)NSNumber * video_percent;
@property (nonatomic, strong, nullable) NSData *video_imageData;//视频的图片数据
@property (nonatomic, strong, readonly) AVPMediaInfo *mediaInfo;
@property (nonatomic, copy)NSString *totalDataString;
@property (nonatomic, strong, nullable) NSString *fileName;     //视频的本地播放地址
@property (nonatomic, strong, nullable) NSString *format;       //视频格式
@property (nonatomic, strong, nullable) NSNumber *videoSize;    //视频大小
@property (nonatomic,assign) int videoDownloadStatus;
/**
 Designated Method
 
 @param media 下载的媒体信息
 @return 实例对象
 */
- (instancetype)initWithMedia:(AVPMediaInfo *)media;
- (BOOL)isEqualToSource:(DownloadSource *)source;

- (UIImage *__nullable)statusImage;   // 状态图片
- (NSString *__nullable)statusString; // 状态信息

- (void)stopDownLoad;  // 停止下载

@end



@class DownloadManager;

@protocol DownloadManagerDelegate <NSObject>

@optional

/**
 @brief 下载准备完成事件回调
 @param source 下载source指针
 @param info 下载准备完成回调，@see AVPMediaInfo
 */
-(void)downloadManagerOnPrepared:(DownloadSource *)source mediaInfo:(AVPMediaInfo*)info;

/**
 @brief 错误代理回调
 @param source 下载source指针
 @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
 */
- (void)downloadManagerOnError:(DownloadSource *)source errorModel:(AVPErrorModel *)errorModel;

/**
 @brief 下载进度回调
 @param source 下载source指针
 @param percent 下载进度 0-100
 */
- (void)downloadManagerOnProgress:(DownloadSource *)source percentage:(int)percent;

/**
 @brief 下载完成回调
 @param source 下载source指针
 */
- (void)downloadManagerOnCompletion:(DownloadSource *)source;

/**
 下载状态改变回调
 */
- (void)onSourceStateChanged:(DownloadSource *)source;

@end



@interface DownloadManager : NSObject

/**
 最大下载个数，默认5个
 */
@property (nonatomic,assign) NSInteger maxDownloadCount;

/**
 代理
 */
@property (nonatomic,weak) id<DownloadManagerDelegate> delegate;

/**
 下载路径
 */
@property (nonatomic,strong) NSString *downLoadPath;

/**
 region
 */
@property (nonatomic,strong)NSString *region;

/**
 securityToken
 */
@property (nonatomic,strong)NSString *securityToken;

/**
 accessKeySecret
 */
@property (nonatomic,strong)NSString *accessKeySecret;

/**
 accessKeyId
 */
@property (nonatomic,strong)NSString *accessKeyId;

/**
 playAuth
 */
@property (nonatomic, strong) NSString *playAuth;

/**
 获取单利对象

 @return 单利对象
 */
+ (instancetype)shareManager;

/*
 功能：调用此方法来获取下载视频信息，OnPrepare回调来获取
 参数：source 视频信息源
 */
- (void)prepareDownloadSource:(DownloadSource *)source;

/*
 功能：调用此方法来添加下载视频信息
 参数：source 视频信息源
 */
- (void)addDownloadSource:(DownloadSource *)source;

/*
 功能：开始下载单个视频资源。调用此方法后，开始下载视频
 参数：source 视频信息源
 */
- (void)startDownloadSource:(DownloadSource *)source;

/*
 功能：开始所有下载视频资源
 */
- (void)startAllDownloadSources;

/*
 功能：结束下载视频资源
 参数：source 视频信息项
 */
- (void)stopDownloadSource:(DownloadSource *)source;

/*
 功能：停止所有下载视频资源
 */
- (void)stopAllDownloadSources;

/*
 功能：获取正在下载视频资源列表,包括等待下载列表
 */
- (NSArray<DownloadSource*> *)downloadingdSources;

/*
 功能：获取已经完成的列表
 */
- (NSArray<DownloadSource*> *)doneSources;

/*
功能：获取已经完成的列表,按照班级分类
*/
- (NSArray<DownloadSource*> *)allDoneSourcesWithClassId:(NSString *)classId;

/*
 功能：获取所有的视频资源列表
 */
- (NSArray<DownloadSource*> *)allReadySources;

/*
 功能：清除指定下载的视频资源
 参数：downloadSource 要删除的视频资源
 */
-(int)clearMedia:(DownloadSource *)source;

/*
 功能：清除所有准备的的视频资源
 */
- (void)clearAllPreparedSources;

/*
 功能：清除所有下载的视频资源
 */
- (void)clearAllSources;

/**
 功能：清除所有下载的视频资源

 @return 是否全部成功
 */
- (int)clearAllSourcesFromMediaDownloader;

/**
功能：通过章节id寻找视频资源

@return 视频资源
*/
- (DownloadSource *)findDownloadSourceWithCatalogID:(NSString *)catalogID;

@end

