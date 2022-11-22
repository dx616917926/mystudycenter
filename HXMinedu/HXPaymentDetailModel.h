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
///
@property(nonatomic, copy) NSString *enrollFeeId;
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
///自助缴费是否可勾选
@property(nonatomic, assign) BOOL IsFee;
///本次实缴(用于记录自助缴费)
@property(nonatomic, assign) float benCiPayMoney;
///退费金额（退费详情用）
@property(nonatomic, assign) float refundMoney;
///结转金额（异动详情用）
@property(nonatomic, assign) float costMoney;
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
///订单类型  1待完成     2已完成    -1待审核    -2驳回      0未完成
@property(nonatomic, assign) NSInteger orderStatus;
///缴费/交易凭证url            学生上传缴费截图
@property(nonatomic, copy) NSString *proofUrl;
///收款凭证url                   财务老师出具的收据
@property(nonatomic, copy) NSString *receiptUrl;
///发票凭证url                  财务老师出具的发票
@property(nonatomic, copy) NSString *invoiceurl;
///订单属性 1报名  2结转  3自助缴费  4导入 其它续缴  为自助缴费时才可删除订单
@property(nonatomic, assign) NSInteger isMb;
//是否选中
@property(nonatomic, assign) BOOL isSeleted;

@end

NS_ASSUME_NONNULL_END
