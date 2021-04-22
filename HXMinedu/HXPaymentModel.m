//
//  HXPaymentModel.m
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import "HXPaymentModel.h"

@implementation HXPaymentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"payableAndUnpaidDetailsInfoList" : @"t_PayableAndUnpaidDetailsInfoList_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"payableAndUnpaidDetailsInfoList" : @"HXPaymentDetailModel"
             };
}
@end
