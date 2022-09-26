//
//  HXScanCodePaymentModel.h
//  HXMinedu
//
//  Created by mac on 2021/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXScanCodePaymentModel : NSObject
///订单编号
@property(nonatomic, copy) NSString *orderNum;
///订单名称
@property(nonatomic, copy) NSString *addfeeType_Name;
///金额
@property(nonatomic, assign) float fee;
///订单时间
@property(nonatomic, copy) NSString *createDate;
///支付宝二维码URL
@property(nonatomic, copy) NSString *alipay_code;
///微信二维码URL
@property(nonatomic, copy) NSString *weixinpay_code;
///其它
@property(nonatomic, copy) NSString *qtpay_code;

@end

NS_ASSUME_NONNULL_END
