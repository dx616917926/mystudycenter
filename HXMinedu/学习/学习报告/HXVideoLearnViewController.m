//
//  HXVideoLearnViewController.m
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXVideoLearnViewController.h"
#import "HXLearnReportDetailViewController.h"
#import "HXLearnReportCell.h"
#import "HXHistoryLearnReportCell.h"
#import "HXLearnReportDetailViewController.h"

@interface HXVideoLearnViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HXVideoLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

#pragma mark - Setter
-(void)setIsHistory:(BOOL)isHistory{
    _isHistory = isHistory;
}

-(void)setCreateDate:(NSString *)createDate{
    _createDate = createDate;
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
    return self.learnCourseItemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isHistory) {
        static NSString *historyLearnReportCellIdentifier = @"HXHistoryLearnReportCellIdentifier";
        HXHistoryLearnReportCell *cell = [tableView dequeueReusableCellWithIdentifier:historyLearnReportCellIdentifier];
        if (!cell) {
            cell = [[HXHistoryLearnReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyLearnReportCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = HXKeJianXueXiReportType;
        if (indexPath.row<self.learnCourseItemList.count) {
            cell.learnCourseItemModel = self.learnCourseItemList[indexPath.row];
        }
        return cell;
    }else{
        static NSString *learnReportCellIdentifier = @"HXLearnReportCellIdentifier";
        HXLearnReportCell *cell = [tableView dequeueReusableCellWithIdentifier:learnReportCellIdentifier];
        if (!cell) {
            cell = [[HXLearnReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:learnReportCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = HXKeJianXueXiReportType;
        if (indexPath.row<self.learnCourseItemList.count) {
            cell.learnCourseItemModel = self.learnCourseItemList[indexPath.row];
        }
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXLearnReportDetailViewController *vc = [[HXLearnReportDetailViewController alloc] init];
    vc.ModuleName = self.ModuleName;
    vc.isHistory = self.isHistory;
    if (indexPath.row<self.learnCourseItemList.count) {
        vc.learnCourseItemModel = self.learnCourseItemList[indexPath.row];
    }
    if (self.isHistory) {
        vc.createDate = self.createDate;
    }
    vc.cellType = HXKeJianXueXiReportType;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UI
-(void)createUI{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_14_5
    if (@available(iOS 15.0, *)) {
        self.mainTableView.sectionHeaderTopPadding = 0;
    }
#endif

    [self.view addSubview:self.mainTableView];
  
    
    
//    // 下拉刷新
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefrsh)];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    header.automaticallyChangeAlpha = YES;
//    //设置header
//    self.mainTableView.mj_header = header;
//    
//    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.mainTableView.mj_footer = footer;
//    self.mainTableView.mj_footer.hidden = YES;
}


- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
