//
//  HXLearnReportModel.m
//  HXMinedu
//
//  Created by mac on 2022/3/28.
//

#import "HXLearnReportModel.h"

@implementation HXLearnReportModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"learnModuleList" : @"t_CourseList_app"
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"learnModuleList" : @"HXLearnModuleModel"
             };
}

@end
