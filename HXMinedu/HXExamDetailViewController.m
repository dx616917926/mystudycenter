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
#import "NSDate+HXDate.h"
#import "HXStartExamViewController.h"

@interface HXExamDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HXExamRecordCellDelegate>
{
    BOOL scoreSecret; //是否隐藏成绩
}
@property(nonatomic, strong) HXExamDetailTopView *topView;
@property(nonatomic, strong) HXBarButtonItem *leftBarItem;
@property(nonatomic, strong) UITableView *mTableView;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) UIButton *bottomStartExamButton;
@property(nonatomic, strong) NSDictionary *dataResult;

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
    [self initStartExamButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mTableView.mj_header beginRefreshing];
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
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom+14, kScreenWidth, self.bottomStartExamButton.y-self.topView.bottom - 24) style:UITableViewStylePlain];
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

- (void)initStartExamButton {
    [self.view addSubview:self.bottomStartExamButton];
}

-(UIButton *)bottomStartExamButton
{
    if (_bottomStartExamButton == nil) {
        _bottomStartExamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat bottomMargin = IS_iPhoneX?30:18;
        CGFloat height = 48;
        [_bottomStartExamButton setFrame:CGRectMake(self.topView.x, kScreenHeight-height-bottomMargin, self.topView.width, height)];
        [_bottomStartExamButton setTitle:@"开始考试" forState:UIControlStateNormal];
        [_bottomStartExamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomStartExamButton setBackgroundColor:kNavigationBarColor];
        _bottomStartExamButton.layer.cornerRadius = 24;
        [_bottomStartExamButton addTarget:self action:@selector(didClickStartExamButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bottomStartExamButton;
}

-(void)setRequestFiledView
{
    if (self.dataSource.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        
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
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-300)/2, 0, 320, 300)];
        logoImg.image = [UIImage imageNamed:@"course_no"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 30)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"暂无考试记录~";
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
    
    [self requestExamRecordList];
}

//请求考试记录数据
- (void)requestExamRecordList
{
    //__weak typeof(self) bself = self;
    
    NSString * url = [NSString stringWithFormat:@"%@%@",HXEXAM_RESULT_JSON,self.exam.examId];
    
    [HXExamSessionManager getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dictionary) {
        if ([[dictionary objectForKey:@"success"] intValue] == 1) {
            NSLog(@"%@",dictionary);
            
            self.dataResult = [NSDictionary dictionaryWithDictionary:dictionary];
            self.dataSource = [NSArray arrayWithArray:[dictionary objectForKey:@"records"]];
            
            if([[dictionary objectForKey:@"scoreSecret"] integerValue] == 1)
            {
                self->scoreSecret = YES;
            }
            
            [self setTableHeaderView];
            
            [self.mTableView reloadData];
        }else
        {
            [self setRequestFiledView];
            
            [self.view showErrorWithMessage:@"获取考试记录失败,请重试!"];
        }
        //设置空白页
        [self setTableHeaderView];
        
        [self.mTableView reloadData];
        
        //结束刷新状态
        [self.mTableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
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
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXExamRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXExamRecordCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.mTitleLabel.text =[NSString stringWithFormat:@"第%ld次考试",self.dataSource.count - indexPath.row];
    
    NSDictionary *resource = [self.dataSource objectAtIndex:indexPath.row];

    NSDate *beginTime = [NSDate dateWithTimeIntervalSince1970:[[resource objectForKey:@"beginTime"] longLongValue]/1000];
    cell.mTimeLabel.text = [NSString stringWithFormat:@"开考试卷：%@",[beginTime timeString]];

    cell.dataSource = resource;
    cell.delegate = self;
    
    if (scoreSecret) {
        //隐藏分数
        cell.mScoreLabel.hidden = YES;
    }else
    {
        if ([[resource objectForKey:@"checked"] boolValue]) {
            
            if ([[resource objectForKey:@"score"] intValue] >= 0) {
                
                NSString * s = [NSString stringWithFormat:@"%.1f",[[resource objectForKey:@"score"] floatValue]];
                cell.mScoreLabel.text = [NSString stringWithFormat:@"%g分",s.floatValue];
                
                //及格分数颜色
                if (s.floatValue > 60) {
                    cell.mScoreLabel.textColor = [UIColor colorWithRed:70/255.0 green:167/255.0 blue:79/255.0 alpha:1.0];
                }else
                {
                    cell.mScoreLabel.textColor = [UIColor colorWithRed:254/255.0 green:98/255.0 blue:75/255.0 alpha:1.0];
                }
            }
            else
            {
                cell.mScoreLabel.text = @"交白卷";
                
                cell.mScoreLabel.textColor = [UIColor colorWithRed:254/255.0 green:98/255.0 blue:75/255.0 alpha:1.0];
            }
            
        }else{
            cell.mScoreLabel.text = @"处理中…";
            
            cell.mScoreLabel.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0];
        }
    }
    
    //是否可以继续考试
    if ([[resource objectForKey:@"canContinue"] boolValue]) {
        cell.mContinueExamButton.enabled = YES;

        [cell.mContinueExamButton setBackgroundColor:[UIColor whiteColor]];
        cell.mContinueExamButton.layer.borderColor = kNavigationBarColor.CGColor;
    }else
    {
        cell.mContinueExamButton.enabled = NO;
        
        [cell.mContinueExamButton setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]];
        cell.mContinueExamButton.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
    }
    
    //是否可以查看答卷
    if ([[self.dataResult objectForKey:@"allowSeeResult"] boolValue]) {
        cell.mLookExamButton.enabled = YES;
        
        [cell.mLookExamButton setBackgroundColor:kNavigationBarColor];
        cell.mLookExamButton.layer.shadowColor = kNavigationBarColor.CGColor;
    }else
    {
        cell.mLookExamButton.enabled = NO;
        
        [cell.mLookExamButton setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]];
        cell.mLookExamButton.layer.shadowColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
    }
    
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

#pragma mark -

// 点击了开始考试按钮
- (void)didClickStartExamButton
{
    NSLog(@"点击了开始考试按钮");
    
    if (!NETWORK_AVAILIABLE) {
        [self.view showErrorWithMessage:@"请检查网络连接！"];
        return;
    }
    
    [self.view showLoading];
    
    NSString *examId = self.exam.examId;
    NSString *title = self.exam.examTitle;
    
    [HXExamSessionManager getDataWithExamId:examId success:^(NSDictionary *dic) {
        
        NSString *success = [NSString stringWithFormat:@"%@",[dic objectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            
            [HXExamSessionManager getDataWithNSString:[dic objectForKey:@"url"] withDictionary:nil success:^(NSDictionary *dictionary) {
                
                [self.view hideLoading];
                
                NSString *success = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
                if ([success isEqualToString:@"1"]) {
                    NSDictionary *examExam = [dictionary objectForKey:@"userExam"];
                    NSLog(@"%@",examExam);
                    
                    HXStartExamViewController *svc = [[HXStartExamViewController alloc] init];
                    svc.examUrl = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"url"]];
                    svc.userExam = [dictionary objectForKey:@"userExam"];
                    svc.examTitle = title;
                    svc.isStartExam = YES;
                    svc.isEnterExam = YES;
                    svc.examBasePath = [dic objectForKey:@"context"];
                    [self.navigationController pushViewController:svc animated:YES];
                    
                }else
                {
                    if ([dictionary objectForKey:@"errMsg"]) {
                        [self.view showErrorWithMessage:[dictionary objectForKey:@"errMsg"]];
                    }else
                    {
                        [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
                    }
                }
            } failure:^(NSError *error) {
                [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
            }];
        }else
        {
            if ([dic objectForKey:@"errMsg"]) {
                [self.view showErrorWithMessage:[dic objectForKey:@"errMsg"]];
            }else
            {
                [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
            }
        }
    } failure:^(NSError *error) {
        [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
    }];
}

#pragma mark - HXExamRecordCellDelegate

/// 点击了继续考试按钮
- (void)didClickContinueExamButtonInCell:(HXExamRecordCell *)cell
{
    NSLog(@"点击了继续考试按钮");
    
    if (!NETWORK_AVAILIABLE) {
        [self.view showErrorWithMessage:@"请检查网络连接！"];
        return;
    }
    
    NSDictionary *dicSource = cell.dataSource;
    
    //继续考试
    [self.view showLoading];
    
    NSString *url = [NSString stringWithFormat:HXEXAM_RESTART,[dicSource objectForKey:@"id"]];
    
    [HXExamSessionManager getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dic) {
        NSString *success = [NSString stringWithFormat:@"%@",[dic objectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            [HXExamSessionManager getDataWithNSString:[dic objectForKey:@"examUrl"] withDictionary:nil success:^(NSDictionary *dictionary) {
                
                [self.view hideLoading];
                
                NSString *success = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
                if ([success isEqualToString:@"1"]) {
                    //NSLog(@"%@",[dictionary objectForKey:@"url"]);

                    HXStartExamViewController *svc = [[HXStartExamViewController alloc] init];
                    svc.examUrl = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"url"]];
                    svc.userExam = [dictionary objectForKey:@"userExam"];
                    svc.examTitle = [dic objectForKey:@"examName"];
                    svc.isStartExam = NO;
                    svc.isEnterExam = YES;
                    svc.examBasePath = [dic objectForKey:@"context"];
                    
                    [self.navigationController pushViewController:svc animated:YES];
                    
                }else
                {
                    [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
                }
            } failure:^(NSError *error) {
                [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
            }];
        }else
        {
            [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
            
        }
    } failure:^(NSError *error) {
        [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
    }];
}

/// 点击了查看答卷按钮
- (void)didClickLookExamButtonInCell:(HXExamRecordCell *)cell
{
    NSLog(@"点击了查看答卷按钮");
    
    if (!NETWORK_AVAILIABLE) {
        [self.view showErrorWithMessage:@"请检查网络连接！"];
        return;
    }
    
    NSDictionary *dicSource = cell.dataSource;
    
    //查看试卷
    [self.view showLoading];
    
    [HXExamSessionManager getDataWithNSString:[dicSource objectForKey:@"viewUrl"] withDictionary:nil success:^(NSDictionary *dictionary) {
        
        [self.view hideLoading];
        
        NSString *success = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            //NSLog(@"%@",[dictionary objectForKey:@"url"]);
            
            HXStartExamViewController *svc = [[HXStartExamViewController alloc] init];
            svc.examUrl = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"url"]];
            svc.userExam = [dictionary objectForKey:@"userExam"];
            svc.examTitle = self.exam.examTitle;
            svc.isStartExam = NO;
            svc.isEnterExam = NO;
            svc.isAllowSeeAnswer = [[dictionary objectForKey:@"allowSeeAnswer"] boolValue];
            svc.examBasePath = [dicSource objectForKey:@"context"];
            
            [self.navigationController pushViewController:svc animated:YES];
            
        }else
        {
            [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
            NSLog(@"%@",dictionary);
        }
    } failure:^(NSError *error) {
        [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
    }];
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
