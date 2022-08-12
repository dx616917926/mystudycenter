//
//  HXUnPaidDetailCell.h
//  HXMinedu
//
//  Created by mac on 2021/4/22.
//

#import <UIKit/UIKit.h>
#import "HXPaymentDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HXUnPaidDetailCellDelegate <NSObject>
///删除订单
-(void)deleteOrderNum:(HXPaymentDetailModel *)paymentDetailModel;

@end

@interface HXUnPaidDetailCell : UITableViewCell

@property(nonatomic,weak) id<HXUnPaidDetailCellDelegate> delegate;

@property(nonatomic,strong) HXPaymentDetailModel *paymentDetailModel;

@end

NS_ASSUME_NONNULL_END
