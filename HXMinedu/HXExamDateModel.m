//
//  HXExamDateModel.m
//  HXMinedu
//
//  Created by mac on 2021/4/10.
//

#import "HXExamDateModel.h"

@implementation HXExamDateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"examDate" : @"ExamDate",
        @"examDayList" : @"t_ExamDayList_app",
        @"examDateCourseScoreInfoList" : @"t_ExamDateCourseScoreInfoList_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"examDayList" : @"HXExamDayModel",
             @"examDateCourseScoreInfoList" : @"HXExamDateCourseScoreModel"
            };
}
@end
