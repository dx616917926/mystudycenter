//
//  HXQuestionGroup.m
//  Hxdd_exam
//
//  Created by  MAC on 14-9-1.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "HXQuestionGroup.h"

@implementation HXQuestionGroup

-(id)init
{
    if (self = [super init]) {
        _questions = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

@end
