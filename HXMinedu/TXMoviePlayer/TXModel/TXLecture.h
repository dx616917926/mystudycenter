//
//  TXLecture.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/23.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

//讲义
@interface TXLecture : NSObject

@property(nonatomic, strong) NSString *catalogId;          // 章节 ID
@property(nonatomic, strong) NSString *content;            // 讲义内容
@property(nonatomic, strong) NSString *coursewareCode;     // 课件编码
@property(nonatomic, strong) NSString *endTime;            // 结束时间
@property(nonatomic, strong) NSString *lectureId;          // 讲义 ID
@property(nonatomic, strong) NSString *mediaId;            // 媒体 ID
@property(nonatomic, strong) NSString *startTime;          // 开始时间
@property(nonatomic, strong) NSString *title;              // 讲义标题

@end

NS_ASSUME_NONNULL_END
