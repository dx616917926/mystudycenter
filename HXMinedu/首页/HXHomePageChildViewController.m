//
//  HXHomePageChildViewController.m
//  HXMinedu
//
//  Created by mac on 2021/5/18.
//

#import "HXHomePageChildViewController.h"
#import "HXCommonWebViewController.h"
#import "HXShowH5ImageViewController.h"
#import "UIViewController+YNPageExtend.h"
#import "HXHomePageGuideCell.h"
#import "MJRefresh.h"

@interface HXHomePageChildViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *titleArray;
@property(nonatomic,assign) NSInteger pageIndex;
@end
/// 开启刷新头部高度
#define kOpenRefreshHeaderViewHeight 0

@implementation HXHomePageChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
    
    //获取首页栏目内容
    [self getHomePageInfoList];
    
    
}

#pragma mark - Setter
-(void)setHomePageColumnModel:(HXHomePageColumnModel *)homePageColumnModel{
    _homePageColumnModel = homePageColumnModel;
}


#pragma mark - 获取首页栏目内容
-(void)getHomePageInfoList{
    self.pageIndex = 1;
    NSDictionary *dic = @{
        @"id":HXSafeString(self.homePageColumnModel.columnId),
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetHomePageInfoList withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.tableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXColumnItemModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:list];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

-(void)loadMoreData{
    self.pageIndex++;
    NSDictionary *dic = @{
        @"id":HXSafeString(self.homePageColumnModel.columnId),
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetHomePageInfoList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.tableView.mj_footer endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXColumnItemModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.dataArray addObjectsFromArray:list];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        self.pageIndex--;
    }];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
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
    cell.columnItemModel = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXColumnItemModel *columnItemModel = self.dataArray[indexPath.row];
    HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
    webViewVC.urlString = columnItemModel.url;
    webViewVC.cuntomTitle = columnItemModel.name;
    webViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewVC animated:YES];
    
}

#pragma mark - UI
-(void)createUI{
    [self.view addSubview:self.tableView];
    // 刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHomePageInfoList)];
    header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - lazyload
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = YES;
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
