//
//  HXZiZhuOrderDetailsViewController.h
//  HXMinedu
//
//  Created by mac on 2021/12/8.
//

#import "HXBaseViewController.h"
#import "HXPaymentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXZiZhuOrderDetailsViewController : HXBaseViewController

//订单详情模型
@property(nonatomic,strong) HXPaymentModel *paidDetailsInfoModel;

@end

NS_ASSUME_NONNULL_END
