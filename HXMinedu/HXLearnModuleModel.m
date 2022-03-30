//
//  HXLearnModuleModel.m
//  HXMinedu
//
//  Created by mac on 2022/3/28.
//

#import "HXLearnModuleModel.h"


@implementation HXLearnModuleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"learnCourseItemList" : @"t_CourseInfoList_app"
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"learnCourseItemList" : @"HXLearnCourseItemModel"
             };
}

@end
