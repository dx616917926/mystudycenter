//
//  HXClassDetailViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import "HXClassDetailViewController.h"
#import "QCSlideSwitchView.h"
#import "HXCwsModuleViewController.h"
#import "HXExamModuleViewController.h"
#import "HXPullRefreshViewController.h"

@interface HXClassDetailViewController ()<QCSlideSwitchViewDelegate>
{
    NSMutableArray * modules; //模块
    
    HXPullRefreshViewController * currentVC;//临时变量
}

@property (nonatomic, strong)QCSlideSwitchView *slideSwitchView;

@property (nonatomic, strong)HXCwsModuleViewController * cwsModuleVC;
@property (nonatomic, strong)HXExamModuleViewController * examModuleVC;

@end

@implementation HXClassDetailViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = kControllerViewBackgroundColor;
    
    self.sc_navigationBar.title = self.courseModel.courseName;
    
    
    [self initModules];
    
    [self initQCSlideSwitchView];
}

-(void)initModules
{
    modules = [[NSMutableArray alloc] init];

    //视频
    [modules addObject:self.cwsModuleVC];
    
    //习题
    [modules addObject:self.examModuleVC];

    if (modules.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth, 200)];
        blankBg.backgroundColor  = [UIColor whiteColor];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)/2, 40, 120, 100)];
        logoImg.image = [UIImage imageNamed:@"ic_no_events"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.bottom, kScreenWidth-60, 80)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"您没有模块可以学习！";
        warnMsg.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
        warnMsg.font = [UIFont systemFontOfSize:16];
        warnMsg.textAlignment = NSTextAlignmentCenter;
        [blankBg addSubview:warnMsg];
        [self.view addSubview:blankBg];
    }
}

-(void)initQCSlideSwitchView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.view addSubview:self.slideSwitchView];
    
    self.slideSwitchView.tabItemNormalColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1];
    self.slideSwitchView.tabItemSelectedColor = [UIColor colorWithRed:0.06 green:0.06 blue:0.06 alpha:1];
    
    UIImage * shadow = [UIImage imageNamed:@"qc_slide_shadow"];
    self.slideSwitchView.shadowImage =shadow;
    self.slideSwitchView.widthOfButton = 44;
    
    [self.slideSwitchView buildUI];
    
    self.slideSwitchView.topScrollView.clipsToBounds = NO;
    self.slideSwitchView.topScrollView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.slideSwitchView.topScrollView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.slideSwitchView.topScrollView.layer.shadowOffset = CGSizeMake(0,2);
    self.slideSwitchView.topScrollView.layer.shadowOpacity = 1;
    self.slideSwitchView.topScrollView.layer.shadowRadius = 4;
}

-(HXCwsModuleViewController *)cwsModuleVC
{
    if (!_cwsModuleVC) {
        _cwsModuleVC = [[HXCwsModuleViewController alloc]init];
        _cwsModuleVC.title = @"视频";
        _cwsModuleVC.course_id = self.courseModel.course_id;
        [self addChildViewController:_cwsModuleVC];
    }
    return _cwsModuleVC;
}

-(HXExamModuleViewController *)examModuleVC
{
    if (!_examModuleVC) {
        _examModuleVC = [[HXExamModuleViewController alloc]init];
        _examModuleVC.title = @"习题";
        _examModuleVC.course_id = self.courseModel.course_id;
        [self addChildViewController:_examModuleVC];
    }
    return _examModuleVC;
}

#pragma mark - QCSlideSwitchViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return modules.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return [modules objectAtIndex:number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    NSLog(@"didselectTab: %lu",(unsigned long)number);
    
    currentVC.tableView.scrollsToTop = NO;
    if (modules.count) {
        currentVC = [modules objectAtIndex:number];
    }
    currentVC.tableView.scrollsToTop = YES;
    
    if ([currentVC respondsToSelector:@selector(checkIfNeedReloadData)]) {
        [currentVC performSelector:@selector(checkIfNeedReloadData)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
