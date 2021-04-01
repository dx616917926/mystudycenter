//
//  HXDBManager+ExamResult.m
//  eplatform-edu
//
//  Created by iMac on 16/9/2.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "HXDBManager+ExamResult.h"

@implementation HXDBManager (ExamResult)

-(BOOL)saveOneExamResultDetail:(ExamResultDetail*)detail
{
    __block int lastRowId = -1;
    __block BOOL res = NO;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        
        //查询记录是否存在
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE user_exam_id = ? and question_id = ?",ExamResultTable_Name];
        FMResultSet *rs = [db executeQuery:sql,detail.userExamId,[NSNumber numberWithInteger:detail.questionId]];
        if ([rs next])
        {
            //有值则更新
            NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET answer = ? ,submited = ?,attach = ?,paper_suit_question_id = ? WHERE user_exam_id = ? and question_id = ?",ExamResultTable_Name];
            res = [db executeUpdate:updateSql ,detail.answer,[NSNumber numberWithInteger:detail.submited],detail.attach,[NSNumber numberWithInteger:detail.paperSuitQuestionId],detail.userExamId,[NSNumber numberWithInteger:detail.questionId]];
        }
        else
        {
            //没值则插入
            res = [self addOneNewExamResultDetail:detail WithDB:db];
        }
        
        if (res) {
            lastRowId = (int)db.lastInsertRowId;
        }
    }];
    return res;
}

/**
 获取用户当前试卷的离线答案
 */
-(NSArray*)listAnswerByUserExamId:(NSString*)userExamId
{
    __block NSMutableArray *ar = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE user_exam_id='%@' ",ExamResultTable_Name,userExamId];

        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            ExamResultDetail * detail = [[ExamResultDetail alloc]initWithDictionary:[rs resultDictionary]];
            
            [ar addObject:detail];
        }
        
    }];
    
    return ar;
}


-(BOOL)addOneNewExamResultDetail:(ExamResultDetail*)detail
{
    if (!detail) {
        return NO;
    }
    
    __block BOOL res = NO;
    
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        
        res = [self addOneNewExamResultDetail:detail WithDB:db];
    }];
    
    return res;
}

-(BOOL)addOneNewExamResultDetail:(ExamResultDetail*)detail WithDB:(FMDatabase *)db
{
    if (!detail) {
        return NO;
    }
    
    BOOL res = NO;
    
    //生成sql语句
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ (user_exam_id,answer,submited,attach,question_id,paper_suit_question_id) VALUES ('%@','%@','%ld','%@',%ld,%ld)", ExamResultTable_Name,detail.userExamId,detail.answer,detail.submited,detail.attach,detail.questionId,detail.paperSuitQuestionId];
    
    res = [db executeUpdate:sql];
    
    return res;
}

/**
 从数据库中删除一条数据
 */
-(BOOL)deleteOneNewExamResultDetail:(ExamResultDetail*)detail
{
    
    if (!detail) {
        return NO;
    }
    
    __block BOOL res = NO;
    
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        
        res = [self deleteOneNewExamResultDetail:detail WithDB:db];
    }];
    
    return res;
}

-(BOOL)deleteOneNewExamResultDetail:(ExamResultDetail*)detail WithDB:(FMDatabase *)db
{
    BOOL res = NO;
    
    //生成sql语句
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE user_exam_id ='%@' and question_id = %ld", ExamResultTable_Name,detail.userExamId,detail.questionId];
    
    res = [db executeUpdate:sql];
    
    return res;
}


@end
