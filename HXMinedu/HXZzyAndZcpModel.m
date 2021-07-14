//
//  HXZzyAndZcpModel.m
//  HXMinedu
//
//  Created by mac on 2021/7/13.
//

#import "HXZzyAndZcpModel.h"

@implementation HXZzyAndZcpModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"yiDongInfoModel" : @"t_StopStudyByZzyAndZcpInfo_app",
        @"majorInfoModel"    : @"t_StopStudyByZzyAndZcpMajorInfo_app",
        @"stopStudyByZzyAndZcpFeeList": @"t_StopStudyByZzyAndZcpFee_app",
        @"confirmedYiDongInfoModel" : @"t_StopStudyConfirmedInfo_app",
        @"confirmedOldMajorInfoModel" : @"t_StopStudyConfirmedOldMajorInfo_app",
        @"confirmedRecentMajorInfoModel" : @"t_StopStudyConfirmedNewMajorInfo_app",
        @"jiezhuanMajorInfoModel" : @"t_StopStudyByZzyAndZcpNewMajorInfo_app",
        @"stopStudyByZzyAndZcpNewMajorFeeInfoList" : @"t_StopStudyByZzyAndZcpNewMajorFeeInfo_app"
    };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"stopStudyByZzyAndZcpFeeList" : @"HXPaymentDetailsInfoModel",
             @"stopStudyByZzyAndZcpNewMajorFeeInfoList" : @"HXPaymentDetailModel"
            };
}
@end
