//
//  HXTabBarController.m
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import "HXTabBarController.h"
#import "HXStudyViewController.h"
#import "HXMyCourseViewController.h"
#import "HXLiveViewController.h"
#import "HXHomeViewController.h"
#import "HXEducationViewController.h"
#import "HXMyViewController.h"
#import "HXLoginViewController.h"

@interface HXTabBarController ()<UITabBarControllerDelegate>

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
    self.delegate = self;
}

- (void)showLogin{
    
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
    
    //学习
    HXStudyViewController *study = [HXStudyViewController new];
    HXNavigationController *studyNav = [[HXNavigationController alloc] initWithRootViewController:study];
    studyNav.tabBarItem.title = @"学习";
    studyNav.tabBarItem.image = [UIImage getOriImage:@"tabbar_1"];
    studyNav.tabBarItem.selectedImage = [UIImage getOriImage:@"tabbarSelect_1"];
    
    //教务
    HXEducationViewController *education = [HXEducationViewController new];
    HXNavigationController *educationNav = [[HXNavigationController alloc] initWithRootViewController:education];
    educationNav.tabBarItem.title = @"教务";
    educationNav.tabBarItem.image = [UIImage getOriImage:@"tabbar_2"];
    educationNav.tabBarItem.selectedImage = [UIImage getOriImage:@"tabbarSelect_2"];
    
    //课程
    HXMyCourseViewController *myCourse = [HXMyCourseViewController new];
    HXNavigationController *myCourseNav = [[HXNavigationController alloc] initWithRootViewController:myCourse];
    myCourseNav.tabBarItem.title = @"课程";
    myCourseNav.tabBarItem.image = [UIImage getOriImage:@"tabbar_1"];
    myCourseNav.tabBarItem.selectedImage = [UIImage getOriImage:@"tabbarSelect_1"];

    //直播
    HXLiveViewController *live = [HXLiveViewController new];
    HXNavigationController *liveNav = [[HXNavigationController alloc] initWithRootViewController:live];
    liveNav.tabBarItem.title = @"直播";
    liveNav.tabBarItem.image = [UIImage getOriImage:@"tabbar_3"];
    liveNav.tabBarItem.selectedImage = [UIImage getOriImage:@"tabbarSelect_3"];

    //我的
    HXMyViewController *home = [HXMyViewController new];
    HXNavigationController *homeNav = [[HXNavigationController alloc] initWithRootViewController:home];
    homeNav.tabBarItem.title = @"我的";
    homeNav.tabBarItem.image = [UIImage getOriImage:@"tabbar_4"];
    homeNav.tabBarItem.selectedImage = [UIImage getOriImage:@"tabbarSelectImage_4"];

    [self.rootArray addObjectsFromArray:@[studyNav,educationNav,liveNav,homeNav]];
    [self setViewControllers:self.rootArray];
    
    [self.tabBar setTintColor:kNavigationBarColor];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    

}


#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
        CGFloat offset = _kpw(5)+(IS_iPhoneX?3:0);
        if (tabBarController.selectedIndex != 3) {
            for (UITabBarItem *item in self.tabBar.items) {
                if ([item.title isEqualToString:@"我的"]) {
                    item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    item.titlePositionAdjustment = UIOffsetMake(0, 0);
                }
            }
        }else{
            for (UITabBarItem *item in self.tabBar.items) {
                if ([item.title isEqualToString:@"我的"]) {
                    item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
                    item.titlePositionAdjustment = UIOffsetMake(0, 100);
                }
            }
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
