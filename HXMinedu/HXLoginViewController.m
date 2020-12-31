//
//  HXLoginViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/2.
//

#import "HXLoginViewController.h"
#import "AppDelegate.h"
#import "HXLoginContentView.h"

@interface HXLoginViewController ()<UITextFieldDelegate,HXLoginContentViewDeleagte>
{
    HXLoginContentView *loginView;
    UIImageView *login_icon;
    UIView * mainView; //将控件都放在这上边会好一点
    UILabel *_versionLabel;
}

@end

@implementation HXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLoginUI];
}

- (void)createLoginUI{
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, 400)];
    self.view.backgroundColor = [UIColor whiteColor];
    // iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        mainView.top += 50;
    }
    
    [self.view addSubview:mainView];

    CGFloat margin = 10;
    //小尺寸屏幕适配
    CGFloat offset = 0;
    if (kScreenHeight < 568) {
        offset = 60;
    }
    if (IS_IPAD) {
        offset = 60;
    }
    
    //
    login_icon = [[UIImageView alloc] init];
    login_icon.image = [UIImage imageNamed:@"login_logo"];
    login_icon.userInteractionEnabled = YES;
    [mainView addSubview:login_icon];
    
    [login_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(@30);
        make.width.mas_equalTo(@185);
        make.height.mas_equalTo(@60);
    }];
    
    loginView = [[UINib nibWithNibName:NSStringFromClass([HXLoginContentView class]) bundle:nil] instantiateWithOwner:self options:nil].lastObject;
    loginView.delegate = self;
    [mainView addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(login_icon.mas_bottom).offset(45);
        make.centerX.equalTo(mainView);
        make.height.equalTo(@266);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
    }];
    
    //版本号Label
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.font = [UIFont systemFontOfSize:15];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_versionLabel];
    
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin).offset(IS_iPhoneX?0:-20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(28);
    }];
    
    //双击显示版本号
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAppVersion)];
    doubleTap.numberOfTapsRequired = 2;
    [login_icon addGestureRecognizer:doubleTap];

#ifdef DEBUG
    //测试账号
    loginView.passWordTextField.text = @"11101010011";
    loginView.userNameTextField.text = @"11101010011";
#endif
}

- (void)showAppVersion {
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_BundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    app_Version = [NSString stringWithFormat:@"当前版本：v%@ (%@)",app_Version,app_BundleVersion];
    
    _versionLabel.text = app_Version;
}

#pragma mark - HXLoginContentViewDeleagte

- (void)loginButtonClick{
    
    [loginView.userNameTextField resignFirstResponder];
    [loginView.passWordTextField resignFirstResponder];
    
    if (!loginView.selectButton.selected) {
        [self.view showTostWithMessage:@"请先阅读并同意《用户协议隐私政策》"];
        return;
    }
    
    if ([loginView.userNameTextField.text isEqualToString:@""]) {
        if (loginView.loginType == HXLoginTypeUserName) {
            [self.view showTostWithMessage:@"用户名必须填写"];
        }else
        {
            [self.view showTostWithMessage:@"手机号必须填写"];
        }
        return;
    }
    
    if ([loginView.passWordTextField.text isEqualToString:@""]) {
        [self.view showTostWithMessage:@"密码必须填写"];
        return;
    }
    
    [self.view showLoadingWithMessage:@"登录中…"];
    
    __weak __typeof(self)weakSelf = self;
    [HXBaseURLSessionManager doLoginWithUserName:loginView.userNameTextField.text andPassword:loginView.passWordTextField.text success:^(NSString * _Nonnull personId) {
        //
        [HXPublicParamTool sharedInstance].isLogin = YES;

        [weakSelf.view showSuccessWithMessage:@"登录成功" completionBlock:^{
            
            [self dismissViewControllerAnimated:YES completion:^{

            }];
            
            [[[UIApplication sharedApplication].delegate window] setRootViewController:[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController]];
        }];
        
    } failure:^(NSString * _Nonnull messsage) {
        //
        [weakSelf.view showErrorWithMessage:messsage];
    }];
}

- (void)forgetPassworkButtonClick {
    //
}

- (void)privacyPolicyButtonClick {
    //
    NSLog(@"打开用户隐私页面");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_PrivacyPolicy_URL]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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
