//
//  HXLearnReportDetailViewController.m
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXLearnReportDetailViewController.h"
#import "HXLearnReportDetailCell.h"
#import "HXHistoryLearnReportDetailCell.h"
#import "HXLearnReportDetailHeadView.h"
#import "HXHistoryLearnReportDetailHeadView.h"

@interface HXLearnReportDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) HXLearnReportDetailHeadView *learnReportDetailHeadView;
@property(nonatomic,strong) HXHistoryLearnReportDetailHeadView *historyLearnReportDetailHeadView;

@end

@implementation HXLearnReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

#pragma mark - Setter
-(void)setIsHistory:(BOOL)isHistory{
    _isHistory = isHistory;
}

-(void)setCellType:(HXLearnReportCellType)cellType{
    _cellType = cellType;
}

-(void)pullDownRefrsh{
    [self.mainTableView.mj_header endRefreshing];
}

-(void)loadMoreData{
    [self.mainTableView.mj_footer endRefreshing];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isHistory?3:10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isHistory) {
        static NSString *historyLearnReportDetailCellIdentifier = @"HXHistoryLearnReportDetailCellIdentifier";
        HXHistoryLearnReportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:historyLearnReportDetailCellIdentifier];
        if (!cell) {
            cell = [[HXHistoryLearnReportDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyLearnReportDetailCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = self.cellType;
        return cell;
    }else{
        static NSString *learnReportDetailCellIdentifier = @"HXLearnReportDetailCellIdentifier";
        HXLearnReportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:learnReportDetailCellIdentifier];
        if (!cell) {
            cell = [[HXLearnReportDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:learnReportDetailCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = self.cellType;
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UI
-(void)createUI{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_14_5
    if (@available(iOS 15.0, *)) {
        self.mainTableView.sectionHeaderTopPadding = 0;
    }
#endif
    
    [self.view addSubview:self.mainTableView];
    if (self.isHistory) {
        switch (self.cellType) {
            case HXKeJianXueXiReportType:
                self.sc_navigationBar.title = @"视频历史学习报告";
                break;
            case HXPingShiZuoYeReportType:
                self.sc_navigationBar.title = @"作业历史学习报告";
                break;
            case HXQiMoKaoShiReportType:
                self.sc_navigationBar.title = @"考试历史学习报告";
                break;
            case HXLiNianZhenTiReportType:
                self.sc_navigationBar.title = @"真题历史学习报告";
                break;
                
            default:
                break;
        }
        self.mainTableView.tableHeaderView = self.historyLearnReportDetailHeadView;
        self.historyLearnReportDetailHeadView.cellType = self.cellType;
    
    }else{
        switch (self.cellType) {
            case HXKeJianXueXiReportType:
                self.sc_navigationBar.title = @"视频学习报告";
                break;
            case HXPingShiZuoYeReportType:
                self.sc_navigationBar.title = @"作业学习报告";
                break;
            case HXQiMoKaoShiReportType:
                self.sc_navigationBar.title = @"考试学习报告";
                break;
            case HXLiNianZhenTiReportType:
                self.sc_navigationBar.title = @"真题学习报告";
                break;
                
            default:
                break;
        }
        self.mainTableView.tableHeaderView = self.learnReportDetailHeadView;
        self.learnReportDetailHeadView.cellType = self.cellType;
    }
    
    
  
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefrsh)];
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
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = YES;
        _mainTableView.backgroundColor = [UIColor whiteColor];
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

- (HXLearnReportDetailHeadView *)learnReportDetailHeadView{
    if (!_learnReportDetailHeadView) {
        _learnReportDetailHeadView = [[HXLearnReportDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    }
    return _learnReportDetailHeadView;
}

-(HXHistoryLearnReportDetailHeadView *)historyLearnReportDetailHeadView{
    if (!_historyLearnReportDetailHeadView) {
        _historyLearnReportDetailHeadView = [[HXHistoryLearnReportDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    }
    return _historyLearnReportDetailHeadView;
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
