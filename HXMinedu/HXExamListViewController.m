//
//  HXExamListViewController.m
//  HXMinedu
//
//  Created by Mac on 2021/1/12.
//

#import "HXExamListViewController.h"
#import "HXExamDetailViewController.h"
#import "HXExam.h"
#import "HXExamListCell.h"

@interface HXExamListViewController ()

@property(nonatomic,strong) NSString *moduleCode;
@property(nonatomic,strong) NSMutableArray * exams;
@property(nonatomic,strong) HXBarButtonItem *leftBarItem;

@end

@implementation HXExamListViewController

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
    
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationBar.title = @"考试列表";
    
    self.moduleCode = [self getCodeWithURL:self.authorizeUrl forKey:@"moduleCode"];
    self.exams = [[NSMutableArray alloc] init];
    
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadNewData];
}

-(void)initTableView
{
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1]];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXExamListCell" bundle:nil] forCellReuseIdentifier:@"HXExamListCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.mj_footer.hidden = YES;
}

-(void)setTableHeaderView
{
    if (_exams.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        blankBg.backgroundColor  = [UIColor whiteColor];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)/2, 100, 120, 100)];
        logoImg.image = [UIImage imageNamed:@"ic_no_events"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 80)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"暂无考试！";
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
    if (_exams.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
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
        [self.tableView.mj_header endRefreshing];
    }else
    {
        self.tableView.tableHeaderView = nil;
    }
}

//检查是否需要重新加载数据
-(void)checkIfNeedReloadData
{
    if (_exams.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

/**
 请求授权
 */
-(void)requestAuthorize
{
    [self.view showLoading];
    
    NSMutableString * mutableUrl = [NSMutableString stringWithString:self.authorizeUrl];
    
    [mutableUrl appendString:@"&ct=client"];
    
    //重新根据返回的数据确定一下baseURL
    [[HXHTTPSessionManager sharedClient] setBaseUrl:self.authorizeUrl];
    
    [HXHTTPSessionManager getDataWithNSString:mutableUrl withDictionary:nil success:^(NSDictionary *dictionary) {
        //
        [self requestExamModulesListData];
        
    } failure:^(NSError *error) {
        //
        [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
        
        [self setRequestFiledView];
        
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)requestExamModulesListData
{
    [self.view showLoading];
    
    NSString * url = [NSString stringWithFormat:HXEXAM_MODULES_LIST,self.moduleCode];
    
    [HXHTTPSessionManager getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dic) {
        NSString *success = [NSString stringWithFormat:@"%@",[dic objectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            
            [self.exams removeAllObjects];
            
            NSArray * exams = [dic objectForKey:@"exams"];
            for (NSDictionary * dic in exams) {
                HXExam * exam = [[HXExam alloc] initWithDictionary:dic];
                [self.exams addObject:exam];
            }
            
            //设置空白页
            [self setTableHeaderView];
            
            [self.tableView reloadData];
            
            [self.view hideLoading];
        }else
        {
            [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
            
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
    [self requestAuthorize];
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
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exams.count;
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
    NSInteger row = indexPath.row;
    
    HXExamListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXExamListCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    HXExam *exam = [self.exams objectAtIndex:row];
    cell.entity = exam;
//    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXExam *exam = [self.exams objectAtIndex:indexPath.row];
    
    HXExamDetailViewController *detailVC = [[HXExamDetailViewController alloc] init];
    detailVC.exam = exam;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(NSString *)getCodeWithURL:(NSString *)urlStr forKey:(NSString *)key
{
    if (urlStr && key) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithString:urlStr];
        NSArray *queryItems = urlComponents.queryItems;
        
        for (NSURLQueryItem * item in queryItems) {
            if ([item.name isEqualToString:key]) {
                return item.value;
            }
        }
    }
    return @"";
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
