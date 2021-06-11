//
//  HXRefundDetailsViewController.h
//  HXMinedu
//
//  Created by mac on 2021/6/4.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefundRefreshCallBack)(void);

@interface HXRefundDetailsViewController : HXBaseViewController
///退费id
@property(nonatomic, copy) NSString *refundId;

@property(nonatomic, copy) RefundRefreshCallBack refundRefreshCallBack;


@end

NS_ASSUME_NONNULL_END
