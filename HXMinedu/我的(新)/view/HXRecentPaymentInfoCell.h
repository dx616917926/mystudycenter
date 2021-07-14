//
//  HXRecentPaymentInfoCell.h
//  HXMinedu
//
//  Created by mac on 2021/7/8.
//

#import <UIKit/UIKit.h>
#import "HXZzyAndZcpModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface HXRecentPaymentInfoCell : UITableViewCell

@property(nonatomic,strong) HXPaymentDetailsInfoModel *paymentDetailsInfoModel;

@property(nonatomic,strong) HXZzyAndZcpModel *zzyAndZcpModel;

@end

NS_ASSUME_NONNULL_END
