//
//  HXCourseLearnRecordModel.m
//  HXMinedu
//
//  Created by mac on 2021/5/10.
//

#import "HXCourseLearnRecordModel.h"

@implementation HXCourseLearnRecordModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"courseInfoList" : @"t_courseInfoList_app",
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"courseInfoList" : @"HXCourseModel"
             };
}
@end
