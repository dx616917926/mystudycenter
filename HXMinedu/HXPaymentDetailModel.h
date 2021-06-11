//
//  HXPaymentDetailModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXPaymentDetailModel : NSObject
///标题
@property(nonatomic, copy) NSString *title;
///订单合成名称
@property(nonatomic, copy) NSString *feeType_Names;
///名称
@property(nonatomic, copy) NSString *feeType_Name;
///应缴
@property(nonatomic, assign) float fee;
///单价
@property(nonatomic, assign) float avgfee;
///实缴
@property(nonatomic, assign) float payMoney;
///退费金额（退费详情用）
@property(nonatomic, assign) float refundMoney;
///未缴费金额
@property(nonatomic, assign) float notPay;
///数量
@property(nonatomic, copy) NSString *feeYearName;
///订单编号
@property(nonatomic, copy) NSString *orderNum;
///支付时间
@property(nonatomic, copy) NSString *feeDate;
///订单时间
@property(nonatomic, copy) NSString *createDate;
///订单类型  -1已支付待确认  1-已完成  0-未完成
@property(nonatomic, assign) NSInteger orderStatus;
///收据凭证url
@property(nonatomic, copy) NSString *receiptUrl;
///交易凭证url
@property(nonatomic, copy) NSString *proofUrl;


@end

NS_ASSUME_NONNULL_END
