//
//  AnswerObject.h
//  Hxdd_exam
//
//  Created by  MAC on 14-9-5.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerObject : NSObject

@property (nonatomic, assign) long questionId;
@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * hint;
@property (nonatomic, assign) float score;

-(id)initWithQuestionId:(long)qid Type:(int)ty Ansewer:(NSString *)as Score:(float)so;

@end
