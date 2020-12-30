//
//  HXMessageListController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/29.
//

#import "HXMessageListController.h"
#import "HXMessageListCell.h"
#import "HXMessageObject.h"
#import "HXMessageDetailController.h"

@interface HXMessageListController ()<UIAlertViewDelegate>
{
    int currentPageList;
    NSMutableArray * messageArr;
    BOOL ifNeedUpdate;
}
@property (nonatomic, strong) HXBarButtonItem *leftBarItem;
@property (nonatomic, strong) HXBarButtonItem *rightBarItem;
@end

@implementation HXMessageListController


-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    self.rightBarItem = [[HXBarButtonItem alloc] initWithTitle:@"已读" style:HXBarButtonItemStylePlain handler:^(id sender) {
        [self rightBarItemAction];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1.00];
    
    //默认第一页都是1
    currentPageList = 1;
    messageArr = [[NSMutableArray alloc] init];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HXMessageListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HXMessageListCell"];
    self.tableView.mj_footer.hidden = YES;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1.00];
    
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    
    [self loadNewData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.sc_navigationBar.title = @"通知";
    
    if (ifNeedUpdate) {
        ifNeedUpdate = NO;
        [self loadNewData];
    }
}

/**
 更新“已读”按钮的状态
 */
-(void)updateRightBarButton
{
    __block BOOL hasNoReadMessage = NO;
    [messageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXMessageObject * message = obj;
        if ([message.statusID isEqualToString:@"0"]) {
            hasNoReadMessage = YES;
            *stop = YES;
        }
    }];
    
    if (hasNoReadMessage) {
        self.sc_navigationBar.rightBarButtonItem = self.rightBarItem;
    }else
    {
        self.sc_navigationBar.rightBarButtonItem = nil;
    }
}

/**
 清空所有消息
 */
-(void)messageUpdate {
    
    if (!self.isLogin) {
        return;
    }
    
    [self.view showLoading];
    
    NSDictionary *parameters = @{@"message_id":@""};
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MESSAGE_UPDATE withDictionary:parameters success:^(NSDictionary *dic) {
        NSString *success = [NSString stringWithFormat:@"%@",[dic objectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            
            [self loadNewData];
            
            [self.view hideLoading];
        }else
        {
            [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
        }
        
    } failure:^(NSError *error) {
        
        if (error.code==NSURLErrorNotConnectedToInternet) {
            [self.view showErrorWithMessage:@"请检查网络!"];
        }else
        {
            [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
        }
    }];
}

/**
 已读 按钮点击事件
 */
-(void)rightBarItemAction {
    
    __weak __typeof(self)weakSelf = self;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"全部标记为“已读”？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //清空消息
        [weakSelf messageUpdate];
    }];
    UIAlertAction *confirmAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:confirmAction2];
    [alertC addAction:confirmAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)requestProductsListDataWithPage:(int)page
{
    [self.view showLoading];
    
    NSDictionary *parameters = @{@"pageIndex":[NSString stringWithFormat:@"%d",page],@"pageSize":@"15"};
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MESSAGE_LIST withDictionary:parameters success:^(NSDictionary *dic) {
        BOOL Success = [dic boolValueForKey:@"Success"];
        if (Success) {
            
            NSArray *data = [dic objectForKey:@"Data"];
            
            NSMutableArray *arr = [HXMessageObject mj_objectArrayWithKeyValuesArray:data];
            
            if (page == 1) {
                self->messageArr = arr;
            }else
            {
                [self->messageArr addObjectsFromArray:arr];
            }
            
            if (arr.count == 15) {
                self.tableView.mj_footer.hidden = NO;
                self->currentPageList++;
            }else
            {
                self.tableView.mj_footer.hidden = YES;
            }
            
            //设置空白页
            [self setTableHeaderView];
            [self updateRightBarButton];
            
            [self.tableView reloadData];
            
            [self.view hideLoading];
        }else
        {
            [self setRequestFiledView];
            
            [self.view showErrorWithMessage:[dic stringValueForKey:@"Message"]];
        }
        
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self setRequestFiledView];
        
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)setRequestFiledView
{
    if (messageArr.count == 0) {
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
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        view.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = view;
    }
}

-(void)setTableHeaderView
{
    if (messageArr.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-300)/2, 60, 300, 210)];
        logoImg.image = [UIImage imageNamed:@"message_no"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 40)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"暂无消息~";
        warnMsg.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
        warnMsg.font = [UIFont systemFontOfSize:16];
        warnMsg.textAlignment = NSTextAlignmentCenter;
        [blankBg addSubview:warnMsg];
        [self.tableView setTableHeaderView:blankBg];
    }else
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        view.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = view;
    }
}

#pragma mark 刷新数据

- (void)loadNewData
{
    currentPageList = 1;
    [self requestProductsListDataWithPage:currentPageList];
}

-(void)loadMoreData
{
    [self requestProductsListDataWithPage:currentPageList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXMessageListCell * cell = (HXMessageListCell*)[tableView dequeueReusableCellWithIdentifier:@"HXMessageListCell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = kCellHighlightedColor;
    
    HXMessageObject * item = [messageArr objectAtIndex:indexPath.row];
    
    cell.model = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ifNeedUpdate = YES;
    
    //打开通知
    HXMessageObject *message = [messageArr objectAtIndex:indexPath.row];
    HXMessageDetailController * detailVC = [[HXMessageDetailController alloc] init];
    detailVC.message = message;
    [self.navigationController pushViewController:detailVC animated:YES];
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
