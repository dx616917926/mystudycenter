//
//  HXLiveViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/2.
//

#import "HXLiveViewController.h"
#import "MJRefresh.h"
#import "HXLiveModel.h"
#import "HXLiveDetailViewController.h"

@interface HXLiveViewController ()

@property(nonatomic, strong) NSArray *liveListArray;
@property(nonatomic, strong) UIScrollView *mScrollView;
@property(nonatomic, strong) UIView *contentView;

@end

@implementation HXLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sc_navigationBar.title = @"直播";
    
    [self createScrollView];
    
    //退出登录的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:SHOWLOGIN object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.liveListArray == nil) {
        [self.mScrollView.mj_header beginRefreshing];
    }
}

//退出登录，清空数据
- (void)loginOut{
    self.liveListArray = nil;
    [self createNoneContentView];
}

- (void)loadNewData {
    
    [self requestLiveList];
}

- (void)createScrollView {
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight+1)];
    [self.view addSubview:self.mScrollView];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    // 设置header
    self.mScrollView.mj_header = header;
    
    [self.mScrollView.mj_header beginRefreshing];
}

- (void)createContentView {
    
    if (self.contentView) {
        [self.contentView removeFromSuperview];
    }
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth+30)];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.width-300)/2, self.contentView.height - 360, 300, 300)];
    [iconView setImage:[UIImage imageNamed:@"live_icon"]];
    [self.contentView addSubview:iconView];
    
    UIButton *liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    liveButton.frame = CGRectMake((self.contentView.width-160)/2, self.contentView.height - 50, 160, 40);
    [liveButton setTitle:@"进入直播" forState:UIControlStateNormal];
    [liveButton.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [liveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [liveButton addTarget:self action:@selector(liveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    liveButton.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:1.0].CGColor;
    liveButton.layer.cornerRadius = 20;
    liveButton.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:0.5].CGColor;
    liveButton.layer.shadowOffset = CGSizeMake(0,0);
    liveButton.layer.shadowOpacity = 1;
    liveButton.layer.shadowRadius = 4;
    [self.contentView addSubview:liveButton];
    
    [self.mScrollView addSubview:self.contentView];
}

- (void)createNetworkErrorView {
    
    if (self.contentView) {
        [self.contentView removeFromSuperview];
    }
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.width-190)/2, self.contentView.height - 290, 190, 190)];
    [iconView setImage:[UIImage imageNamed:@"network_error_icon"]];
    [self.contentView addSubview:iconView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.contentView.width-230)/2, iconView.bottom, 230, 30)];
    label.text = @"网络不给力，请点击重新加载~";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.662 green:0.662 blue:0.662 alpha:1.0];
    [self.contentView addSubview:label];
    
    UIButton *liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    liveButton.frame = CGRectMake((self.contentView.width-160)/2, self.contentView.height - 50, 160, 40);
    [liveButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [liveButton.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [liveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [liveButton addTarget:self.mScrollView.mj_header action:@selector(beginRefreshing) forControlEvents:UIControlEventTouchUpInside];
    liveButton.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:1.0].CGColor;
    liveButton.layer.cornerRadius = 20;
    liveButton.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:0.5].CGColor;
    liveButton.layer.shadowOffset = CGSizeMake(0,0);
    liveButton.layer.shadowOpacity = 1;
    liveButton.layer.shadowRadius = 4;
    [self.contentView addSubview:liveButton];
    
    [self.mScrollView addSubview:self.contentView];
}

- (void)createNoneContentView {
    
    if (self.contentView) {
        [self.contentView removeFromSuperview];
    }
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth+30)];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.width-300)/2, self.contentView.height - 360, 300, 300)];
    [iconView setImage:[UIImage imageNamed:@"live_no_icon"]];
    [self.contentView addSubview:iconView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.contentView.width-160)/2, self.contentView.height - 50, 160, 50)];
    label.text = @"暂无直播~";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.662 green:0.662 blue:0.662 alpha:1.0];
    [self.contentView addSubview:label];
    
    [self.mScrollView addSubview:self.contentView];
}

- (void)requestLiveList {
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_LIVELIST withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        //
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            self.liveListArray = [HXLiveModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (self.liveListArray.count > 0) {
                [self createContentView];
            }else
            {
                [self createNoneContentView];
            }
        }else
        {
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
            
            [self createNetworkErrorView];
        }
        //结束刷新状态
        [self.mScrollView.mj_header endRefreshing];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self.view showErrorWithMessage:@"获取数据失败，请重试！"];
        
        [self createNetworkErrorView];
        
        //结束刷新状态
        [self.mScrollView.mj_header endRefreshing];
    }];
}

/// 进入直播
/// @param button 按钮
- (void)liveBtnClicked:(UIButton *)button {

    if (self.liveListArray.count>0) {
        HXLiveDetailViewController *detailVC = [[HXLiveDetailViewController alloc] init];
        detailVC.liveModel = self.liveListArray.firstObject;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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
