//
//  TXQuestion.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/22.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXQuestionOption.h"

NS_ASSUME_NONNULL_BEGIN

//题
@interface TXQuestion : NSObject

@property(nonatomic, strong) NSString *analysis;          // 解析此题
@property(nonatomic, strong) NSString *answer;            // 答案 多选 A,B
@property(nonatomic, strong) NSString *catalogId;         // 章节 ID
@property(nonatomic, strong) NSString *coursewareCode;    // 课件编码
@property(nonatomic, strong) NSString *examinePoint;      // 试题考核点
@property(nonatomic, strong) NSString *mediaId;           // 媒体 ID
@property(nonatomic, strong) NSString *mediaTitle;        // 媒体名称
@property(nonatomic, strong) NSString *mediaTime;         // 弹题时间
@property(nonatomic, strong) NSString *questionId;        // 试题主键ID
@property(nonatomic, strong) NSString *questionStem;      // 试题题干
@property(nonatomic, strong) NSString *questionType;      // 1单选2多选
@property(nonatomic, strong) NSArray *optionList;         // 试题选项  -- TXQuestionOption


@end

NS_ASSUME_NONNULL_END
