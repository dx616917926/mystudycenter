//
//  TXQuestionOption.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/22.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

// 题目选项
@interface TXQuestionOption : NSObject

@property(nonatomic, assign) BOOL correct;                // 选项是否正确
@property(nonatomic, strong) NSString *optionId;          // 选项ID
@property(nonatomic, strong) NSString *quesOption;        // 选项内容
@property(nonatomic, strong) NSString *quesValue;         // 选项值
@property(nonatomic, strong) NSString *questionId;        // 试题id

@end

NS_ASSUME_NONNULL_END
