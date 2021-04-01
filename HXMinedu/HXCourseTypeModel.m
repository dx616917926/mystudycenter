//
//  HXCourseTypeModel.m
//  HXMinedu
//
//  Created by mac on 2021/4/1.
//

#import "HXCourseTypeModel.h"

@implementation HXCourseTypeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"courseList" : @"t_CourseScoreInfoList_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"courseList" : @"HXTeachCourseModel"
             };
}

@end
