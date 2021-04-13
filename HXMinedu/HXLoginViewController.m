//
//  HXLoginViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/2.
//

#import "HXLoginViewController.h"
#import "AppDelegate.h"
#import "HXLoginContentView.h"
#import "HXForgetPasswordController.h"
#import "HXCommonWebViewController.h"
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
    
    //获取隐私协议
    [self getPrivacyUrl];
    
    [self createLoginUI];
}

#pragma mark - 获取隐私协议
-(void)getPrivacyUrl{
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_PrivacyUrl  withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [HXPublicParamTool sharedInstance].privacyUrl = HXSafeString([dictionary objectForKey:@"Data"]);
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
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
    loginView.passWordTextField.text = @"430621199908080707";//@"430621199804054256";
    loginView.userNameTextField.text = @"430621199908080707"; //@"430621199804054256";
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
    
    
//    ///获取token
//    __weak __typeof(self)weakSelf = self;
//    [HXBaseURLSessionManager getDataWithNSString:@"http://yapi.edu-edu.com/mock/71/api/ApiLogin/Login"  withDictionary:@{@"UserName":loginView.userNameTextField.text,@"Password":loginView.passWordTextField.text} success:^(NSDictionary * _Nonnull dictionary) {
//        NSLog(@"%@",dictionary);
//        [HXPublicParamTool sharedInstance].token = [dictionary objectForKey:@"Token"];
//        [weakSelf login];
//    } failure:^(NSError * _Nonnull error) {
//        [weakSelf.view showErrorWithMessage:@"登陆失败"];
//    }];
//
    
    [self login];
    
    
    
}

-(void)login{
    __weak __typeof(self)weakSelf = self;
    [self.view showLoadingWithMessage:@"登录中…"];
    [HXBaseURLSessionManager doLoginWithUserName:loginView.userNameTextField.text andPassword:loginView.passWordTextField.text success:^(NSString * _Nonnull personId) {
        //
        NSLog(@"登录成功！");
        
        [HXPublicParamTool sharedInstance].isLogin = YES;
        
        [weakSelf.view showSuccessWithMessage:@"登录成功!"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //发送登录成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUCCESS object:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            
            [[[UIApplication sharedApplication].delegate window] setRootViewController:[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController]];
        });
        
    } failure:^(NSString * _Nonnull messsage) {
        //
        [weakSelf.view showErrorWithMessage:messsage];
    }];
}

- (void)forgetPassworkButtonClick {
    //重设密码
    HXForgetPasswordController *resetVC = [[HXForgetPasswordController alloc] init];
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (void)privacyPolicyButtonClick {
   
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_PrivacyPolicy_URL]];
    HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
    webViewVC.urlString = [HXPublicParamTool sharedInstance].privacyUrl;
    webViewVC.cuntomTitle = @"隐私协议";
    [self.navigationController pushViewController:webViewVC animated:YES];
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
