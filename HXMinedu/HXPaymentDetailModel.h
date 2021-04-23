//
//  HXPaymentDetailModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXPaymentDetailModel : NSObject
//名称
@property(nonatomic, copy) NSString *feeType_Name;
//总费用
@property(nonatomic, assign) float fee;
//单价
@property(nonatomic, assign) float avgfee;
//已缴费金额
@property(nonatomic, assign) float payMoney;
//未缴费金额
@property(nonatomic, assign) float notPay;
//数量
@property(nonatomic, copy) NSString *feeYearName;
//订单编号
@property(nonatomic, copy) NSString *orderNum;
//支付时间
@property(nonatomic, copy) NSString *feeDate;

@end

NS_ASSUME_NONNULL_END
