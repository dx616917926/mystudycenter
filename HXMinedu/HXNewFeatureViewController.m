//
//  HXNewFeatureViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/2.
//

#import "HXNewFeatureViewController.h"
#import "AppDelegate.h"

@interface HXNewFeatureViewController ()

@end

@implementation HXNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [useButton setTitle:@"立即使用" forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [useButton addTarget:self action:@selector(useButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useButton];
    
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.rightMargin.mas_equalTo(@30);
        make.topMargin.mas_equalTo(@60);
        make.height.mas_equalTo(44);
    }];
}

- (void)useButtonPressed {
    
    [[[UIApplication sharedApplication].delegate window] setRootViewController:[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController]];
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
