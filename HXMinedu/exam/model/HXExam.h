//
//  HXExam.h
//  eplatform-edu
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>

//考试
@interface HXExam : NSObject

@property (nonatomic,copy) NSString *examTitle;
@property (nonatomic,assign) BOOL allowSeeResult;  //允许查看答卷
@property (nonatomic,copy) NSString * leftExamNum;
@property (nonatomic,assign) BOOL confuseOrder;
@property (nonatomic,copy) NSString *maxExamNum; //允许最多考试数
@property (nonatomic,copy) NSString *beginTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,assign) BOOL scoreSecret;  //分数是否保密
@property (nonatomic,assign) BOOL allowSeeAnswer ; //考完后允许查看正确答案
@property (nonatomic,assign) BOOL clientJudge;//是否在客户端判卷
@property (nonatomic,copy) NSString *examId;
@property (nonatomic,assign) BOOL allowSeeAnswerOnContinue;//续考期间允许查看答案
@property (nonatomic,assign) BOOL canExam;
@property (nonatomic,copy) NSString *message; //辅助的显示信息

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
