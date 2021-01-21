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

@property(nonatomic, strong) NSString *examTitle;    //试卷名称
@property(nonatomic, assign) BOOL allowSeeResult;    //允许查看答卷
@property(nonatomic, strong) NSString *leftExamNum;
@property(nonatomic, assign) BOOL confuseOrder;
@property(nonatomic, strong) NSString *maxExamNum;   //允许最多考试数
@property(nonatomic, strong) NSString *beginTime;
@property(nonatomic, strong) NSString *endTime;
@property(nonatomic, assign) BOOL scoreSecret;       //分数是否保密
@property(nonatomic, assign) BOOL allowSeeAnswer ;   //考完后允许查看正确答案
@property(nonatomic, assign) BOOL clientJudge;       //是否在客户端判卷
@property(nonatomic, strong) NSString *examId;
@property(nonatomic, assign) BOOL allowSeeAnswerOnContinue;//续考期间允许查看答案
@property(nonatomic, assign) BOOL canExam;
@property(nonatomic, strong) NSString *limitTime;    //考试时间，0表示不限制，单位分钟

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
