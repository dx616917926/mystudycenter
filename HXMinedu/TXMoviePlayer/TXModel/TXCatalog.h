//
//  TXCatalog.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/23.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXCatalogKnowledgePoint.h"
#import "TXLecture.h"
#import "TXMedia.h"
#import "TXQuestion.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

//章节
@interface TXCatalog : NSObject

@property(nonatomic, strong) NSArray *catalogKnowledgePoints;   // 试题选项  -- TXCatalogKnowledgePoint
@property(nonatomic, strong) NSString *coursewareCode;          // 课件编码
@property(nonatomic, strong) NSString *ID;                      // 主键 ID
@property(nonatomic, assign) BOOL isMedia;                      // 是否有媒体,1为有,0位没有
@property(nonatomic, strong) NSArray *lectures;                 // 讲义列表  -- TXLecture
@property(nonatomic, strong) TXMedia *media;                    // 媒体数据

@property(nonatomic, assign) NSInteger mediaDuration;               // 媒体时长
@property(nonatomic, strong) NSString *mediaId;                     // 媒体 ID
@property(nonatomic, strong) NSString *name;                        // 章节目录名称 -- 目录列表接口用到的
@property(nonatomic, strong) NSString *pId;                         // 节点id
@property(nonatomic, strong) NSString *parentId;                    // 节点父ID
@property(nonatomic, strong) NSArray *questions;                    // 试题选项  -- TXQuestion
@property(nonatomic, strong) NSDictionary *questionMediaTimeDic;    // 弹题时间字典索引
@property(nonatomic, strong) NSDictionary *learnRecord;             // 听课记录

@property(nonatomic, strong) NSString *title;                       // 章节目录名称 -- 章节详情接口用到的

@property(nonatomic, assign) NSInteger orderNum;                    //排序用的

@end

NS_ASSUME_NONNULL_END
