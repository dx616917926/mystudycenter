//
//  HXHomePageChildViewController.m
//  HXMinedu
//
//  Created by mac on 2021/5/18.
//

#import "HXHomePageChildViewController.h"
#import "HXCommonWebViewController.h"
#import "UIViewController+YNPageExtend.h"
#import "HXHomePageGuideCell.h"
#import "MJRefresh.h"

@interface HXHomePageChildViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *titleArray;
@end
/// 开启刷新头部高度
#define kOpenRefreshHeaderViewHeight 0

@implementation HXHomePageChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    /// 添加刷新
//    [self addTableViewRefresh];
}
/// 添加下拉刷新
- (void)addTableViewRefresh {
    
    WeakSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArray removeAllObjects];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10; i++) {
                [weakSelf.dataArray addObject:@""];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
    
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10; i++) {
                [weakSelf.dataArray addObject:@""];
            }
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
            
        });
    }];
}



#pragma mark - UITableViewDelegate  UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 360;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *homePageGuideCellIdentifier = @"HXHomePageGuideCellIdentifier";
    HXHomePageGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:homePageGuideCellIdentifier];
    if (!cell) {
        cell = [[HXHomePageGuideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homePageGuideCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.count = self.count;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
    webViewVC.urlString = self.h5Url;
    webViewVC.cuntomTitle = self.titleArray[self.count-1];
    webViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewVC animated:YES];
}

#pragma mark - lazyload
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"成考报考指南",@"自考指南",@"国开指南",@"网教指南",@"职业资格精品课程",@"全日制学历报考攻略"];
    }
    return _titleArray;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.backgroundColor = COLOR_WITH_ALPHA(0xFDFDFD, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;

    }
    return _tableView;
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
