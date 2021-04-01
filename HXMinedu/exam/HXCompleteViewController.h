//
//  HXCompleteViewController.h
//  Hxdd_exam
//
//  Created by Marble on 14-9-2.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXExamSessionManager.h"

@interface HXCompleteViewController : UIViewController

@property (nonatomic,copy) NSString *basePath;
@property (nonatomic,strong) NSDictionary *resultUrlDic;
@property (nonatomic,copy) NSString *examTitle;         //考试标题
@property (nonatomic,copy) NSString *examBasePath;      //用于提交试卷用的base 地址

@end
