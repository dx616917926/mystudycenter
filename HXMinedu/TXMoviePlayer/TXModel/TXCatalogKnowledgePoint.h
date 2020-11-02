//
//  TXCatalogKnowledgePoint.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/22.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXKnowledgePoint.h"

NS_ASSUME_NONNULL_BEGIN

// 媒体知识点列表
@interface TXCatalogKnowledgePoint : NSObject

@property(nonatomic, strong) NSString *catalogId;                // 章节 ID
@property(nonatomic, strong) NSString *catalogKnowledgePointId;  // 中间表 ID 删除/修改媒体知识点使用
@property(nonatomic, strong) NSString *endTime;                  // 知识点结束时间
@property(nonatomic, strong) NSString *knowledgePointCode;       //一个或多个知识点编码,多个则用逗号分隔
@property(nonatomic, strong) NSString *startTime;                // 知识点开始时间
@property(nonatomic, strong) NSString *title;                    //
@property(nonatomic, strong) NSArray *knowledgePoints;           // 知识点列表  -- TXKnowledgePoint
    
@end

NS_ASSUME_NONNULL_END
