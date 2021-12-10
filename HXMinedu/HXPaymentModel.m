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
        @"payableDetailsInfos" : @"t_PayableDetailsInfo_app",
        @"paidDetailsInfos"    : @"t_PaidDetailsInfo_app"
    };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"payableDetailsInfos" : @"HXPaymentDetailsInfoModel",
             @"paidDetailsInfos" : @"HXPaymentDetailsInfoModel"
            };
}

-(NSArray<HXPaymentDetailsInfoModel *> *)payableTypeList{
    if (_payableTypeList.count>0) {
        return _payableTypeList;
    }
    NSMutableArray *modeArray = [NSMutableArray array];
    [self.payableDetailsInfos enumerateObjectsUsingBlock:^(HXPaymentDetailsInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.payableDetailsInfoList.count>0) {
            [modeArray addObject:obj];
        }
    }];
    return modeArray;
}

-(NSArray<HXPaymentDetailsInfoModel *> *)paidDetailsTypeList{
    NSMutableArray *modeArray = [NSMutableArray array];
    [self.paidDetailsInfos enumerateObjectsUsingBlock:^(HXPaymentDetailsInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.paidDetailsOrderInfoList.count>0) {
            [modeArray addObject:obj];
        }
    }];
    return modeArray;
}


@end
