//
//  HXLeaveApplyViewController.h
//  HXMinedu
//
//  Created by mac on 2022/9/21.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^QingJiaSuccessCallBack)(void);

@interface HXLeaveApplyViewController : HXBaseViewController

@property(nonatomic,strong) NSString *ClassGuid;

@property(nonatomic,copy) QingJiaSuccessCallBack qingJiaSuccessCallBack;

@end

NS_ASSUME_NONNULL_END
