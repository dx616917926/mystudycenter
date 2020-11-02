//
//  TXCatalog.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/23.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXCatalog.h"

@implementation TXCatalog

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"catalogKnowledgePoints" : @"TXCatalogKnowledgePoint",
             @"lectures" : @"TXLecture",
             @"questions" : @"TXQuestion"
             };
}

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (TXQuestion *question in self.questions) {
        [dic setObject:question forKey:question.mediaTime];
    }
    self.questionMediaTimeDic = dic;
}

@end
