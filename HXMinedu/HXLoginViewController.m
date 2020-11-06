//
//  HXLoginViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/2.
//

#import "HXLoginViewController.h"
#import "AppDelegate.h"

@interface HXLoginViewController ()<UITextFieldDelegate>
{
    UITextField *_userNameTextField;
    UITextField *_passWordTextField;
    UITextField *_schoolTextField;
    UIButton *_loginBtn;
    UIImageView *login_icon;
    UIView * mainView; //将控件都放在这上边会好一点
    UIView * topView;
    UIView * contentView;
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
    self.view.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1];
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
    topView = [[UIView alloc] init];
    [mainView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.view).offset(0);
        make.centerX.equalTo(mainView);
        make.width.equalTo(mainView.mas_width);
        make.height.equalTo(@280);
    }];
    //渐变颜色
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,kScreenWidth,280);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:75/255.0 green:157/255.0 blue:254/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:75/255.0 green:207/255.0 blue:254/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [topView.layer addSublayer:gl];
    topView.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:174/255.0 blue:254/255.0 alpha:0.3].CGColor;
    topView.layer.shadowOffset = CGSizeMake(0,2);
    topView.layer.shadowOpacity = 1;
    topView.layer.shadowRadius = 4;
    
    //
    login_icon = [[UIImageView alloc] init];
    login_icon.contentMode = UIViewContentModeScaleAspectFit;
    login_icon.image = [UIImage imageNamed:@"login_logo"];
    [mainView addSubview:login_icon];
    
    [login_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(@30);
        make.width.mas_equalTo(@160);
        make.height.mas_equalTo(@70);
    }];
    
    contentView = [[UIView alloc] init];
    [mainView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(login_icon.mas_bottom).offset(45);
        make.centerX.equalTo(mainView);
        make.left.equalTo(mainView.mas_left).offset(15);
        make.height.equalTo(@260);
    }];
    //登录两个字
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"登录";
    label.font = [UIFont systemFontOfSize:22];
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.offset(-50);
        make.left.offset(10);
        make.height.equalTo(@50);
    }];
    
    //输入框背景
    UIView *bjView = [[UIView alloc] init];
    bjView.backgroundColor = [UIColor whiteColor];
    bjView.layer.cornerRadius = 8;
    bjView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    bjView.layer.shadowOffset = CGSizeMake(0,0);
    bjView.layer.shadowOpacity = 1;
    bjView.layer.shadowRadius = 4;
    [contentView addSubview:bjView];
    [bjView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.left.right.offset(0);
        make.height.equalTo(@130);
    }];
    
    //用户名
    UIView *userNameBg = [[UIView alloc] init];
//    userNameBg.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1];
    [contentView addSubview:userNameBg];
    [userNameBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(margin);
        make.right.offset(-margin);
        make.height.mas_equalTo(@40);
    }];
    
    UIView *userNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    userNameView.backgroundColor = [UIColor clearColor];
    UIImageView *userNameImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username_icon"]];
    userNameImage.frame = CGRectMake(0, 5, 35, 30);
    [userNameView addSubview:userNameImage];
    [userNameBg addSubview:userNameView];
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(margin);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@40);
    }];

    _userNameTextField = [[UITextField alloc] init];
    _userNameTextField.font = [UIFont systemFontOfSize:17];
    _userNameTextField.placeholder = @"请输入账号";
    _userNameTextField.delegate = self;
    _userNameTextField.tintColor = kNavigationBarColor;
    _userNameTextField.backgroundColor = [UIColor clearColor];
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    _userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [userNameBg addSubview:_userNameTextField];
    //
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(userNameView.mas_right).offset(margin);
        make.right.offset(-margin);
        make.bottom.offset(0);
    }];
    //线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:233/255.f green:233/255.f blue:233/255.f alpha:1];
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameBg.mas_bottom).offset(5);
        make.left.offset(margin*2);
        make.right.offset(-margin*2);
        make.height.mas_equalTo(@1);
    }];
    
    //密码
    UIView *passWordBg = [[UIView alloc] init];
