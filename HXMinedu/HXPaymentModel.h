//
//  HXPaymentModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import <Foundation/Foundation.h>
#import "HXPaymentDetailsInfoModel.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXPaymentModel : NSObject
///标题
@property(nonatomic, copy) NSString *title;
///专业ID
@property(nonatomic, copy) NSString *major_id;
///版本
@property(nonatomic, copy) NSString *version_id;
///
@property(nonatomic, assign) NSInteger type;
///在籍
@property(nonatomic, copy) NSString *studentStateName;
///8005和8006置灰其他正常
@property(nonatomic, assign) NSInteger studentStateId;
///实缴合计
@property(nonatomic, assign) float payMoneyTotal;
///应缴合计
@property(nonatomic, assign) float feeTotal;
///订单号
@property(nonatomic, copy) NSString *orderNum;
///支付方式
@property(nonatomic, copy) NSString *alias;
///支付类型 2-扫码    1-银联  
@property(nonatomic, assign) NSInteger payMode_id;
///银联支付跳转URL
@property(nonatomic, copy) NSString *payUrl;
///订单时间
@property(nonatomic, copy) NSString *createDate;
///支付时间
@property(nonatomic, copy) NSString *feeDate;
//订单类型  -1已支付待确认  1-已完成  0-未完成
@property(nonatomic, assign) NSInteger orderStatus;

///模型类型数组（标准、补录、报考）（应缴明细用）
@property(nonatomic, strong) NSArray<HXPaymentDetailsInfoModel *> *payableDetailsInfos;
@property(nonatomic, strong) NSArray<HXPaymentDetailsInfoModel *> *payableTypeList;///自己处理的过滤掉了空的数组
///模型类型数组（标准、补录、报考）( 订单详情用)
@property(nonatomic, strong) NSArray<HXPaymentDetailsInfoModel *> *paidDetailsInfos;
@property(nonatomic, strong) NSArray<HXPaymentDetailsInfoModel *> *paidDetailsTypeList;///自己处理的过滤掉了空的数组

@end

NS_ASSUME_NONNULL_END
