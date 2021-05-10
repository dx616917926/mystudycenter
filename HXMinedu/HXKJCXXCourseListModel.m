//
//  HXKJCXXCourseListModel.m
//  HXMinedu
//
//  Created by mac on 2021/5/10.
//

#import "HXKJCXXCourseListModel.h"

@implementation HXKJCXXCourseListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"nowadaysList" : @"t_nowadaysList_app",
             @"yesterdayList" : @"t_yesterdayList_app"
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"nowadaysList" : @"HXLearnRecordModel",
             @"yesterdayList" : @"HXLearnRecordModel"
             };
}
@end
