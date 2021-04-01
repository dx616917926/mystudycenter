//
//  AnswerObject.m
//  Hxdd_exam
//
//  Created by  MAC on 14-9-5.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "AnswerObject.h"

@implementation AnswerObject


-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithQuestionId:(long)qid Type:(int)ty Ansewer:(NSString *)as Score:(float)so
{
    if (self = [super init]) {
        self.type = ty;
        self.questionId = qid;
        self.answer = [NSString stringWithFormat:@"%@",as];
        self.score = so;
    }
    
    return self;
}

@end
