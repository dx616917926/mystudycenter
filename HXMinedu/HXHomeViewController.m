//
//  HXHomeViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/2.
//

#import "HXHomeViewController.h"
#import "HXResetViewController.h"
#import "HXSettingViewController.h"
#import "HXMessageListController.h"
#import "HXHomeViewCell.h"
#import "MJRefresh.h"

@interface HXHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *imageBackImageView;
    CGFloat topViewHegiht;           //顶部视图高度
    NSInteger messageCount;          //未读消息数量
}
@property(nonatomic, strong) UIView *topView;           //顶部视图
@property(nonatomic, strong) UITableView *mTableView;
@property(nonatomic, strong) UIImageView *faceImageView;//头像

@end

@implementation HXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self sc_setNavigationBarBackgroundAlpha:0];
    [self setSc_NavigationBarAnimateInvalid:YES];
    
    topViewHegiht = MIN(kScreenWidth*0.54, 300);
    messageCount = 0;
    
    [self initTableView];
}

- (void)initTableView {
    if (!self.mTableView) {
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight) style:UITableViewStylePlain];
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mTableView.cellLayoutMarginsFollowReadableWidth = NO;
        self.mTableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
        if (@available(iOS 11.0, *)) {
            self.mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.mTableView registerClass:[HXHomeViewCell class] forCellReuseIdentifier:@"HXHomeViewCell"];
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
        
        [self createTopView];
    }
}

// 创建头部视图
-(void)createTopView
{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topViewHegiht)];
    self.mTableView.tableHeaderView = self.topView;
    
    imageBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topViewHegiht)];
    imageBackImageView.backgroundColor = kNavigationBarColor;
    [self.topView addSubview:imageBackImageView];
    
    CGFloat height = topViewHegiht-kStatusBarHeight-38;
    CGFloat width = height/1.3;
    
    self.faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, kStatusBarHeight+20, width, height)];
    self.faceImageView.layer.masksToBounds = YES;
    self.faceImageView.layer.cornerRadius = 8;
    self.faceImageView.image = [UIImage imageNamed:@"heade_icon"];
    self.faceImageView.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:self.faceImageView];
}

- (void)loadNewData {
    
    [self requestMessageCount];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //结束刷新状态
        [weakSelf.mTableView.mj_header endRefreshing];
        
        [self.mTableView bringSubviewToFront:self.mTableView.mj_header];
    });
    
}

//请求未读消息数量
- (void)requestMessageCount {
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MESSAGE_COUNT withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            NSDictionary *data = [dictionary objectForKey:@"Data"];
            self->messageCount = [[data stringValueForKey:@"WDCount"] integerValue];
        }else
        {
            self->messageCount = 0;
        }
        [self.mTableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        //do nothing
        NSLog(@"请求未读消息数量失败！");
    }];
}

#pragma mark - 表视图代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXHomeViewCell"];

    cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    cell.tableView = tableView;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView * numView = [cell.contentView viewWithTag:401];
    [numView removeFromSuperview];
    
    if (indexPath.section == 0) {

        cell.imageView.image = [UIImage imageNamed:@"set_icon_user"];
        cell.textLabel.text = @"个人信息";
    }else
    {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"set_icon_pwd"];
                cell.textLabel.text = @"修改密码";
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"set_icon_message"];
                cell.textLabel.text = @"我的消息";
                
                if (messageCount!=0) {
                    UIView * countView = [self circleViewWithCount:messageCount];
                    countView.tag = 401;
                    [cell.contentView addSubview:countView];
                    
                    [countView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.offset(-4);
                        make.centerY.offset(0);
                        make.height.mas_equalTo(22);
                        make.width.mas_greaterThanOrEqualTo(22);
                    }];
                }
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"set_icon"];
                cell.textLabel.text = @"设置";
                break;
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
    
    if (indexPath.section == 0) {
        
    }else
    {
        if (indexPath.row == 0) {
            //修改密码
            HXResetViewController *resetVC = [[HXResetViewController alloc] init];
            resetVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resetVC animated:YES];
            
        }else if (indexPath.row == 1) {
            //我的消息
            HXMessageListController *listVC = [[HXMessageListController alloc] init];
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];
            
        }else if (indexPath.row == 2) {
            //设置
            HXSettingViewController *setVC = [[HXSettingViewController alloc] init];
            setVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffset = scrollView.contentOffsetY + scrollView.contentInsetTop;
    
    imageBackImageView.height = topViewHegiht - MIN(scrollView.contentOffsetY, 0);
    imageBackImageView.y = MIN(scrollView.contentOffsetY, 0);
    
    if (contentOffset >= topViewHegiht - kStatusBarHeight) {
        [self sc_setNavigationBarBackgroundAlpha:1];
        [self setSc_NavigationBarAnimateInvalid:NO];
        return;
    }
    if (contentOffset < topViewHegiht - kStatusBarHeight) {
        [self sc_setNavigationBarBackgroundAlpha:0];
        [self setSc_NavigationBarAnimateInvalid:YES];
        [self sc_setNavigationBarHidden:YES animated:YES];
        return;
    }
}

#pragma mark - 圆圈

/**
 *  创建小圆圈视图
 *  @param count 数量
 *  @return view
 */
-(UIView *)circleViewWithCount:(NSInteger)count
{
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,22,22)];
    if (count<99) {
        countLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
    }else
    {
        countLabel.text = @"99+";
    }
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont systemFontOfSize:13];
    [countLabel setBackgroundColor:[UIColor redColor]];
    countLabel.highlightedTextColor = [UIColor whiteColor];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.layer.masksToBounds = YES;
    countLabel.layer.cornerRadius = 11;
    return countLabel;
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
