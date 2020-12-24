//
//  HXCwsModuleViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/23.
//

#import "HXCwsModuleViewController.h"
#import "HXCoursewareCell.h"
#import "HXCourseModel.h"

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
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXCoursewareCell" bundle:nil] forCellReuseIdentifier:@"HXCoursewareCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.mj_footer.hidden = YES;
}

-(void)setTableHeaderView
{
    if (_coursewares.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-44)];
        blankBg.backgroundColor  = [UIColor whiteColor];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)/2, 100, 120, 100)];
        logoImg.image = [UIImage imageNamed:@"ic_no_events"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 80)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"暂无课件！";
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
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-44)];
        blankBg.backgroundColor  = [UIColor whiteColor];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)/2, 100, 120, 100)];
        logoImg.image = [UIImage imageNamed:@"ic_no_events"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 80)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"下拉可以刷新哦~";
        warnMsg.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
        warnMsg.font = [UIFont systemFontOfSize:16];
        warnMsg.textAlignment = NSTextAlignmentCenter;
        [blankBg addSubview:warnMsg];
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
    NSString * url = [NSString stringWithFormat:HXPOST_MAJORLIST];
    
    [HXBaseURLSessionManager postDataWithNSString:url withDictionary:nil success:^(NSDictionary *dictionary) {
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            [self.coursewares removeAllObjects];
                        
            //设置空白页
//            [self setTableHeaderView];
            
            [self.tableView reloadData];
            
            [self.view hideLoading];
            
        }else
        {
            [self setRequestFiledView];
            [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
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
    return 4;//self.coursewares.count;
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
//    HXCourseModel *courseware = [self.coursewares objectAtIndex:indexPath.row];

    HXCoursewareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXCoursewareCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] init];
//    cell.entity = courseware;
//    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma - mark HXCoursewareCellDelegate

/// 点击了播放按钮
- (void)didClickPlayButtonInCell:(HXCoursewareCell *)cell
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
