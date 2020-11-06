//
//  HXHomeViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/2.
//

#import "HXHomeViewController.h"
#import "HXResetViewController.h"
#import "HXSettingViewController.h"

@interface HXHomeViewController ()

@end

@implementation HXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useButton.frame = CGRectMake((kScreenWidth-160)/2, kScreenHeight-100-kScreenBottomMargin, 160, 48);
    [useButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [useButton setBackgroundColor:[UIColor colorWithRed:0.38 green:0.64 blue:0.97 alpha:1.00]];
    [useButton.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useButton.layer.cornerRadius = 24.f;
    [useButton addTarget:self action:@selector(useButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useButton];
}

- (void)useButtonPressed {
    
    HXSettingViewController *resetVC = [[HXSettingViewController alloc] init];
    resetVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resetVC animated:YES];
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
