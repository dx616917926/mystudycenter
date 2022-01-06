//
//  HXPullRefreshViewController.h
//  HXMinedu
//
//  Created by Mac on 2020/12/23.
//

#import "HXBaseViewController.h"


@protocol HXPullRefreshDelegate <NSObject>

- (void)loadNewData;

- (void)loadMoreData;

@end

@interface HXPullRefreshViewController : HXBaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HXPullRefreshDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat tableViewInsertTop;
@property (nonatomic, assign) CGFloat tableViewInsertBottom;

- (void)didReceiveThemeChangeNotification;

@end
