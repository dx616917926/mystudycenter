//
//  TXKnowledgePoint.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/22.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

// 知识点列表
@interface TXKnowledgePoint : NSObject

@property(nonatomic, strong) NSString *businessLineCode; // 业务线编码
@property(nonatomic, strong) NSString *code;             // 知识点编码
@property(nonatomic, strong) NSString *courseCode;       // 课程code
@property(nonatomic, strong) NSString *ID;               // 知识点id
@property(nonatomic, strong) NSString *parentId;         // 父知识点id
@property(nonatomic, strong) NSString *sequenceNum;      // 序号
@property(nonatomic, strong) NSString *title;            // 知识点名称

@end

NS_ASSUME_NONNULL_END
