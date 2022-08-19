//
//  HXKeChengListViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/12.
//

#import "HXKeChengListViewController.h"
#import "HXCommonWebViewController.h"
#import "HXKeChengKeJieCell.h"

@interface HXKeChengListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HXKeChengListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self createUI];
    //获取直播课程详情
    [self loadData];
}

#pragma mark - Setter
- (void)setMealName:(NSString *)MealName{
    _MealName = MealName;
}

- (void)setMealGuid:(NSString *)mealGuid{
    _mealGuid = mealGuid;
}

#pragma mark - 获取直播课程详情
-(void)loadData{
    NSDictionary *dic = @{
        @"mealGuid":HXSafeString(self.mealGuid)
    };

    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveMealInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
       
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXKeJieModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.mainTableView reloadData];

        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *keChengKeJieCellIdentifier = @"HXKeChengKeJieCellIdentifier";
    HXKeChengKeJieCell *cell = [tableView dequeueReusableCellWithIdentifier:keChengKeJieCellIdentifier];
    if (!cell) {
        cell = [[HXKeChengKeJieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keChengKeJieCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.keJieModel = self.dataArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXKeJieModel *keJieModel = self.dataArray[indexPath.row];
    HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
    webViewVC.urlString = keJieModel.liveUrl;
    webViewVC.cuntomTitle = keJieModel.ClassName;
    webViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewVC animated:YES];
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.title = self.MealName;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0);
    [self.mainTableView updateLayout];
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    //设置header
    self.mainTableView.mj_header = header;

}


#pragma mark - LazyLaod
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = YES;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0.0;
            _mainTableView.estimatedSectionFooterHeight = 0.0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenBottomMargin, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        
    }
    return _mainTableView;
}

@end
