//
//  HXPaymentDtailChildViewController.h
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXPaymentDtailChildViewController : HXBaseViewController
//flag: 0.应缴明细(标准明细) 1.其他服务   2.全部订单  
@property(nonatomic,assign) NSInteger flag;

@end

NS_ASSUME_NONNULL_END
