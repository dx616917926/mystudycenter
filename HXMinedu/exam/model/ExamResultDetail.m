//
//  ExamResultDetail.m
//  Hxdd_exam
//
//  Created by  MAC on 14-9-5.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "ExamResultDetail.h"

@implementation ExamResultDetail

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.questionId = [[dic objectForKey:@"question_id"] integerValue];
        self.userExamId = [dic stringValueForKey:@"user_exam_id"];
        self.answer = [dic stringValueForKey:@"answer"];
        self.attach = [dic stringValueForKey:@"attach"];
        self.submited = [[dic stringValueForKey:@"submited"] intValue];
        self.paperSuitQuestionId = [[dic stringValueForKey:@"paper_suit_question_id"] intValue];
    }
    
    return self;
}

@end
