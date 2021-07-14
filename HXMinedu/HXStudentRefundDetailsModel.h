//
//  HXStudentRefundDetailsModel.h
//  HXMinedu
//
//  Created by mac on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "HXPaymentDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXStudentRefundDetailsModel : NSObject
///退费id
@property(nonatomic, copy) NSString *refundId;
///时间
@property(nonatomic, copy) NSString *createtime;
///退费类型
@property(nonatomic, copy) NSString *refundTypeName;
///退费原因
@property(nonatomic, copy) NSString *why;
///姓名
@property(nonatomic, copy) NSString *name;
///身份证号码
@property(nonatomic, copy) NSString *personId;
///1银联 2扫码
@property(nonatomic, assign) NSInteger payMode;
///开户名
@property(nonatomic, copy) NSString *khm;
///开户行
@property(nonatomic, copy) NSString *khh;
///退款帐号
@property(nonatomic, copy) NSString *khsk;
///退款二维码
@property(nonatomic, copy) NSString *skewm;
///退款总额
@property(nonatomic, assign) float refundTotal;
///0-待确认           1-确认无误       2-待退费  4-已退费     3-已驳回  5-已撤消
///0-时不显示任何标签   1-时显示审核中   2和4-时显示已通过       3和5-时不显示标签
@property(nonatomic, assign) NSInteger reviewStatus;
///状态
@property(nonatomic, copy) NSString *reviewStatusName;
///驳回意见
@property(nonatomic, copy) NSString *rejectRemark;
///驳回时间
@property(nonatomic, copy) NSString *rejectTime;
///审核意见
@property(nonatomic, copy) NSString *reviewerRemark;

///审核时间
@property(nonatomic, copy) NSString *reviewerTime;
///订单详情  缴费条目数组
@property(nonatomic, strong) NSArray<HXPaymentDetailModel *> *studentRefundInfoList;
///退款材料
@property(nonatomic, copy) NSString *appendix1;
@property(nonatomic, copy) NSString *appendix2;
@property(nonatomic, copy) NSString *appendix3;
@property(nonatomic, copy) NSString *appendix4;
///退款材料
@property(nonatomic, strong) NSArray *appendixList;

@end

NS_ASSUME_NONNULL_END
