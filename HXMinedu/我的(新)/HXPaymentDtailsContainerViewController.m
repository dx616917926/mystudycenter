//
//  HXPaymentDtailsContainerViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXPaymentDtailsContainerViewController.h"
#import "XLPageViewController.h"
#import "HXPaymentDtailChildViewController.h"

@interface HXPaymentDtailsContainerViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
//配置信息
@property (nonatomic, strong) XLPageViewControllerConfig *config;
@property (nonatomic, strong) XLPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *titles;
@property(strong,nonatomic) UITableView *mainTableView;



@end

@implementation HXPaymentDtailsContainerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
}

#pragma mark -<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    HXPaymentDtailChildViewController *childVc = [[HXPaymentDtailChildViewController alloc] init];
    childVc.flag = index+1;
    return childVc;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.titles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.titles.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
   
}

#pragma mark - UI
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"缴费明细";
    [self initPageViewController];
    
}

///初始化子视图控制器
- (void)initPageViewController {
    self.titles = @[@"应缴明细",@"已缴明细",@"未缴明细"];
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
    self.pageViewController.bounces = NO;
    self.pageViewController.view.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

///显示配置
-(XLPageViewControllerConfig *)config{
    XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
    config.titleViewBackgroundColor = [UIColor whiteColor];
    config.titleViewHeight = 58;
    config.titleSpace = _kpw(20);
    config.titleViewInset = UIEdgeInsetsMake(0, _kpw(24), 0, _kpw(24));
    config.titleViewAlignment = XLPageTitleViewAlignmentLeft;
    config.titleViewShadowShow = NO;
    config.shadowLineWidth = _kpw(36);
    config.shadowLineHeight = 3;
    config.shadowLineAlignment = XLPageShadowLineAlignmentTitleBottom;
    config.isGradientColor = YES;
    config.separatorLineHidden =YES;
    config.titleNormalColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
    config.titleSelectedColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    config.titleNormalFont = [UIFont systemFontOfSize:_kpAdaptationWidthFont(14)];
    config.titleSelectedFont =[UIFont boldSystemFontOfSize:_kpAdaptationWidthFont(16)];
    return config;
}


-(void)dealloc{
    ///重新初始化子视图控制器,这里会多次调用，在调用之前先移除原先的，避免多次添加
    [self.pageViewController removeFromParentViewController];
    self.pageViewController = nil;
    self.pageViewController.delegate = nil;
    self.pageViewController.dataSource = nil;
    [self.pageViewController.view removeFromSuperview];
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
