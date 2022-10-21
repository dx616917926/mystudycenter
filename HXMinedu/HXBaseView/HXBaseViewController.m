//
//  HXBaseViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import "HXBaseViewController.h"

@interface HXBaseViewController ()

@end

@implementation HXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_blackback"] style:HXBarButtonItemStyleCustom handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_NavigationBarAnimateInvalid = YES;
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    self.view.backgroundColor = kControllerViewBackgroundColor;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (BOOL)isLogin{
    return [HXPublicParamTool sharedInstance].isLogin;
}

- (void)dealloc {
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.navigationController.viewControllers.count>1) {
        if (@available(iOS 13.0, *)) {
            return UIStatusBarStyleDarkContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    }else{
        return UIStatusBarStyleLightContent;
    }
   
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
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
