//
//  HXExamModuleViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/23.
//

#import "HXExamModuleViewController.h"
#import "HXExamCell.h"
#import "HXExamDetailViewController.h"
#import "HXExamModel.h"

@interface HXExamModuleViewController ()<HXExamCellDelegate>
{
    BOOL needRefresh;      //刷新
}
@property(nonatomic, strong) NSMutableArray *exams;

@end

@implementation HXExamModuleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kControllerViewBackgroundColor;
    
    self.exams = [[NSMutableArray alloc] init];
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXExamCell" bundle:nil] forCellReuseIdentifier:@"HXExamCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.mj_footer.hidden = YES;
}

-(void)setTableHeaderView
{
    if (_exams.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-300)/2, 30, 320, 300)];
        logoImg.image = [UIImage imageNamed:@"course_no"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 80)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"暂无考试~";
        warnMsg.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
        warnMsg.font = [UIFont systemFontOfSize:16];
        warnMsg.textAlignment = NSTextAlignmentCenter;
        [blankBg addSubview:warnMsg];
        [self.tableView setTableHeaderView:blankBg];
        
    }else{
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];;
    }
}

-(void)setRequestFiledView
{
    if (_exams.count == 0) {
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
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];;
    }
}

//检查是否需要重新加载数据
-(void)checkIfNeedReloadData
{
    if (_exams.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)requestExamListData
{
    NSMutableDictionary *parsms = [NSMutableDictionary dictionary];
    [parsms setObject:self.course_id forKey:@"course_id"];
    
    NSString * url = [NSString stringWithFormat:HXPOST_EXAMLIST];
    
    [HXBaseURLSessionManager postDataWithNSString:url withDictionary:parsms success:^(NSDictionary *dictionary) {
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            [self.view hideLoading];
            
            [self.exams removeAllObjects];
            
            self.exams = [HXExamModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            
            //设置空白页
            [self setTableHeaderView];
            
            [self.tableView reloadData];
        }else
        {
            [self setRequestFiledView];
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
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
    [self requestExamListData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.exams.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.exams.count) {
        return 40;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    if (self.exams.count) {
        HXExamModel *model = [self.exams objectAtIndex:section];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 100, 30)];
        label.text = model.ButtonName;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
    }
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXExamModel *model = [self.exams objectAtIndex:indexPath.section];

    HXExamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXExamCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma - mark HXExamCellDelegate

/// 点击了进入考试按钮
- (void)didClickStartExamButtonInCell:(HXExamCell *)cell
{
    HXExamDetailViewController *detailVC = [[HXExamDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
