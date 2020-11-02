//
//  HXDBManager+ExamResult.h
//  eplatform-edu
//
//  Created by iMac on 16/9/2.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "HXDBManager.h"
#import "ExamResultDetail.h"

@interface HXDBManager (ExamResult)

/**
 保存一条数据到数据库
 */
-(BOOL)saveOneExamResultDetail:(ExamResultDetail*)detail;

/**
 获取用户当前试卷的离线答案
 */
-(NSArray*)listAnswerByUserExamId:(NSString*)userExamId;

/**
 从数据库中删除一条数据
 */
-(BOOL)deleteOneNewExamResultDetail:(ExamResultDetail*)detail;

@end
