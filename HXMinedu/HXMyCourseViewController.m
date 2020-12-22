//
//  HXMyCourseViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import "HXMyCourseViewController.h"
#import "HXClassDetailViewController.h"
#import "HXCourseListTableViewCell.h"
#import "MJRefresh.h"
#import "HXCourseModel.h"
#import "HXGradeDropDownMenu.h"
#import "HXMajorModel.h"

@interface HXMyCourseViewController ()<UITableViewDelegate,UITableViewDataSource,HXGradeDropDownMenuDataSource,HXGradeDropDownMenuDelegate,HXCourseListTableViewCellDelegate>

@property(nonatomic, strong) UITableView *mTableView;
@property (nonatomic,strong) NSArray *majorsArr;       //专业数据数组
@property(nonatomic, strong) NSArray *courseListArray; //课程列表数组
@property (nonatomic,strong) HXGradeDropDownMenu *majorMenuView;//专业选单

@end

@implementation HXMyCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.courseListArray = [NSArray array];
    
    [self initTitleView];
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.courseListArray.count == 0) {
        [self.mTableView.mj_header beginRefreshing];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)initTitleView
{
    self.majorMenuView = [[HXGradeDropDownMenu alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth-80, 44)];
    self.majorMenuView.dataSource = self;
    self.majorMenuView.delegate = self;
    self.majorMenuView.destinationView = self.view;
    self.sc_navigationBar.titleView = self.majorMenuView;
}

- (void)initTableView {
    if (!self.mTableView) {
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-1) style:UITableViewStylePlain];
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mTableView.cellLayoutMarginsFollowReadableWidth = NO;
        self.mTableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
        if (@available(iOS 11.0, *)) {
            self.mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.mTableView registerNib:[UINib nibWithNibName:@"HXCourseListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HXCourseListTableViewCell"];
        [self.view addSubview:self.mTableView];
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        
        // 设置header
        self.mTableView.mj_header = header;
    }
}

- (void)loadNewData {
    
    [self requestMajorList];
    [self requestCourseList];
}

- (void)requestMajorList {
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MAJORLIST withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        //
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            self.majorsArr = [HXMajorModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            
            [self.majorMenuView reloadData];
        }else
        {
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
        //结束刷新状态
        [self.mTableView.mj_header endRefreshing];
        
    } failure:^(NSError * _Nonnull error) {
        
        
        //结束刷新状态
        [self.mTableView.mj_header endRefreshing];
    }];
}


- (void)requestCourseList {
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_COURSELIST withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        //
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            self.courseListArray = [HXCourseModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            
            [self.mTableView reloadData];
        }else
        {
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
        //结束刷新状态
        [self.mTableView.mj_header endRefreshing];
        
    } failure:^(NSError * _Nonnull error) {
        
        
        //结束刷新状态
        [self.mTableView.mj_header endRefreshing];
    }];
}


#pragma mark - 表视图代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXCourseListTableViewCell"];
    
    HXCourseModel *model = [self.courseListArray objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - HXCourseListTableViewCellDelegate

/// 点击了开始学习按钮
- (void)didClickStudyButtonInCell:(HXCourseListTableViewCell *)cell
{
    HXClassDetailViewController *detailVC = [[HXClassDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - HXGradeDropDownMenuDelegate

- (void)menu:(HXGradeDropDownMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (menu == self.majorMenuView) {
        HXMajorModel *major = [self.majorsArr objectAtIndex:indexPath.row];
        NSLog(@"修改成了这个专业了！%@",major.majorName);
        //发送切换专业的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kHXDidChangeMajor" object:nil];
    }
    
    [self.mTableView scrollsToTop];
    
    [self.mTableView.mj_header beginRefreshing];
}

#pragma mark - HXGradeDropDownMenuDataSource

- (NSInteger)menu:(HXGradeDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section
{
    //专业选单
    return self.majorsArr.count?1:0;
}

- (NSString *)menu:(HXGradeDropDownMenu *)menu collegeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (menu == self.majorMenuView) {
        //专业选单
        HXMajorModel *major = self.majorsArr[indexPath.row];
        if (major) {
            return major.majorName;
        }
    }
    return @"暂无数据";
}

@end
