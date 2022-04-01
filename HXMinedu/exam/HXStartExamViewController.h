//
//  HXStartExamViewController.h
//  Hxdd_exam
//
//  Created by Marble on 14-9-1.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "HXExamSessionManager.h"

@interface HXStartExamViewController : UIViewController<WKNavigationDelegate,UIAlertViewDelegate>

@property(nonatomic, copy) NSString *examUrl;       //考试的链接
@property(nonatomic, copy) NSString *examTitle;     //考试标题
@property(nonatomic, strong) NSDictionary *userExam;//存储考试信息的字典
@property(nonatomic, copy) NSString *examBasePath;  //用于提交试卷用的base 地址
@property(nonatomic, copy) NSString *examAdminPath; //考试管理端的地址，错题反馈会用到此地址
@property(nonatomic, assign) BOOL isStartExam;      //用于判断是否是从开始考试进来的 还是继续考试
@property(nonatomic, assign) BOOL isEnterExam;      //用于判断是开始考试（yes） 还是查看试卷（no）

@property(nonatomic, assign) BOOL isAllowSeeAnswer;

@end
