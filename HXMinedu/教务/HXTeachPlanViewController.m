//
//  HXTeachPlanViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//

#import "HXTeachPlanViewController.h"
#import "HXExaminationResultsViewController.h"
#import "HXTeachPlanCell.h"
#import "HXTeachPlanHeaderView.h"
#import "HXNoDataTipView.h"
#import "HXCourseTypeModel.h"


@interface HXTeachPlanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXNoDataTipView *noDataTipView;

@property(strong,nonatomic) NSMutableArray *dataArray;

///是否有分组头
@property(assign,nonatomic) BOOL isHaveHeader;

@end

@implementation HXTeachPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //布局子视图
    [self createUI];
    
}

#pragma mark - 布局子视图
-(void)createUI{
    [self.view addSubview:self.mainTableView];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    header.automaticallyChangeAlpha = YES;
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
    // 设置header
//    self.mainTableView.mj_header = header;
//    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.mainTableView.mj_footer = footer;
    
}

#pragma mark - setter
-(void)setCourseTypeList:(NSArray *)courseTypeList{
    _courseTypeList = courseTypeList;
    HXCourseTypeModel *model = courseTypeList.firstObject;
    ///根据courseTypeName是否为空判断，是否有分组
    self.isHaveHeader = ![HXCommonUtil isNull:model.courseTypeName];
    if (courseTypeList.count == 0) {
        [self.view addSubview:self.noDataTipView];
    }else{
        [self.noDataTipView removeFromSuperview];
    }
    
}


#pragma mark - 获取数据
-(void)loadNewData{
    
}
-(void)loadMoreData{
   
    

}



#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isHaveHeader? self.courseTypeList.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HXCourseTypeModel *model = self.courseTypeList.count>0?self.courseTypeList[section]:nil;
    return  self.isHaveHeader?(model.isExpand?model.courseList.count:0):model.courseList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HXCourseTypeModel *courseTypeModel = self.courseTypeList[indexPath.section];
    HXTeachCourseModel *teachCourseModel = courseTypeModel.courseList[indexPath.row];
    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                         model:teachCourseModel keyPath:@"teachCourseModel"
                                                     cellClass:([HXTeachPlanCell class])
                                              contentViewWidth:kScreenWidth];
    return rowHeight;

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
    if (self.isHaveHeader) {
        HXCourseTypeModel *model = self.courseTypeList[section];
        static NSString * teachPlanHeaderIdentifier = @"HXTeachPlanHeaderViewIdentifier";
        HXTeachPlanHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:teachPlanHeaderIdentifier];
        if (!headerView) {
            headerView = [[HXTeachPlanHeaderView alloc] initWithReuseIdentifier:teachPlanHeaderIdentifier];
        }
        headerView.model = model;
        ///展开/折叠回调
        headerView.expandCallBack = ^(void) {
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        return headerView;
    }else{
        return nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *teachPlanCellIdentifier = @"HXTeachPlanCellIdentifier";
    HXTeachPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:teachPlanCellIdentifier];
    if (!cell) {
        cell = [[HXTeachPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:teachPlanCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
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
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
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

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:self.mainTableView.bounds];
        _noDataTipView.tipTitle = @"暂无教学计划~";
    }
    return _noDataTipView;
}

@end
