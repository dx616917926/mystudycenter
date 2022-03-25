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

@interface HXHistoryLearnReportViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *childVcs;
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

@end

@implementation HXHistoryLearnReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //布局
    [self createUI];
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
    self.selectTimeView.selectTimeCallBack = ^(BOOL isRefresh, HXExamDateModel * _Nonnull selectExamDateModel) {
        if (isRefresh){
            [weakSelf.selectTimeBtn setTitle:selectExamDateModel.examDate forState:UIControlStateNormal];
        }
    };
    
}

#pragma mark - UI
-(void)createUI{
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

- (NSArray *)childVcs{
    NSMutableArray *childVcs = [NSMutableArray array];
    for (int i = 0; i<self.titles.count; i++) {
        switch (i) {
            case 0:
            {
                HXVideoLearnViewController *vc = [[HXVideoLearnViewController alloc] init];
                vc.isHistory = YES;
                [childVcs addObject:vc];
            }
                break;
            case 1:
            {
                HXPSZYViewController *vc = [[HXPSZYViewController alloc] init];
                vc.isHistory = YES;
                [childVcs addObject:vc];
            }
                break;
            case 2:
            {
                HXQMKSViewController *vc = [[HXQMKSViewController alloc] init];
                vc.isHistory = YES;
                [childVcs addObject:vc];
            }
                break;
            case 3:
            {
                HXLNZTViewController *vc = [[HXLNZTViewController alloc] init];
                vc.isHistory = YES;
                [childVcs addObject:vc];
            }
                break;
    
            default:
                break;
        }
       
    }
    return childVcs;
}

- (NSArray *)titles {
    return @[@"视频学习", @"平时作业", @"期末考试", @"历年真题"];
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
        for (int i=0; i<7; i++) {
            HXExamDateModel *model = [HXExamDateModel new];
            model.examDate = [NSString stringWithFormat:@"2020-%d-20 至 2020-%d-01",i+1,i+2];
            [_timeList addObject:model];
        }
    }
    return _timeList;
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
