//
//  HXRefundMethodCell.h
//  HXMinedu
//
//  Created by mac on 2021/6/7.
//

#import <UIKit/UIKit.h>
#import "HXStudentRefundDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^InfoConfirmCallBack)(NSInteger payMode , NSString *khm , NSString *khh, NSString *khsk);

@class HXRefundMethodCell;
@protocol HXRefundMethodCellDelegate <NSObject>

@optional

-(void)refundMethodCell:(HXRefundMethodCell*)cell clickUpLoadBtn:(UIButton *)sender showRefundQRCodeImageView:(UIImageView *)refundQRCodeImageView;

-(void)refundMethodCell:(HXRefundMethodCell*)cell tapShowRefundQRCodeImageView:(UIImageView *)refundQRCodeImageView;

@end

@interface HXRefundMethodCell : UITableViewCell

@property(nonatomic,weak) id<HXRefundMethodCellDelegate> delegate;
@property(nonatomic,strong) HXStudentRefundDetailsModel *studentRefundDetailsModel;

@property(nonatomic,copy) InfoConfirmCallBack infoConfirmCallBack;

@property(nonatomic,assign) BOOL isInitialization;

@end

NS_ASSUME_NONNULL_END
