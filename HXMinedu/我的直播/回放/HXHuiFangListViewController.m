//
//  HXHuiFangListViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXHuiFangListViewController.h"
#import "HXDianPingSuccessViewController.h"
#import "HXHuiFangKeJieCell.h"
#import "HXOnLiveDianPingView.h"


@interface HXHuiFangListViewController ()<UITableViewDelegate,UITableViewDataSource,HXHuiFangKeJieCellDelegate>

@property(nonatomic,strong) UITableView *mainTableView;

@end

@implementation HXHuiFangListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self createUI];
}

#pragma mark -  点评结果
-(void)dianPingResult{
    HXDianPingSuccessViewController *vc = [[HXDianPingSuccessViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <HXHuiFangKeJieCellDelegate>点评
-(void)dianPingWithModel{
    HXOnLiveDianPingView *onLiveDianPingView = [[HXOnLiveDianPingView alloc] init];
    onLiveDianPingView.type = OnLiveDianPingViewTypeeSelect;
    [onLiveDianPingView show];
    onLiveDianPingView.dianPingCallBack = ^(NSInteger fenGeStarScore, NSInteger contentStarScore, NSInteger tiYanStarScore, NSString * _Nonnull jianYiContent) {
        NSLog(@"授课风格:%ld   授课内容:%ld   直播体验:%ld  其他建议:%@",fenGeStarScore,contentStarScore,tiYanStarScore,jianYiContent);
        [self dianPingResult];
    };
    
}

-(void)checkDianPingWithModel{
    HXOnLiveDianPingView *onLiveDianPingView = [[HXOnLiveDianPingView alloc] init];
    onLiveDianPingView.type = OnLiveDianPingViewTypeShow;
    onLiveDianPingView.fenGeStarScore =2;
    onLiveDianPingView.contentStarScore =1;
    onLiveDianPingView.tiYanStarScore =2;
    [onLiveDianPingView show];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *huiFangKeJieCellIdentifier = @"HXHuiFangKeJieCellIdentifier";
    HXHuiFangKeJieCell *cell = [tableView dequeueReusableCellWithIdentifier:huiFangKeJieCellIdentifier];
    if (!cell) {
        cell = [[HXHuiFangKeJieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:huiFangKeJieCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
//    cell.liveBroadcastModel = (self.isSearchMode?self.searchArray[indexPath.row]:self.dataArray[indexPath.row]);
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.title = @"自学考试大学语文公开课";
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0);
    [self.mainTableView updateLayout];
    
//    // 下拉刷新
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefrsh)];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    header.automaticallyChangeAlpha = YES;
//    //设置header
//    self.mainTableView.mj_header = header;
//
//    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.mainTableView.mj_footer = footer;
//    self.mainTableView.mj_footer.hidden = YES;
    
    
    
}


#pragma mark - LazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = YES;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0.0;
            _mainTableView.estimatedSectionFooterHeight = 0.0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenBottomMargin, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        
    }
    return _mainTableView;
}

@end
