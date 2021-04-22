//
//  HXPaymentModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import <Foundation/Foundation.h>
#import "HXPaymentDetailModel.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXPaymentModel : NSObject
//合计
@property(nonatomic, assign) float total;
//数组
@property(nonatomic, strong) NSArray<HXPaymentDetailModel *> *payableAndUnpaidDetailsInfoList;

@end

NS_ASSUME_NONNULL_END
