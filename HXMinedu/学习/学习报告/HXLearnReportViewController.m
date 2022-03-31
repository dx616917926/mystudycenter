//
//  HXLearnReportViewController.m
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXLearnReportViewController.h"
#import "HXHistoryLearnReportViewController.h"
#import "HXVideoLearnViewController.h"
#import "HXPSZYViewController.h"
#import "HXQMKSViewController.h"
#import "HXLNZTViewController.h"
#import "YNPageViewController.h"
#import "HXLearnReportModel.h"
#import "HXNoDataTipView.h"

@interface HXLearnReportViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property(nonatomic,strong) HXNoDataTipView *noDataTipView;
@property(nonatomic,strong) UIButton *popBackBtn;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *childVcs;
@property (nonatomic, strong) YNPageConfigration *configration;
@property (nonatomic, strong) YNPageViewController *pageViewVc;
//头部
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *geYanLabel;
@property (nonatomic, strong) UIButton *historyReportBtn;

@property (nonatomic, strong) HXLearnReportModel *learnReportModel;


@end

@implementation HXLearnReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取学习报告
    [self getLearnReport];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
    
}

#pragma mark -  获取学习报告
-(void)getLearnReport{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"createDate":@""//历史版本时间，有值为历史学习报告 空值为学习报告
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_LearnReport  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.learnReportModel = [HXLearnReportModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            if (self.learnReportModel.learnModuleList.count>0) {
                [self.noDataTipView removeFromSuperview];
                [self.popBackBtn removeFromSuperview];
                [self refreshUI];
            }else{
                [self.view addSubview:self.noDataTipView];
                [self.view addSubview:self.popBackBtn];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UI
-(void)refreshUI{
    
    [self.titles removeAllObjects];
    [self.childVcs removeAllObjects];
    
    for (HXLearnModuleModel *learnModuleModel in self.learnReportModel.learnModuleList) {
        if (learnModuleModel.learnCourseItemList.count>0) {
            [self.titles addObject:learnModuleModel.ModuleName];
            switch (learnModuleModel.type) {
                case 1:
                {
                    HXVideoLearnViewController *vc = [[HXVideoLearnViewController alloc] init];
                    vc.learnCourseItemList = learnModuleModel.learnCourseItemList;
                    vc.ModuleName = learnModuleModel.ModuleName;
                    [self.childVcs addObject:vc];
                }
                    break;
                case 2:
                {
                    HXPSZYViewController *vc = [[HXPSZYViewController alloc] init];
                    vc.ModuleName = learnModuleModel.ModuleName;
                    vc.learnCourseItemList = learnModuleModel.learnCourseItemList;
                    [self.childVcs addObject:vc];
                }
                    break;
                case 3:
                {
                    HXQMKSViewController *vc = [[HXQMKSViewController alloc] init];
                    vc.ModuleName = learnModuleModel.ModuleName;
                    vc.learnCourseItemList = learnModuleModel.learnCourseItemList;
                    [self.childVcs addObject:vc];
                }
                    break;
                case 4:
                {
                    HXLNZTViewController *vc = [[HXLNZTViewController alloc] init];
                    vc.isHistory = (self.learnReportModel.isHisVersion==1?YES:NO);
                    vc.ModuleName = learnModuleModel.ModuleName;
                    vc.learnCourseItemList = learnModuleModel.learnCourseItemList;
                    [self.childVcs addObject:vc];
                }
                    break;
                default:
                    break;
            }
        }
    }
    
    //设置控制器
    [self setupPageVC];
    //控制历史学习报告按钮显示与隐藏
    self.historyReportBtn.hidden = (self.learnReportModel.isHisVersion==1?NO:YES);
}

#pragma mark - Event
-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//查看历史学习报告
-(void)checkHistoryLearnReport:(UIButton *)sender{
    HXHistoryLearnReportViewController *vc = [[HXHistoryLearnReportViewController alloc] init];
    vc.sc_navigationBarHidden = YES;//隐藏导航栏
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)setupPageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.showTabbar = NO;
    configration.showNavigation = NO;
    configration.scrollMenu = YES;
    configration.bounces = NO;
    configration.scrollViewBackgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    configration.bottomLineHeight = 1;
    configration.bottomLineLeftAndRightMargin = 0;
    configration.bottomLineBgColor = COLOR_WITH_ALPHA(0xF2F2F2, 1);
    configration.lineHeight = 4;
    configration.lineCorner = 2;
    configration.lineLeftAndRightAddWidth = -15;
    configration.lineBottomMargin = 0;
    configration.lineColor = COLOR_WITH_ALPHA(0x5699FF, 1);
    configration.itemFont = HXBoldFont(14);
    configration.selectedItemFont = HXBoldFont(14);
    configration.normalItemColor = COLOR_WITH_ALPHA(0xB1B1B1, 1);
    configration.selectedItemColor = COLOR_WITH_ALPHA(0x5699FF, 1);
    configration.itemMargin = _kpw(30);
    configration.itemLeftAndRightMargin = 20;
    configration.menuHeight = 44;
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = CGRectGetHeight(self.headerView.frame);
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.childVcs
                                                                                titles:self.titles
                                                                                config:configration];
    self.pageViewVc = vc;
    vc.dataSource = self;
    vc.delegate = self;
    vc.headerView = self.headerView;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    /// 作为子控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
}



#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[HXVideoLearnViewController class]]) {
        return [(HXVideoLearnViewController *)vc mainTableView];
    }else if ([vc isKindOfClass:[HXPSZYViewController class]]) {
        return [(HXPSZYViewController *)vc mainTableView];
    }else if ([vc isKindOfClass:[HXQMKSViewController class]]) {
        return [(HXQMKSViewController *)vc mainTableView];
    }else if ([vc isKindOfClass:[HXLNZTViewController class]]) {
        return [(HXLNZTViewController *)vc mainTableView];
    }
    return nil;
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    
    
    
}

