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
///查看凭证 PDFType: 1、收款凭证     2、交易凭证    3、发票凭证
-(void)paidDetailCell:(HXPaidDetailCell *)cell checkVoucher:(NSString *)receiptUrl pDFType:(NSInteger)PDFType;

@end

@interface HXPaidDetailCell : UITableViewCell

@property(nonatomic,weak) id<HXPaidDetailCellDelegate> delegate;
@property(nonatomic,strong) HXPaymentDetailModel *paymentDetailModel;

@end

NS_ASSUME_NONNULL_END
