//
//  HXExamDayModel.m
//  HXMinedu
//
//  Created by mac on 2021/4/10.
//

#import "HXExamDayModel.h"

@implementation HXExamDayModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"examDayText" : @"ExamDayText",
        @"examDateSignInfoList" : @"t_ExamDateSignInfoList_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"examDateSignInfoList" : @"HXExamDateSignInfoModel"
            };
}
@end
