//
//  ExamResultDetail.h
//  Hxdd_exam
//
//  Created by  MAC on 14-9-5.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamResultDetail : NSObject

@property (nonatomic, retain) NSString * userExamId;
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * attach;
@property (nonatomic, assign) NSInteger submited;
@property (nonatomic, assign) NSInteger paperSuitQuestionId;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
