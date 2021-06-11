//
//  HXYinJiaoHeaderView.h
//  HXMinedu
//
//  Created by mac on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "HXPaymentModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    HXYingJiaoDetailsType,//应缴明细
    HXHistoricalDetailsType//历史明细
} HXHeaderViewType;

@interface HXYinJiaoHeaderView : UITableViewHeaderFooterView
@property(nonatomic,assign) HXHeaderViewType headerViewType;

@property(nonatomic,strong) HXPaymentModel *paymentModel;
@end

NS_ASSUME_NONNULL_END
