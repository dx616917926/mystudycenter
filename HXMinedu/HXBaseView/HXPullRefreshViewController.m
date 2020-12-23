//
//  HXPullRefreshViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/23.
//

#import "HXPullRefreshViewController.h"

@interface HXPullRefreshViewController ()

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, assign) CGFloat dragOffsetY;

@end

@implementation HXPullRefreshViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.tableViewInsertTop = kNavigationBarHeight;
    self.tableViewInsertBottom = 0;
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 0}];
    
    self.tableFooterView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 0}];
    
    [self configureTableView];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight+1)];
    self.tableView.backgroundColor = kControllerViewBackgroundColor;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetTop = 44;  //Notice
    }
    else{
        self.tableView.contentInsetTop = 64;  //Notice
    }
    [self.view addSubview:self.tableView];
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
    //[header beginRefreshing];
    
    // 设置header
    self.tableView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    MJRefreshBackNormalFooter * refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    refreshFooter.stateLabel.hidden = YES;
//    self.tableView.mj_footer = refreshFooter;
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kControllerViewBackgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.view.backgroundColor = kControllerViewBackgroundColor;
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.tableViewInsertTop, 0, self.tableViewInsertBottom, 0);
    
}

#pragma mark - Setters

//- (void)setHiddenEnabled:(BOOL)hiddenEnabled {
//
//    _hiddenEnabled = hiddenEnabled;
//
//
//}

#pragma mark - ScrollViewDelegate

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == self.tableView && [keyPath isEqualToString:@"contentSize"])
    {
        if (self.sc_navigationBarHidden) {
            CGSize newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
            CGSize oldValue = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            
            if (newValue.height != oldValue.height) {
                if (self.tableView.contentSizeHeight + self.tableView.contentInsetTop < kScreenHeight) {
                    [self sc_setNavigationBarHidden:NO animated:YES];
                }
            }
        }
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    if (scrollView.contentSizeHeight + scrollView.contentInsetTop < kScreenHeight) {
//        return;
//    }
//
//    CGFloat dragOffsetY = self.dragOffsetY - scrollView.contentOffsetY;
//
//    CGFloat contentOffset = scrollView.contentOffsetY + scrollView.contentInsetTop;
//
//    if (contentOffset < 43) {
//        [self sc_setNavigationBarHidden:NO animated:YES];
//        return;
//    }
//
//    if (dragOffsetY < - 30) {
//        [self sc_setNavigationBarHidden:YES animated:YES];
//        return;
//    }
//
//    if (dragOffsetY > 110) {
//        [self sc_setNavigationBarHidden:NO animated:YES];
//        return;
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragOffsetY = scrollView.contentOffsetY;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    return cell;
}

#pragma mark 下拉刷新数据
- (void)loadNewData
{
    //子类需要重写该方法
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    //子类需要重写该方法
}

#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    self.view.backgroundColor = kControllerViewBackgroundColor;
    self.tableView.backgroundColor = kControllerViewBackgroundColor;
    [self.tableView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
