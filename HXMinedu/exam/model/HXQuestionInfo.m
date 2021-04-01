//
//  HXQuestionInfo.m
//  Hxdd_exam
//
//  Created by  MAC on 14-9-1.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "HXQuestionInfo.h"

@implementation HXQuestionInfo

-(id)init
{
    if (self = [super init]) {
        _parent = nil;
        _subs = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

-(id)initWithId:(int)ID andLabel:(NSString*)label Complex:(BOOL)com Objective:(BOOL)objective
{
    if ([self init]) {
        self._id = ID;
        self.label = label;
        self.isComplex = com;
        self.objective = objective;
    }
    return self;
}

@end
