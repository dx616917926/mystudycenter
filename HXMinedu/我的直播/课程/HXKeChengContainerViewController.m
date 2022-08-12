//
//  HXKeChengContainerViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXKeChengContainerViewController.h"
#import "YNPageViewController.h"
#import "HXKeChengRiLiViewController.h"
#import "HXAllKeChengViewController.h"
#import "HXSearchKeChengViewController.h"

@interface HXKeChengContainerViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *childVcs;
@property (nonatomic, strong) YNPageConfigration *configration;
@property (nonatomic, strong) YNPageViewController *pageViewVc;

@end

@implementation HXKeChengContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
}

#pragma mark - Event
-(void)popBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)search:(UIButton *)sender{
    HXSearchKeChengViewController *vc = [[HXSearchKeChengViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    configration.aligmentModeCenter = YES;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = NO;
    configration.bottomLineHeight = 0;
    configration.bottomLineLeftAndRightMargin = 0;
    configration.bottomLineBgColor = COLOR_WITH_ALPHA(0xECECEC, 1);
    configration.lineHeight = 2;
    configration.lineCorner = 2;
    configration.lineLeftAndRightAddWidth = -20;
    configration.lineBottomMargin = 0;
    configration.lineColor = COLOR_WITH_ALPHA(0x4988FD, 1);
    configration.itemFont = HXBoldFont(16);
    configration.selectedItemFont = HXBoldFont(16);
    configration.normalItemColor = COLOR_WITH_ALPHA(0x474747, 1);
    configration.selectedItemColor = COLOR_WITH_ALPHA(0x4988FD, 1);
    configration.itemMargin = 40;
    configration.itemLeftAndRightMargin = 20;
    configration.menuHeight = 44;
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = kStatusBarHeight;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.childVcs
                                                                                titles:self.titles
                                                                                config:configration];
    
    
    
    self.pageViewVc = vc;
    vc.dataSource = self;
    vc.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight)];
    view.backgroundColor = UIColor.whiteColor;
    vc.headerView = view;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    /// 作为子控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"navi_blackback"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    [vc.scrollMenuView addSubview:backBtn];
    backBtn.sd_layout
    .centerYEqualToView(vc.scrollMenuView)
    .leftEqualToView(vc.scrollMenuView)
    .widthIs(60)
    .heightRatioToView(vc.scrollMenuView, 1);
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"bigsearch_icon"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [vc.scrollMenuView addSubview:searchBtn];
    searchBtn.sd_layout
    .centerYEqualToView(vc.scrollMenuView)
    .rightEqualToView(vc.scrollMenuView)
    .widthIs(60)
    .heightRatioToView(vc.scrollMenuView, 1);
    
}
#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[HXKeChengRiLiViewController class]]) {
        return [(HXKeChengRiLiViewController *)vc mainTableView];
    }else if ([vc isKindOfClass:[HXAllKeChengViewController class]]) {
        return [(HXAllKeChengViewController *)vc mainTableView];
    }
    return nil;
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    
    
    
}

- (NSArray *)childVcs{
    NSMutableArray *childVcs = [NSMutableArray array];
    for (int i = 0; i<self.titles.count; i++) {
        switch (i) {
            case 0:
            {
                HXKeChengRiLiViewController *vc = [[HXKeChengRiLiViewController alloc] init];
                [childVcs addObject:vc];
            }
                break;
            case 1:
            {
                HXAllKeChengViewController *vc = [[HXAllKeChengViewController alloc] init];
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
    return @[@"课程日历", @"全部课程"];
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
