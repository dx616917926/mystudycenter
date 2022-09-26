//
//  HXExamListViewController.h
//  HXMinedu
//
//  Created by Mac on 2021/1/12.
//

#import "HXPullRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXExamListViewController : HXPullRefreshViewController

@property(nonatomic, strong) NSString *authorizeUrl;

@property(nonatomic, strong) NSString *StartDate;
@property(nonatomic, strong) NSString *EndDate;

@end

NS_ASSUME_NONNULL_END
