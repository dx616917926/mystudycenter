//
//  HXCourseModel.m
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import "HXCourseModel.h"

@implementation HXCourseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"modules" : @"t_ExamCourseList"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"modules" : @"HXModelItem"
             };
}

@end
