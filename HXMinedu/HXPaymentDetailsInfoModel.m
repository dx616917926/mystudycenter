//
//  HXPaymentDetailsInfoModel.m
//  HXMinedu
//
//  Created by mac on 2021/4/29.
//

#import "HXPaymentDetailsInfoModel.h"

@implementation HXPaymentDetailsInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"payableDetailsInfoList" : @"t_PayableDetailsInfoList_app",
        @"paidDetailsOrderInfoList" : @"t_PaidDetailsOrderInfo_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"payableDetailsInfoList" : @"HXPaymentDetailModel",
             @"paidDetailsOrderInfoList" : @"HXPaymentDetailModel"
             };
}
@end
