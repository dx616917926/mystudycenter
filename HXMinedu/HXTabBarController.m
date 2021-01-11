//
//  HXTabBarController.m
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import "HXTabBarController.h"
#import "HXMyCourseViewController.h"
#import "HXLiveViewController.h"
#import "HXHomeViewController.h"
#import "HXLoginViewController.h"

@interface HXTabBarController ()

@property(nonatomic, strong) NSMutableArray *rootArray;

@end

@implementation HXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kControllerViewBackgroundColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLogin) name:SHOWLOGIN object:nil];

    self.rootArray = [[NSMutableArray alloc] init];
    self.tabBar.tintColor = [UIColor blackColor];
}

- (void)showLogin{
    
    //退出登录
    [HXBaseURLSessionManager doLogout];
    
    //删除用户名密码
    [[HXPublicParamTool sharedInstance] logOut];
    
    //删除cookies
    [[HXBaseURLSessionManager sharedClient] clearCookies];
    
    //登录页面
    HXLoginViewController *loginVC = [[HXLoginViewController alloc]init];
    loginVC.sc_navigationBarHidden = YES;
    HXNavigationController *navVC = [[HXNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navVC animated:YES completion:^{
        
    }];
}

- (void)viewWillLayoutSubviews
{
    if (self.viewControllers == nil) {
        //初始化TabBar -- 必须等屏幕旋转完毕之后再调用，否则获取的kScreenHeight值不正确⚠️
        [self setUpTabBarItems];
    }
}

- (void)setUpTabBarItems{
    [self.rootArray removeAllObjects];
    [self setViewControllers:self.rootArray];
    
    //课程
    HXMyCourseViewController *myCourse = [HXMyCourseViewController new];
    HXNavigationController *myCourseNav = [[HXNavigationController alloc] initWithRootViewController:myCourse];
    myCourseNav.tabBarItem.title = @"课程";
    myCourseNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_1"];
    myCourseNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarSelect_1"];

    //直播
    HXLiveViewController *live = [HXLiveViewController new];
    HXNavigationController *liveNav = [[HXNavigationController alloc] initWithRootViewController:live];
    liveNav.tabBarItem.title = @"直播";
    liveNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_2"];
    liveNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarSelect_2"];

    //我的账号
    HXHomeViewController *home = [HXHomeViewController new];
    HXNavigationController *homeNav = [[HXNavigationController alloc] initWithRootViewController:home];
    homeNav.tabBarItem.title = @"我的";
    homeNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_3"];
    homeNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarSelect_3"];

    [self.rootArray addObjectsFromArray:@[myCourseNav,liveNav,homeNav]];
    [self setViewControllers:self.rootArray];
    
    [self.tabBar setTintColor:kNavigationBarColor];
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
