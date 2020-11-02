//
//  HXQuestionInfo.h
//  Hxdd_exam
//
//  Created by  MAC on 14-9-1.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXQuestionInfo : NSObject

/** ID **/
@property(nonatomic)int _id;

/** 当前题目在试卷中的位置索引 **/
@property(nonatomic)int position;

/** 序号 **/
@property(nonatomic,strong)NSString *  label;

/** 是否为复合题 **/
@property(nonatomic)BOOL isComplex;

/** parent **/
@property(nonatomic,weak)HXQuestionInfo * parent;

/** 主观题 **/
@property(nonatomic)BOOL objective;

/** 已作答 **/
@property(nonatomic)BOOL hasAnswer;

/** html **/
@property(nonatomic,strong)NSString *  content;

/** subs **/
//private ArrayList<QuestionInfo> subs;
@property(nonatomic,strong)NSMutableArray * subs;


-(id)initWithId:(int)ID andLabel:(NSString*)label Complex:(BOOL)com Objective:(BOOL)objective;
@end
