//
//  HXHomePageChildViewController.h
//  HXMinedu
//
//  Created by mac on 2021/5/18.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXHomePageChildViewController : HXBaseViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *h5Url;
@end

NS_ASSUME_NONNULL_END