#pragma mark - LazyLoad
-(NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

-(NSMutableArray *)childVcs{
    if (!_childVcs) {
        _childVcs = [NSMutableArray array];
    }
    return _childVcs;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.533)];
        _headerView.backgroundColor = UIColor.whiteColor;
        [_headerView addSubview:self.bgImageView];
        [_headerView addSubview:self.backBtn];
        [_headerView addSubview:self.titleLabel];
        [_headerView addSubview:self.geYanLabel];
        [_headerView addSubview:self.historyReportBtn];
        
        self.bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        self.backBtn.sd_layout
        .leftEqualToView(_headerView)
        .topSpaceToView(_headerView, 64)
        .widthIs(60)
        .heightIs(30);
        
        self.backBtn.imageView.sd_layout
        .centerYEqualToView(self.backBtn)
        .leftSpaceToView(self.backBtn, 20)
        .widthIs(20)
        .heightEqualToWidth();
        
        self.titleLabel.sd_layout
        .leftSpaceToView(_headerView, 20)
        .topSpaceToView(self.backBtn, 20)
        .widthIs(100)
        .heightIs(28);
        
        self.geYanLabel.sd_layout
        .leftEqualToView(self.titleLabel)
        .topSpaceToView(self.titleLabel, 10)
        .rightSpaceToView(_headerView, 20)
        .heightIs(22);
        
        self.historyReportBtn.sd_layout
        .bottomEqualToView(_headerView)
        .rightSpaceToView(_headerView, 10)
        .widthIs(250)
        .heightIs(37);
        
        self.historyReportBtn.imageView.sd_layout
        .centerYEqualToView(self.historyReportBtn)
        .rightEqualToView(self.historyReportBtn)
        .widthIs(6)
        .heightIs(16);
        
        self.historyReportBtn.titleLabel.sd_layout
        .centerYEqualToView(self.historyReportBtn)
        .leftEqualToView(self.historyReportBtn)
        .rightSpaceToView(self.historyReportBtn.imageView, 5)
        .heightIs(17);
        
        
        
    }
    return _headerView;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"navi_whiteback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.image = [UIImage imageNamed:@"learnreport_bg"];
    }
    return _bgImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HXBoldFont(20);
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = @"学习报告";
    }
    return _titleLabel;
}

-(UILabel *)geYanLabel{
    if (!_geYanLabel) {
        _geYanLabel = [[UILabel alloc] init];
        _geYanLabel.font = HXFont(16);
        _geYanLabel.textColor = UIColor.whiteColor;
        _geYanLabel.text = @"今天也是为梦想奋斗的一天！";
    }
    return _geYanLabel;
}

-(UIButton *)historyReportBtn{
    if (!_historyReportBtn) {
        _historyReportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _historyReportBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _historyReportBtn.titleLabel.font = HXFont(12);
        [_historyReportBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_historyReportBtn setTitle:@"查看历史学习报告" forState:UIControlStateNormal];
        [_historyReportBtn setImage:[UIImage imageNamed:@"right_white"] forState:UIControlStateNormal];
        [_historyReportBtn addTarget:self action:@selector(checkHistoryLearnReport:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyReportBtn;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _noDataTipView.tipTitle = @"暂无数据~";
    }
    return _noDataTipView;
}

-(UIButton *)popBackBtn{
    if (!_popBackBtn) {
        _popBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _popBackBtn.frame = CGRectMake(0, 44, 60, 40);
        [_popBackBtn setImage:[UIImage imageNamed:@"navi_blackback"] forState:UIControlStateNormal];
        [_popBackBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popBackBtn;
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
