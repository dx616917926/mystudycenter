//
//  HXExamDetailViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/25.
//

#import "HXExamDetailViewController.h"
#import "HXExamDetailTopView.h"
#import "HXExamRecordCell.h"
#import "MJRefresh.h"

@interface HXExamDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) HXExamDetailTopView *topView;
@property(nonatomic, strong) HXBarButtonItem *leftBarItem;
@property(nonatomic, strong) UITableView *mTableView;
@property(nonatomic, strong) NSArray *dataSource;

@end

@implementation HXExamDetailViewController

-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kTableViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置导航栏透明度
    [self sc_setNavigationBarBackgroundAlpha:0];
    [self setSc_navigationBarHidden:YES];
    
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;

    self.sc_navigationBar.title = @"考试详情";
    
    [self initTopView];
    [self initTableView];
}

- (void)initTopView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exam_top_bg"]];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.48);
    [self.view addSubview:imageView];
    
    self.topView = [[UINib nibWithNibName:NSStringFromClass([HXExamDetailTopView class]) bundle:nil] instantiateWithOwner:self options:nil].lastObject;
    self.topView.frame = CGRectMake(30,kNavigationBarHeight + 30,kScreenWidth-60,148);
    self.topView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.topView.layer.cornerRadius = 8;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,0);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 4;
    [self.view addSubview:self.topView];
    
    self.topView.mExamTitleLabel.text = @"专升本大学语文模拟考试";
}

- (void)initTableView {
    if (!self.mTableView) {
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom+20, kScreenWidth, kScreenHeight-self.topView.bottom - 70) style:UITableViewStylePlain];
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mTableView.cellLayoutMarginsFollowReadableWidth = NO;
        self.mTableView.backgroundColor = kTableViewBackgroundColor;
        if (@available(iOS 11.0, *)) {
            self.mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.mTableView registerNib:[UINib nibWithNibName:@"HXExamRecordCell" bundle:nil] forCellReuseIdentifier:@"HXExamRecordCell"];
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
    if (self.dataSource.count == 0) {
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
    if (self.dataSource.count == 0) {
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
    
    [self requestCourseList];
}

- (void)requestCourseList {
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_COURSELIST withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        //
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
//            self.dataSource = [HXCourseModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            
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
    return 5;//self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXExamRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXExamRecordCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    HXCourseModel *model = [self.courseListArray objectAtIndex:indexPath.row];
    
//    cell.delegate = self;
//    cell.model = model;
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
