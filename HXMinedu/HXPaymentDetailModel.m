//
//  HXPaymentDetailModel.m
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import "HXPaymentDetailModel.h"

@implementation HXPaymentDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"enrollFeeId" : @"Id"
    };
}
@end
