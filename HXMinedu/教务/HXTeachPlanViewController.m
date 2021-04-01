//
//  HXTeachPlanViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//

#import "HXTeachPlanViewController.h"
#import "HXTeachPlanCell.h"
#import "HXTeachPlanHeaderView.h"
#import "HXExaminationResultsViewController.h"
#import "MJRefresh.h"
#import "HXCourseTypeModel.h"
#import "HXTeachPlanModel.h"

@interface HXTeachPlanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *mainTableView;

@property(strong,nonatomic) NSMutableArray *dataArray;

///是否有分组头
@property(assign,nonatomic) BOOL isHaveHeader;

@end

@implementation HXTeachPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //获取数据
    [self loadData];
    //布局子视图
    [self createUI];
    
    
}

#pragma mark - 布局子视图
-(void)createUI{
    [self.view addSubview:self.mainTableView];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    // 设置header
    self.mainTableView.mj_header = header;
//    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.mainTableView.mj_footer = footer;
    
}

#pragma mark - setter
-(void)setCourseTypeList:(NSArray *)courseTypeList{
    _courseTypeList = courseTypeList;
    HXCourseTypeModel *model = courseTypeList.firstObject;
    ///根据courseTypeName是否为空判断，是否有分组
    self.isHaveHeader = ![HXCommonUtil isNull:model.courseTypeName];
    
}


#pragma mark - 获取数据
-(void)loadNewData{
    [self.view showLoading];
    [self.mainTableView.mj_header endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.view hideLoading];
    });
}
-(void)loadMoreData{
    [self.view showLoading];
    [self.mainTableView.mj_footer endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view hideLoading];
        self.mainTableView.mj_footer.hidden = YES;
    });
    
   
}

-(void)loadData{
    HXTeachPlanModel *model1 = [HXTeachPlanModel new];
    model1.title = @"必修课";
    model1.num = 3;
    
    [self.dataArray addObject:model1];
    
    HXTeachPlanModel *model2 = [HXTeachPlanModel new];
    model2.title = @"选修课";
    model2.num = 4;
    model2.isExpand = YES;
    [self.dataArray addObject:model2];
    
    HXTeachPlanModel *model3 = [HXTeachPlanModel new];
    model3.title = @"实践课课";
    model3.num = 5;
    [self.dataArray addObject:model3];
    
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isHaveHeader? self.courseTypeList.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HXCourseTypeModel *model = self.courseTypeList[section];
    return  self.isHaveHeader?(model.isExpand?model.courseList.count:0):model.courseList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.isHaveHeader?74:0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HXCourseTypeModel *model = self.courseTypeList[section];
    static NSString * teachPlanHeaderIdentifier = @"HXTeachPlanHeaderViewIdentifier";
    HXTeachPlanHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:teachPlanHeaderIdentifier];
    if (!headerView) {
        headerView = [[HXTeachPlanHeaderView alloc] initWithReuseIdentifier:teachPlanHeaderIdentifier];
    }
    headerView.model = model;
    ///展开/折叠回调
    headerView.expandCallBack = ^(void) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *teachPlanCellIdentifier = @"HXTeachPlanCellIdentifier";
    HXTeachPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:teachPlanCellIdentifier];
    if (!cell) {
        cell = [[HXTeachPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:teachPlanCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HXCourseTypeModel *courseTypeModel = self.courseTypeList[indexPath.section];
    HXTeachCourseModel *teachCourseModel = courseTypeModel.courseList[indexPath.row];
    cell.teachCourseModel = teachCourseModel;
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    HXExaminationResultsViewController *vc = [[HXExaminationResultsViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - lazyload
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-58) style:UITableViewStyleGrouped];
        _mainTableView.bounces = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0;
            _mainTableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}


@end
