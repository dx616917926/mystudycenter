//
//  HXPaidDetailCell.h
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import <UIKit/UIKit.h>
#import "HXPaymentDetailModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HXPaidDetailCell;
@protocol HXPaidDetailCellDelegate <NSObject>
///查看凭证
-(void)paidDetailCell:(HXPaidDetailCell *)cell checkVoucher:(NSString *)receiptUrl orderStatus:(NSInteger)orderStatus;

@end

@interface HXPaidDetailCell : UITableViewCell

@property(nonatomic,weak) id<HXPaidDetailCellDelegate> delegate;
@property(nonatomic,strong) HXPaymentDetailModel *paymentDetailModel;

@end

NS_ASSUME_NONNULL_END
