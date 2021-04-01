//
//  HXQuestionGroup.h
//  Hxdd_exam
//
//  Created by  MAC on 14-9-1.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXQuestionGroup : NSObject

/** 大题标题 **/
@property(nonatomic,strong)NSString * title;

/** 包含的题目信息 **/
//private ArrayList<QuestionInfo> questions;
@property(nonatomic,strong)NSMutableArray * questions;
@end
