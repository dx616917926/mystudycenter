//
//  HXPaymentDetailsInfoModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "HXPaymentDetailModel.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXPaymentDetailsInfoModel : NSObject

///类型 1-标准 2-补录 3-报考
@property(nonatomic, assign) NSInteger ftype;
///类型名称
@property(nonatomic, copy) NSString *ftypeName;
///应缴小计
@property(nonatomic, assign) float feeSubtotal;
///实缴小计
@property(nonatomic, assign) float payMoneySubtotal;
///应缴明细  缴费条目数组
@property(nonatomic, strong) NSArray<HXPaymentDetailModel *> *payableDetailsInfoList;

///订单详情  缴费条目数组
@property(nonatomic, strong) NSArray<HXPaymentDetailModel *> *paidDetailsOrderInfoList;

///异动详情  缴费条目数组
@property(nonatomic, strong) NSArray<HXPaymentDetailModel *> *stopStudyByZzyAndZcpFeeInfoList;



@end

NS_ASSUME_NONNULL_END
