//
//  HXSystemNotificationViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/12.
//

#import "HXSystemNotificationViewController.h"
#import "HXCommonWebViewController.h"
#import "HXSystemNotificationCell.h"
#import "HXNoDataTipView.h"
#import "HXMessageObject.h"


@interface HXSystemNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *messageList;
@property(nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong)  UITableView *mainTableView;
@property(nonatomic,strong) HXNoDataTipView *noDataTipView;

@end

@implementation HXSystemNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //消息列表
    [self loadData];
    
}

#pragma mark - 消息列表
- (void)loadData{
    self.mainTableView.mj_footer.hidden = NO;
    self.currentPage = 1;
    NSDictionary *parameters = @{@"pageIndex":@(self.currentPage),@"pageSize":@"15"};
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MESSAGE_LIST  withDictionary:parameters success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.messageList removeAllObjects];
            NSArray *array = [HXMessageObject mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.messageList addObjectsFromArray:array];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            if (array.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
            }
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData{
    self.currentPage++;
    NSDictionary *parameters = @{@"pageIndex":@(self.currentPage),@"pageSize":@"15"};
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MESSAGE_LIST  withDictionary:parameters success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.mainTableView.mj_footer endRefreshing];
            NSArray *array = [HXMessageObject mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.messageList addObjectsFromArray:array];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            [self.mainTableView reloadData];
        }else{
            self.currentPage--;
            [self.mainTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        self.currentPage--;
        [self.mainTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 消息设置已读
-(void)messageUpdate:(NSString *)message_id{
    if (!message_id) {
        return;
    }
    NSDictionary *parameters = @{@"message_id":message_id};
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MESSAGE_UPDATE withDictionary:parameters success:^(NSDictionary *dic) {
        BOOL Success = [dic boolValueForKey:@"Success"];
        if (Success) {
            NSLog(@"更新文章状态为已读！");
        }else{
            NSLog(@"文章标记为已读失败！");
        }
    } failure:^(NSError *error) {
        NSLog(@"文章标记为已读失败！");
    }];
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.messageList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR_WITH_ALPHA(0xF5F6FA, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 16;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *systemNotificationCellIdentifier = @"HXSystemNotificationCellIdentifier";
    HXSystemNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:systemNotificationCellIdentifier];
    if (!cell) {
        cell = [[HXSystemNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemNotificationCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HXMessageObject *messageModel = self.messageList[indexPath.section];
    cell.messageModel = messageModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXMessageObject *messageModel = self.messageList[indexPath.section];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:messageModel.redirectURL]];
   
//    HXCommonWebViewController *systemMessageVc = [[HXCommonWebViewController alloc] init];
//    systemMessageVc.cuntomTitle = messageModel.MessageTitle;
//    systemMessageVc.urlString = messageModel.redirectURL;
//    systemMessageVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:systemMessageVc animated:YES];
    
    //消息设置已读
    [self messageUpdate:messageModel.message_id];
}


#pragma mark - UI
-(void)createUI{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"系统通知";
   
    [self.view addSubview:self.mainTableView];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.mainTableView.mj_footer = footer;
    
   
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kScreenBottomMargin);
    
}

#pragma mark - lazyLoad
-(NSMutableArray *)messageList{
    if (!_messageList) {
        _messageList  = [NSMutableArray array];
    }
    return _messageList;
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xF5F6FA, 1);;
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
        _mainTableView.contentInset = UIEdgeInsetsMake(16, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _noDataTipView.tipImage = [UIImage imageNamed:@"no_messageicon"];
        _noDataTipView.tipTitle = @"暂无消息~";
    }
    return _noDataTipView;
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

