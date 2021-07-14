//
//  HXZzyAndZcpModel.h
//  HXMinedu
//
//  Created by mac on 2021/7/13.
//

#import <Foundation/Foundation.h>
#import "HXMajorInfoModel.h"
#import "HXYiDongInfoModel.h"
#import "HXPaymentDetailsInfoModel.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXZzyAndZcpModel : NSObject

///1-需要退费   0-不需要退费
@property(nonatomic, assign) NSInteger isRefund;
///结转金额总计
@property(nonatomic, assign) float costMoneyTotal;
///应付金额总计
@property(nonatomic, assign) float payMoneyTotal;
///结转应退金额
@property(nonatomic, assign) float refundTotal;
///异动模型
@property(nonatomic, strong) HXYiDongInfoModel *yiDongInfoModel;
///专业模型
@property(nonatomic, strong) HXMajorInfoModel *majorInfoModel;
///确认后异动模型
@property(nonatomic, strong) HXYiDongInfoModel *confirmedYiDongInfoModel;
///确认后旧专业模型
@property(nonatomic, strong) HXMajorInfoModel *confirmedOldMajorInfoModel;
///确认后新专业模型
@property(nonatomic, strong) HXMajorInfoModel *confirmedRecentMajorInfoModel;

///结转新专业模型
@property(nonatomic, strong) HXMajorInfoModel *jiezhuanMajorInfoModel;


///模型类型数组（标准、补录、报考）（应缴明细用）
@property(nonatomic, strong) NSArray<HXPaymentDetailsInfoModel *> *stopStudyByZzyAndZcpFeeList;

///新缴费条目数组
@property(nonatomic, strong) NSArray<HXPaymentDetailModel *> *stopStudyByZzyAndZcpNewMajorFeeInfoList;

@end

NS_ASSUME_NONNULL_END
