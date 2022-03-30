//
//  HXLearnReportViewController.m
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXHistoryLearnReportViewController.h"
#import "HXVideoLearnViewController.h"
#import "HXPSZYViewController.h"
#import "HXQMKSViewController.h"
#import "HXLNZTViewController.h"
#import "YNPageViewController.h"
#import "HXSelectTimeView.h"
#import "HXLearnReportModel.h"

@interface HXHistoryLearnReportViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *childVcs;
@property (nonatomic, strong) YNPageConfigration *configration;
@property (nonatomic, strong) YNPageViewController *pageViewVc;
//头部
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *selectTimeBtn;

@property (nonatomic, strong) HXSelectTimeView *selectTimeView;

@property(strong,nonatomic) NSMutableArray *timeList;

@property (nonatomic, strong) HXLearnReportModel *learnReportModel;

@end

@implementation HXHistoryLearnReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取历史版本时间
    [self getStuHisVersionTime];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
    
}

#pragma mark - Event
-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//选择时间
-(void)selectTime:(UIButton *)sender{
    if (self.timeList.count<=0) return;
    self.selectTimeView.dataArray = self.timeList;
    [self.selectTimeView show];
    ///选择日期回调
    WeakSelf(weakSelf);
    self.selectTimeView.selectTimeCallBack = ^(BOOL isRefresh, HXHistoryTimeModel * _Nonnull selectExamDateModel) {
        if (isRefresh){
            [weakSelf.selectTimeBtn setTitle:selectExamDateModel.createDate forState:UIControlStateNormal];
            //刷新数据
            [weakSelf getLearnReport:selectExamDateModel];
        }
    };
    
}

#pragma mark -  获取历史版本时间
-(void)getStuHisVersionTime{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_StuHisVersionTime  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXHistoryTimeModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.timeList removeAllObjects];
            [self.timeList addObjectsFromArray:array];
            //默认选择第一个
            HXHistoryTimeModel *model = self.timeList.firstObject;
            model.isSelected = YES;
            //获取历史学习报告
            [self getLearnReport:model];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark -  获取历史学习报告
-(void)getLearnReport:(HXHistoryTimeModel *)historyTimeModel{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"createDate":HXSafeString(historyTimeModel.createDate)//历史版本时间，有值为历史学习报告 空值为学习报告
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_LearnReport  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.learnReportModel = [HXLearnReportModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [self refreshUI];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

#pragma mark - UI
-(void)refreshUI{
    
    [self.titles removeAllObjects];
    [self.childVcs removeAllObjects];
    
    //刷新数据页面、所有View、菜单栏、headerView - 默认移除缓存控制器
    [self.pageViewVc reloadData];
    
    for (HXLearnModuleModel *learnModuleModel in self.learnReportModel.learnModuleList) {
        if (learnModuleModel.learnCourseItemList.count>0) {
            [self.titles addObject:learnModuleModel.ModuleName];
            switch (learnModuleModel.type) {
                case 1:
                {
                    HXVideoLearnViewController *vc = [[HXVideoLearnViewController alloc] init];
                    vc.isHistory = YES;
                    vc.ModuleName = learnModuleModel.ModuleName;
                    vc.learnCourseItemList = learnModuleModel.learnCourseItemList;
                    [self.childVcs addObject:vc];
                }
                    break;
                case 2:
                {
                    HXPSZYViewController *vc = [[HXPSZYViewController alloc] init];
                    vc.isHistory = YES;
                    vc.ModuleName = learnModuleModel.ModuleName;
                    vc.learnCourseItemList = learnModuleModel.learnCourseItemList;
                    [self.childVcs addObject:vc];
                }
                    break;
                case 3:
                {
                    HXQMKSViewController *vc = [[HXQMKSViewController alloc] init];
                    vc.isHistory = YES;
                    vc.ModuleName = learnModuleModel.ModuleName;
                    vc.learnCourseItemList = learnModuleModel.learnCourseItemList;
                    [self.childVcs addObject:vc];
                }
                    break;
                case 4:
                {
                    HXLNZTViewController *vc = [[HXLNZTViewController alloc] init];
                    vc.isHistory = YES;
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
    configration.lineColor = COLOR_WITH_ALPHA(0xFF7934, 1);
    configration.itemFont = HXBoldFont(14);
    configration.selectedItemFont = HXBoldFont(14);
    configration.normalItemColor = COLOR_WITH_ALPHA(0xB1B1B1, 1);
    configration.selectedItemColor = COLOR_WITH_ALPHA(0xFF7934, 1);
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
-(NSMutableArray *)timeList{
    if (!_timeList) {
        _timeList = [NSMutableArray array];
    }
    return _timeList;
}

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
        [_headerView addSubview:self.selectTimeBtn];
        
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
        .topSpaceToView(self.backBtn, 20)
        .leftSpaceToView(_headerView, 20)
        .rightSpaceToView(_headerView, 20)
        .heightIs(28);
        
        self.selectTimeBtn.sd_layout
        .leftEqualToView(self.titleLabel)
        .topSpaceToView(self.titleLabel, 10)
        .rightSpaceToView(_headerView, 20)
        .heightIs(22);
        
        self.selectTimeBtn.titleLabel.sd_layout
        .centerYEqualToView(self.selectTimeBtn)
        .leftEqualToView(self.selectTimeBtn)
        .heightIs(22);
        [self.selectTimeBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:250];
        
        self.selectTimeBtn.imageView.sd_layout
        .centerYEqualToView(self.selectTimeBtn)
        .leftSpaceToView(self.selectTimeBtn.titleLabel, 15)
        .widthIs(20)
        .heightIs(20);
        
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
        _bgImageView.image = [UIImage imageNamed:@"historylearnreport_bg"];
    }
    return _bgImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HXBoldFont(20);
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = @"历史学习报告";
    }
    return _titleLabel;
}


-(UIButton *)selectTimeBtn{
    if (!_selectTimeBtn) {
        _selectTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectTimeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _selectTimeBtn.titleLabel.font = HXFont(16);
        [_selectTimeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_selectTimeBtn setTitle:@"2020-12-01 至 2021-07-26" forState:UIControlStateNormal];
        [_selectTimeBtn setImage:[UIImage imageNamed:@"selecttime_icon"] forState:UIControlStateNormal];
        [_selectTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectTimeBtn;
}

-(HXSelectTimeView *)selectTimeView{
    if (!_selectTimeView) {
        _selectTimeView = [[HXSelectTimeView alloc] init];
    }
    return _selectTimeView;
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
