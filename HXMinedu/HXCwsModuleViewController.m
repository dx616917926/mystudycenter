//
//  HXCwsModuleViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/23.
//

#import "HXCwsModuleViewController.h"
#import "HXCoursewareCell.h"
#import "HXCwsCourseware.h"
#import <TXMoviePlayer/TXMoviePlayerController.h>

@interface HXCwsModuleViewController ()
{
    BOOL needRefresh;      //刷新
}
@property(nonatomic, strong) NSMutableArray *coursewares;

@end

@implementation HXCwsModuleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kControllerViewBackgroundColor;
    
    self.coursewares = [[NSMutableArray alloc] init];
    
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (needRefresh) {
        [self performSelector:@selector(loadNewData) withObject:nil afterDelay:0.6]; //延迟请求一下，以防不同步
        needRefresh = NO;
    }
}

-(void)initTableView
{
    self.tableViewInsertTop = 0;
    self.tableView.contentInsetTop = 0;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-44);
    self.tableView.scrollsToTop = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXCoursewareCell" bundle:nil] forCellReuseIdentifier:@"HXCoursewareCell"];
        
    self.tableView.mj_footer.hidden = YES;
}

-(void)setTableHeaderView
{
    if (_coursewares.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-300)/2, 30, 320, 300)];
        logoImg.image = [UIImage imageNamed:@"course_no"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 80)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"暂无视频~";
        warnMsg.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
        warnMsg.font = [UIFont systemFontOfSize:16];
        warnMsg.textAlignment = NSTextAlignmentCenter;
        [blankBg addSubview:warnMsg];
        [self.tableView setTableHeaderView:blankBg];
        
    }else{
        self.tableView.tableHeaderView = nil;
    }
}

-(void)setRequestFiledView
{
    if (_coursewares.count == 0) {
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
        [retryButton addTarget:self.tableView.mj_header action:@selector(beginRefreshing) forControlEvents:UIControlEventTouchUpInside];
        retryButton.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:1.0].CGColor;
        retryButton.layer.cornerRadius = 20;
        retryButton.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:0.5].CGColor;
        retryButton.layer.shadowOffset = CGSizeMake(0,0);
        retryButton.layer.shadowOpacity = 1;
        retryButton.layer.shadowRadius = 4;
        [blankBg addSubview:retryButton];
        
        [self.tableView setTableHeaderView:blankBg];
    }else
    {
        self.tableView.tableHeaderView = nil;
    }
}

//检查是否需要重新加载数据
-(void)checkIfNeedReloadData
{
    if (_coursewares.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)requestCwsModulesListData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.course_id forKey:@"course_id"];
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_CWSLIST withDictionary:parameters success:^(NSDictionary *dictionary) {
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            [self.coursewares removeAllObjects];
            
            NSArray *data = [dictionary objectForKey:@"Data"];
            if (data) {
                self.coursewares = [HXCwsCourseware mj_objectArrayWithKeyValuesArray:data];
            }
            
            //设置空白页
            [self setTableHeaderView];
            
            [self.tableView reloadData];
            
            [self.view hideLoading];
            
        }else{
            [self setRequestFiledView];

        }
        
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
        
        [self setRequestFiledView];
        
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 下拉刷新数据

- (void)loadNewData
{
    [self requestCwsModulesListData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coursewares.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXCwsCourseware *courseware = [self.coursewares objectAtIndex:indexPath.row];

    HXCoursewareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXCoursewareCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.entity = courseware;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXCwsCourseware *courseware = [self.coursewares objectAtIndex:indexPath.row];

    NSString *type = courseware.coursewareType;
    
    //直接走新课件系统
    if ([type isEqualToString:@"11"]) {
        
        TXMoviePlayerController *playerVC = [[TXMoviePlayerController alloc] init];
        playerVC.cws_param = courseware.cws_param;
        [self.navigationController pushViewController:playerVC animated:YES];
        
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
