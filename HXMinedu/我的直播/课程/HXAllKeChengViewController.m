//
//  HXAllKeChengViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXAllKeChengViewController.h"
#import "HXKeChengListViewController.h"
#import "HXCommonWebViewController.h"
#import "HXKeChengHeaderView.h"
#import "HXKeChengCell.h"

@interface HXAllKeChengViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *noDataView;

@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageIndex;

@property(nonatomic,assign) NSInteger keChengNum;

@end

@implementation HXAllKeChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self createUI];
    //获取直播课程列表
    [self loadData];
}

#pragma mark - 获取直播课程列表
-(void)loadData{
    
    self.pageIndex = 1;
    NSDictionary *dic = @{
        @"keyValue":@"",
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"type":@(1)//1全部课程 2回放
    };

    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveMealList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
       
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        NSDictionary *data = [dictionary objectForKey:@"Data"];
        if (success) {
            NSInteger rowCount = [[data stringValueForKey:@"rowCount"] integerValue];
            self.keChengNum = rowCount;
            NSArray *array = [HXKeChengModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"t_OnliveMealList_app"]];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            if (array.count == 0) {
                [self.mainTableView addSubview:self.noDataView];
            }else{
                [self.noDataView removeFromSuperview];
            }
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
       
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}

-(void)loadMoreData{
    
    self.pageIndex++;
    NSDictionary *dic = @{
        @"keyValue":@"",
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"type":@(1)//1全部课程 2回放
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveMealList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_footer endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        NSDictionary *data = [dictionary objectForKey:@"Data"];
        if (success) {
            NSArray *array = [HXKeChengModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"t_OnliveMealList_app"]];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            [self.dataArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_footer endRefreshing];
        self.pageIndex--;
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
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *keChengHeaderViewIdentifier = @"HXKeChengHeaderViewIdentifier";
    HXKeChengHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:keChengHeaderViewIdentifier];
    if (!headerView) {
        headerView = [[HXKeChengHeaderView alloc] initWithReuseIdentifier:keChengHeaderViewIdentifier];
    }
    headerView.numLabel.text =[NSString stringWithFormat:@"(%ld)",(long)self.keChengNum];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *keChengCellIdentifier = @"HXKeChengCellIdentifier";
    HXKeChengCell *cell = [tableView dequeueReusableCellWithIdentifier:keChengCellIdentifier];
    if (!cell) {
        cell = [[HXKeChengCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keChengCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.keChengModel = self.dataArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXKeChengModel *keChengModel = self.dataArray[indexPath.row];
    ///直播类型 1ClassIn   2保利威     保利威直接跳转页面直播     ClassIn进入下一页面展示课节
    if (keChengModel.LiveType==1) {
        HXKeChengListViewController *vc= [[HXKeChengListViewController alloc] init];
        vc.MealName = keChengModel.MealName;
        vc.mealGuid = keChengModel.MealGuid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
        webViewVC.urlString = keChengModel.liveUrl;
        webViewVC.cuntomTitle = keChengModel.MealName;
        webViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewVC animated:YES];
    }
   
}

#pragma mark - LazyLaod
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UI
-(void)createUI{

    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, 0)
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

    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.mainTableView.mj_footer = footer;
    self.mainTableView.mj_footer.hidden = YES;
    

}


- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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

-(UIView *)noDataView{
    if(!_noDataView){
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
        _noDataView.backgroundColor = UIColor.whiteColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"nokecheng_icon"];
        [_noDataView addSubview:imageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = HXFont(16);
        tipLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"暂无更多课程";
        [_noDataView addSubview:tipLabel];
        
        imageView.sd_layout
        .topSpaceToView(_noDataView, 13)
        .centerXEqualToView(_noDataView)
        .widthIs(298)
        .heightIs(339);
        
        tipLabel.sd_layout
        .topSpaceToView(imageView, 10)
        .leftEqualToView(_noDataView)
        .rightEqualToView(_noDataView)
        .heightIs(22);
    
    }
    return _noDataView;
}

@end
