//
//  HXOrderDetailsViewController.h
//  HXMinedu
//
//  Created by mac on 2021/4/29.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXOrderDetailsViewController : HXBaseViewController

//flag:1.待支付订单详情   2.已支付订单详情 
@property(nonatomic,assign) NSInteger flag;
//订单号
@property(nonatomic,strong) NSString *orderNum;


@end

NS_ASSUME_NONNULL_END
