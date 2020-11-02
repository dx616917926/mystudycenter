//
//  TXMedia.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/22.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

// 媒体数据
@interface TXMedia : NSObject

@property(nonatomic, strong) NSString *clarityLevel;          // 清晰度级别(阿里的几乎不用)
@property(nonatomic, strong) NSString *ID;                    // 媒体主键 id
@property(nonatomic, strong) NSString *mediaDuration;         // 媒体时长
@property(nonatomic, strong) NSString *mediaPrevPicUrl;       // 媒体预览图片路径
@property(nonatomic, strong) NSString *mediaSource;           // 阿里云视频编码或路径
@property(nonatomic, strong) NSString *playAuth;              // 播放凭证
@property(nonatomic, strong) NSString *mediaTitle;            // 媒体名称
@property(nonatomic, strong) NSString *serverCluster;         // 服务器群 ftp视频使用
@property(nonatomic, strong) NSString *serverCode;            // 媒体服务器代码
@property(nonatomic, strong) NSString *serverType;            // 服务器类型 包含'aliyunCode'为阿里视频

@end

NS_ASSUME_NONNULL_END
