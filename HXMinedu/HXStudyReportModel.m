//
//  HXStudyReportModel.m
//  HXMinedu
//
//  Created by mac on 2021/4/12.
//

#import "HXStudyReportModel.h"

@implementation HXStudyReportModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"kjxxCourseList" : @"t_kjxxCourseList_app",
        @"zscpCourseList" : @"t_zscpCourseList_app",
        @"pszyCourseList" : @"t_pszyCourseList_app",
        @"qmcjCourseList" : @"t_qmcjCourseList_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"kjxxCourseList" : @"HXCourseDetailModel",
             @"zscpCourseList" : @"HXCourseDetailModel",
             @"pszyCourseList" : @"HXCourseDetailModel",
             @"qmcjCourseList" : @"HXCourseDetailModel"
             };
}
@end
