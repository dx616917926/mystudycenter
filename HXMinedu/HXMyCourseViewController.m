//
//  HXMyCourseViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import "HXMyCourseViewController.h"
//#import "HXClassDetailViewController.h"
#import "HXCourseListTableViewCell.h"
#import "MJRefresh.h"
#import "HXCourseModel.h"
#import "HXGradeDropDownMenu.h"
#import "HXMajorModel.h"
#import "HXCwsCourseware.h"
#import "TXMoviePlayerController.h"
#import "HXExamListViewController.h"

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
    
    //退出登录的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:SHOWLOGIN object:nil];
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

//退出登录，清空数据
- (void)loginOut{
    self.majorsArr = [NSArray array];
    [self.majorMenuView dismiss];
    self.courseListArray = [NSArray array];
    [self.mTableView reloadData];
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
        self.mTableView.backgroundColor = kTableViewBackgroundColor;
        self.mTableView.estimatedRowHeight = 190;
        self.mTableView.rowHeight = UITableViewAutomaticDimension;
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

-(void)setRequestFiledView
{
    if (self.courseListArray.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((blankBg.width-190)/2, blankBg.height - 290, 190, 190)];
        [iconView setImage:[UIImage imageNamed:@"network_error_icon"]];
        [blankBg addSubview:iconView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((blankBg.width-230)/2, iconView.bottom, 230, 30)];
        label.text = @"网络不给力，请点击重新加载~";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0.662 green:0.662 blue:0.662 alpha:1.0];
        [blankBg addSubview:label];
        
        UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        retryButton.frame = CGRectMake((blankBg.width-160)/2, blankBg.height - 50, 160, 40);
        [retryButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [retryButton.titleLabel setFont:[UIFont systemFontOfSize:19]];
        [retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [retryButton addTarget:self.mTableView.mj_header action:@selector(beginRefreshing) forControlEvents:UIControlEventTouchUpInside];
        retryButton.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:1.0].CGColor;
        retryButton.layer.cornerRadius = 20;
        retryButton.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:0.5].CGColor;
        retryButton.layer.shadowOffset = CGSizeMake(0,0);
        retryButton.layer.shadowOpacity = 1;
        retryButton.layer.shadowRadius = 4;
        [blankBg addSubview:retryButton];
        
        [self.mTableView setTableHeaderView:blankBg];
    }else
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        view.backgroundColor = [UIColor clearColor];
        self.mTableView.tableHeaderView = view;
    }
}

-(void)setTableHeaderView
{
    if (self.courseListArray.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-300)/2, 30, 320, 300)];
        logoImg.image = [UIImage imageNamed:@"course_no"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 80)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"暂无课程~";
        warnMsg.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
        warnMsg.font = [UIFont systemFontOfSize:16];
        warnMsg.textAlignment = NSTextAlignmentCenter;
        [blankBg addSubview:warnMsg];
        [self.mTableView setTableHeaderView:blankBg];
    }else
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        view.backgroundColor = [UIColor clearColor];
        self.mTableView.tableHeaderView = view;
    }
}

- (void)loadNewData {
    
    if (!self.isLogin) {
        
        [self.view showErrorWithMessage:@"请先登录！"];
        //结束刷新状态
        [self.mTableView.mj_header endRefreshing];
        return;
    }
    
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
        
    } failure:^(NSError * _Nonnull error) {
        
        [self.majorMenuView reloadData];
        
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
            
            [self setTableHeaderView];
            
            [self.mTableView reloadData];
        }else
        {
            [self setRequestFiledView];
            
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
        //结束刷新状态
        [self.mTableView.mj_header endRefreshing];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self setRequestFiledView];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXCourseListTableViewCell"];
    
    HXCourseModel *model = [self.courseListArray objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
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

/// 点击了模块按钮
- (void)didClickStudyButtonWithModel:(HXModelItem *)modelItem
{
    if (modelItem.Message) {
        [self.view showTostWithMessage:modelItem.Message];
        return;
    }
    
    if ([modelItem.Type isEqualToString:@"1"]) {
        //课件学习模块
        TXMoviePlayerController *playerVC = [[TXMoviePlayerController alloc] init];
        playerVC.cws_param = modelItem.cws_param;
        playerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playerVC animated:YES];
        
    }else if ([modelItem.Type isEqualToString:@"2"]) {
        //考试模块
        HXExamListViewController *listVC = [[HXExamListViewController alloc] init];
        listVC.authorizeUrl = modelItem.ExamUrl;
        listVC.title = modelItem.ModuleName;
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

//
///// 点击了平时作业按钮
//- (void)didClickExamButtonInCell:(HXCourseListTableViewCell *)cell
//{
//    //这个页面已经作废了----2021年01月20日
//    HXClassDetailViewController *detailVC = [[HXClassDetailViewController alloc] init];
//    detailVC.courseModel = cell.model;
//    detailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
//}

/// 点击了学习情况按钮
- (void)didClickReportButtonInCell:(HXCourseListTableViewCell *)cell
{
    
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
