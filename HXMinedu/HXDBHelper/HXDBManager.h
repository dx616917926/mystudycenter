//
//  HXDBManager.h
//  eplatform-edu
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#define SyncStudyTable_Name @"SyncStudyDataBaseTable"

#define DownloadTaskTable_Name @"DownloadTaskTable"

#define SubDownloadTaskTable_Name @"SubDownloadTaskTable"

#define ExamResultTable_Name @"ExamResultDataBase"

#define UserInfoTable_Name @"UserInfoDataBase"

@interface HXDBManager : NSObject

// 数据库操作对象，当数据库被建立时，会存在次至
@property (nonatomic, strong) FMDatabaseQueue *backgroundQueue;  // 数据库操作对象

// 单例模式
+(HXDBManager *)defaultDBManager;

// 关闭数据库
- (void)close;

@end
