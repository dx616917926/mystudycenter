//
//  HXTuiXueYiDongDetailsViewController.h
//  HXMinedu
//
//  Created by mac on 2021/7/9.
//

#import "HXBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^RefundRefreshCallBack)(void);

@interface HXTuiXueYiDongDetailsViewController : HXBaseViewController
///退费id
@property(nonatomic, copy) NSString *stopStudyId;

@property(nonatomic, copy) RefundRefreshCallBack refundRefreshCallBack;

@end

NS_ASSUME_NONNULL_END
