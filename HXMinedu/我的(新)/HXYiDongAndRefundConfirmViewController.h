//
//  HXYiDongConfirmViewController.h
//  HXMinedu
//
//  Created by mac on 2021/6/3.
//

#import "HXBaseViewController.h"
#import "HXYiDongAndRefundConfirmCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXYiDongAndRefundConfirmViewController : HXBaseViewController
///flag   0:异动确认 1:退费确认
@property(nonatomic,assign) HXConfirmType confirmType;

@end

NS_ASSUME_NONNULL_END
