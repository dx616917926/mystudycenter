//
//  HXHomePageChildViewController.h
//  HXMinedu
//
//  Created by mac on 2021/5/18.
//

#import "HXBaseViewController.h"
#import "HXHomePageColumnModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXHomePageChildViewController : HXBaseViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HXHomePageColumnModel *homePageColumnModel;

@end

NS_ASSUME_NONNULL_END
