//
//  HXQuestionBtn.h
//  Hxdd_exam
//
//  Created by Marble on 14-9-4.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXQuestionInfo.h"

@interface HXQuestionBtn : UIButton
@property (nonatomic,strong) HXQuestionInfo *info;  //保存题目的信息
@property (nonatomic,assign) int fuhe_position;     //保存复合题中小题的位置（从0 开始）
@end