//    passWordBg.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1];
    [contentView addSubview:passWordBg];
    [passWordBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.offset(margin);
        make.right.offset(-margin);
        make.height.mas_equalTo(@40);
    }];
    
    UIView *passWordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *passWordImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_icon"]];
    passWordImage.frame = CGRectMake(0, 5, 35, 30);
    [passWordView addSubview:passWordImage];
    [passWordBg addSubview:passWordView];
    [passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(margin);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@40);
    }];

    _passWordTextField =  [[UITextField alloc] init];
    _passWordTextField.font = [UIFont systemFontOfSize:17];
    _passWordTextField.placeholder = @"请输入密码";
    _passWordTextField.delegate = self;
    _passWordTextField.tintColor = kNavigationBarColor;
    _passWordTextField.backgroundColor = [UIColor clearColor];
    _passWordTextField.returnKeyType = UIReturnKeyDone;
    _passWordTextField.secureTextEntry = YES;
    _passWordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passWordBg addSubview:_passWordTextField];
    
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(userNameView.mas_right).offset(margin);
        make.right.offset(-margin);
        make.bottom.offset(0);
    }];
    
    //登录按钮
    _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:1.0].CGColor;
    _loginBtn.layer.cornerRadius = 25;
    _loginBtn.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:0.5].CGColor;
    _loginBtn.layer.shadowOffset = CGSizeMake(0,0);
    _loginBtn.layer.shadowOpacity = 1;
    _loginBtn.layer.shadowRadius = 4;
    [contentView addSubview:_loginBtn];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(_passWordTextField.mas_bottom).offset(60);
        make.left.equalTo(contentView.mas_left).offset(margin);
        make.height.mas_equalTo(@50);
    }];
    
    UILabel *copyrightLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"高等学历继续教育教学教务平台";
        label.userInteractionEnabled = YES;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottomMargin).offset(IS_iPhoneX?0:-20);
            make.centerX.equalTo(self.view);
            make.height.mas_equalTo(17);
        }];
        label;
    });
    
    //版本号Label
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.font = [UIFont systemFontOfSize:15];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_versionLabel];
    
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(copyrightLabel.mas_top);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(28);
    }];
    
    //双击显示版本号
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAppVersion)];
    doubleTap.numberOfTapsRequired = 2;
    [copyrightLabel addGestureRecognizer:doubleTap];

//    //测试账号
//    _passWordTextField.text = @"4685454(F)";
//    _userNameTextField.text = @"4685454(F)";
}

- (void)showAppVersion {
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_BundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    app_Version = [NSString stringWithFormat:@"当前版本：v%@ (%@)",app_Version,app_BundleVersion];
    
    _versionLabel.text = app_Version;
}

- (void)loginBtnClicked:(UIButton *)btn{
    [_userNameTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
    
    if ([_userNameTextField.text isEqualToString:@""]) {
        [self.view showTostWithMessage:@"用户名必须填写"];
        return;
    }
    
    if ([_passWordTextField.text isEqualToString:@""]) {
        [self.view showTostWithMessage:@"密码必须填写"];
        return;
    }
    
    [self.view showLoadingWithMessage:@"登录中…"];
    
    NSDictionary * parameters = @{@"username": _userNameTextField.text,@"password":_passWordTextField.text};
    
    __weak __typeof(self)weakSelf = self;
    [HXBaseURLSessionManager getDataWithNSString:HXGET_LOGIN withDictionary:parameters success:^(NSDictionary *dictionary) {
        
        if (![[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]] isEqualToString:@"1"]) {
            
            NSString * errorMessage = [dictionary stringValueForKey:@"message" WithHolder:nil];
            
            if (!errorMessage) {
                errorMessage = @"登录失败，请重试！";
            }
            [weakSelf.view showErrorWithMessage:errorMessage];
            return;
        }
        
        NSDictionary *dic = [dictionary objectForKey:@"data"];
        NSString *token = [dic stringValueForKey:@"token"];
        //
        [HXPublicParamTool sharedInstance].isLogin = YES;

        [weakSelf.view showSuccessWithMessage:@"登录成功" completionBlock:^{
            
            [self dismissViewControllerAnimated:YES completion:^{

            }];
            
            [[[UIApplication sharedApplication].delegate window] setRootViewController:[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController]];
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        
        if (error.code == NSURLErrorBadServerResponse) {
            [weakSelf.view showErrorWithMessage:@"服务器出错，请稍后再试！"];
        }else
        {
            [weakSelf.view showErrorWithMessage:@"请检查网络！"];
        }
        
        [[[UIApplication sharedApplication].delegate window] setRootViewController:[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController]];

    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userNameTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
}

#pragma mark ------textField代理方法------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

-(void)textFiledEditChanged:(NSNotification *)obj{
    if ([_userNameTextField.text isEqualToString:@""]) {
        _passWordTextField.text = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userNameTextField) {
        [_passWordTextField becomeFirstResponder];
    }else if (textField == _passWordTextField)
    {
        [_passWordTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (_userNameTextField == textField) {
        _passWordTextField.text = @"";
    }
    return YES;
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
