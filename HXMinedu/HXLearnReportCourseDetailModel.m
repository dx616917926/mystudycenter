//
//  HXLearnReportCourseDetailModel.m
//  HXMinedu
//
//  Created by mac on 2022/3/29.
//

#import "HXLearnReportCourseDetailModel.h"

@implementation HXLearnReportCourseDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"learnItemDetailList" : @"t_LearnReportKjInfo_app",
        @"learnExamItemDetailList" : @"t_LearnReportExamInfo_app"
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"learnItemDetailList" : @"HXLearnItemDetailModel",
             @"learnExamItemDetailList" : @"HXLearnItemDetailModel"
             };
}
@end
