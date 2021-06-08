//
//  HXRefundMethodCell.h
//  HXMinedu
//
//  Created by mac on 2021/6/7.
//

#import <UIKit/UIKit.h>
@class HXRefundMethodCell;


NS_ASSUME_NONNULL_BEGIN
@protocol HXRefundMethodCellDelegate <NSObject>

-(void)refundMethodCell:(HXRefundMethodCell*)cell clickUpLoadBtn:(UIButton *)sender showRefundQRCodeImageView:(UIImageView *)refundQRCodeImageView;

@end

@interface HXRefundMethodCell : UITableViewCell

@property(nonatomic,weak) id<HXRefundMethodCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
