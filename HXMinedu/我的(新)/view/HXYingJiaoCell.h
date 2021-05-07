//
//  HXYingJiaoCell.h
//  HXMinedu
//
//  Created by mac on 2021/4/28.
//

#import <UIKit/UIKit.h>
#import "HXPaymentDetailsInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    HXYingJiaoShowType,//应缴明细
    HXOrderDetailsShowType//订单详情
} HXCellShowType;

@interface HXYingJiaoCell : UITableViewCell

@property(nonatomic,assign) HXCellShowType showType;

@property(nonatomic,strong) HXPaymentDetailsInfoModel *paymentDetailsInfoModel;
@end

NS_ASSUME_NONNULL_END
