//
//  HXPaymentDtailChildViewController.h
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXPaymentDtailChildViewController : HXBaseViewController
//flag:1.应缴明细   2.已缴明细  3.未缴明细
@property(nonatomic,assign) NSInteger flag;

@end

NS_ASSUME_NONNULL_END
