//
//  HXDBManager.m
//  eplatform-edu
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "HXDBManager.h"
#import "HXFileManager.h"

/** 数据库的名称 **/
#define DataBase_Name @"edu-edu"

@implementation HXDBManager


+(HXDBManager *)defaultDBManager{
    
    static HXDBManager * _sharedDBManager;
    if (!_sharedDBManager) {
        _sharedDBManager = [[HXDBManager alloc] init];
    }
    return _sharedDBManager;
}

- (id) init {
    self = [super init];
    if (self) {
        [self connect];
        [self createTables];
    }
    return self;
}

// 连接数据库
- (void) connect {
    if (!_backgroundQueue) {
        _backgroundQueue = [[FMDatabaseQueue alloc] initWithPath:[HXFileManager appDocumentsFilePath:DataBase_Name]];
    }
}


/**
 * 当数据库 第一次被创建的时候 执行的方法. 建立数据库的表结构.
 */
-(void)createTables
{
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        //
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists '%@' (id integer primary key autoincrement, user_exam_id varchar, answer varchar,submited integer,attach varchar,question_id integer,paper_suit_question_id integer)",ExamResultTable_Name];

        
        [db executeUpdate:sqlCreateTable];
        
        NSString *alertUserTable = [NSString stringWithFormat:@"alter table '%@' add phone varchar",UserInfoTable_Name];
        [db executeUpdate:alertUserTable];
    }];
}

// 关闭连接
- (void) close {
    [_backgroundQueue close];
}

- (void) dealloc {
    [self close];
}
@end
