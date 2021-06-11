//
//  HXRefundVoucherCell.h
//  HXMinedu
//
//  Created by mac on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "HXStudentRefundDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HXRefundVoucherCell;
@protocol HXRefundVoucherCellDelegate <NSObject>

-(void)refundVoucherCell:(HXRefundVoucherCell*)cell tapImageView:(UIImageView *)imageView url:(NSString *)url;

@end

@interface HXRefundVoucherCell : UITableViewCell

@property(nonatomic,weak) id<HXRefundVoucherCellDelegate> delegate;
@property(nonatomic,strong) HXStudentRefundDetailsModel *studentRefundDetailsModel;

@end

NS_ASSUME_NONNULL_END
