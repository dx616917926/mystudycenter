//
//  HXLoginViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/2.
//

#import "HXLoginViewController.h"
#import "AppDelegate.h"
#import "HXForgetPasswordController.h"
#import "HXCommonWebViewController.h"
#import "JPUSHService.h"
#import "HXDomainNameModel.h"
#import "HXSelectJiGouCell.h"

@interface HXLoginViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIScrollView *mainScrollView;
@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UILabel *welcomeLoginLabel;
@property(nonatomic,strong) UITextField *userNameTextField;
@property(nonatomic,strong) UIView *line1;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UIButton *checkPwdBtn;
@property(nonatomic,strong) UIView *line2;
@property(nonatomic,strong) UIButton *forgetPwdBtn;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIButton *agreeAppBtn;
@property(nonatomic,strong) UIButton *privacyBtn;

@property(nonatomic,strong) UILabel *versionLabel;


@property(nonatomic,strong) UIView *jiGouView;
@property(nonatomic,strong) UIImageView *logoImageView2;
@property(nonatomic,strong) UILabel *selectJiGouLabel;
@property(nonatomic,strong) UILabel *loginJiGouLabel;
@property(nonatomic,strong) UIButton *jiGouNameBtn;
@property(nonatomic,strong) UIView *line3;
@property(nonatomic,strong) UIButton *confireBtn;
@property(nonatomic,strong) UIButton *previousBtn;

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UITableView *jiGouTableView;

@property(nonatomic,strong) NSMutableArray *domainNameList;
//选择的域名
@property(nonatomic,strong) HXDomainNameModel *seletDomainNameModel;

@end

@implementation HXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    //获取隐私协议
    [self getPrivacyUrl];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - 获取隐私协议
-(void)getPrivacyUrl{
    AFHTTPSessionManager *client = [AFHTTPSessionManager manager];
    client.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *URLString = [KHX_API_Domain stringByAppendingString:HXPOST_Get_PrivacyUrl];
    [client POST:URLString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [HXPublicParamTool sharedInstance].privacyUrl = HXSafeString([dictionary objectForKey:@"Data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求地址:%@",task.currentRequest.URL);
        NSLog(@"报错:%@",error.localizedDescription);
    }];
}


#pragma mark - 获取域名
-(void)getDomainNameList{
    [HXBaseURLSessionManager setBaseURLStr:KHX_API_Domain];
    NSDictionary *dic = @{
        @"personId":HXSafeString(self.userNameTextField.text)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetDomainNameList withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.domainNameList removeAllObjects];
            NSArray *list = [HXDomainNameModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.domainNameList addObjectsFromArray:list];
            HXDomainNameModel *model = list.firstObject;
            if (list.count>1) {//多域名处理
                [self.view addSubview:self.jiGouView];
            }else{//只有一个域名默认选择第一个登陆
                if (![HXCommonUtil isNull:model.DomainName]) {
                    //修改baseURL
                    [HXUserDefaults setObject:HXSafeString(model.DomainName) forKey:KP_SERVER_KEY];
                    [HXBaseURLSessionManager setBaseURLStr:HXSafeString(model.DomainName)];
                    [self login];
                }else{
                    [self.view showErrorWithMessage:@"域名不存在"];
                    self.loginBtn.userInteractionEnabled = YES;
                }
            }
        }else{
            self.loginBtn.userInteractionEnabled = YES;
        }
    } failure:^(NSError * _Nonnull error) {
        self.loginBtn.userInteractionEnabled = YES;
    }];

}


#pragma mark - 登录请求
-(void)login{
   
    NSLog(@"服务器地址: %@", KHXUserDefaultsForValue(KP_SERVER_KEY));
    WeakSelf(weakSelf);
    [self.view showLoadingWithMessage:@"登录中…"];
    [HXBaseURLSessionManager doLoginWithUserName:self.userNameTextField.text andPassword:self.passwordTextField.text success:^(NSDictionary * _Nonnull dictionary) {
       
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [HXPublicParamTool sharedInstance].isLogin = YES;
            [HXPublicParamTool sharedInstance].username = self.userNameTextField.text;
            [weakSelf.view showSuccessWithMessage:@"登录成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.view hideLoading];
                //发送登录成功的通知
                [HXNotificationCenter postNotificationName:LOGINSUCCESS object:nil];
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                }];
                //修改更控制器
                [[[UIApplication sharedApplication].delegate window] setRootViewController:[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController]];
                //登录成功设置别名
                [JPUSHService setAlias:@"minedu" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    NSLog(@"%ld  %@  %ld",(long)iResCode,iAlias,(long)seq);
                } seq:4];
                //返回上一页
                [weakSelf previousBtnClick];
            });
        }else{
            weakSelf.loginBtn.userInteractionEnabled = YES;
            [weakSelf.view hideLoading];
        }
    } failure:^(NSString * _Nonnull messsage) {
        weakSelf.loginBtn.userInteractionEnabled = YES;
        [weakSelf.view showErrorWithMessage:messsage];
    }];
}



#pragma mark - Event
- (void)loginButtonClick{
    self.loginBtn.userInteractionEnabled = NO;
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (!self.agreeAppBtn.selected) {
        self.loginBtn.userInteractionEnabled = YES;
        [self.view showTostWithMessage:@"请先阅读并同意《用户协议隐私政策》"];
        return;
    }
    
    if ([HXCommonUtil isNull:self.userNameTextField.text]) {
        self.loginBtn.userInteractionEnabled = YES;
        [self.view showTostWithMessage:@"用户名必须填写"];
        return;
    }
    
    if ([HXCommonUtil isNull:self.passwordTextField.text]) {
        self.loginBtn.userInteractionEnabled = YES;
        [self.view showTostWithMessage:@"密码必须填写"];
        return;
    }
    
#if kHXISFenKuLogin
    [self getDomainNameList];
#else
    [HXBaseURLSessionManager setBaseURLStr:KHX_URL_MAIN];
    [self login];
#endif
    

}

//选择机构
-(void)selectJiGou:(UIButton *)sender{
    
    if (self.maskView.superview) {
        [self.maskView removeFromSuperview];
    }else{
        [self.jiGouView addSubview:self.maskView];
    }
    //重置frame，数据变了，防止布局没改变
    CGSize size = CGSizeMake(kScreenWidth-110, (self.domainNameList.count*50>300?230:self.domainNameList.count*50));
    CGRect frame = self.maskView.frame;
    frame.size = size;
    self.maskView.frame = frame;
    [self.jiGouTableView reloadData];
}

//确定
-(void)confireBtnClick{
    if (self.seletDomainNameModel==nil) {
        [self.view showTostWithMessage:@"请选择登陆的机构"];
        return;
    }else if ([HXCommonUtil isNull:self.seletDomainNameModel.DomainName]) {
        [self.view showTostWithMessage:@"域名不存在"];
        return;
    }
    //修改baseURL
    [HXUserDefaults setObject:HXSafeString(self.seletDomainNameModel.DomainName) forKey:KP_SERVER_KEY];
    [HXBaseURLSessionManager setBaseURLStr:HXSafeString(self.seletDomainNameModel.DomainName)];
    [self login];
}

//返回上一步
-(void)previousBtnClick{
    self.loginBtn.userInteractionEnabled = YES;
    self.seletDomainNameModel = nil;
    self.jiGouNameBtn.selected = NO;
    [self.jiGouNameBtn setTitle:@"" forState:UIControlStateNormal];
    [self.domainNameList removeAllObjects];
    [self.maskView removeFromSuperview];
    [self.jiGouView removeFromSuperview];
}

//查看密码
-(void)checkPwd{
    self.checkPwdBtn.selected = !self.checkPwdBtn.selected;
    self.passwordTextField.secureTextEntry = !self.checkPwdBtn.selected;
}
//同意本APP
-(void)agreeApp{
    self.agreeAppBtn.selected = !self.agreeAppBtn.selected;
    self.loginBtn.selected = !self.loginBtn.selected;
}

//查看用户协议隐私政策
-(void)checkPrivacy{
    HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
    webViewVC.urlString = [HXPublicParamTool sharedInstance].privacyUrl;
    webViewVC.cuntomTitle = @"隐私协议";
    [self.navigationController pushViewController:webViewVC animated:YES];
}


- (void)forgetPwdButtonClick {
    //重设密码
    HXForgetPasswordController *resetVC = [[HXForgetPasswordController alloc] init];
    [self.navigationController pushViewController:resetVC animated:YES];
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.domainNameList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectJiGouCellIdentifier = @"HXSelectJiGouCellIdentifier";
    HXSelectJiGouCell *cell = [tableView dequeueReusableCellWithIdentifier:selectJiGouCellIdentifier];
    if (!cell) {
        cell = [[HXSelectJiGouCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectJiGouCellIdentifier];
    }
    if (indexPath.row<self.domainNameList.count) {
        cell.domainNameModel = self.domainNameList[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.domainNameList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXDomainNameModel *model = obj;
        model.isSelected = NO;
        if (indexPath.row == idx) {
            model.isSelected = YES;
            self.seletDomainNameModel = model;
        }else{
            model.isSelected = NO;
        }
    }];
    [self.jiGouTableView reloadData];
    self.confireBtn.selected = self.seletDomainNameModel!=nil;
    [self.jiGouNameBtn setTitle:self.seletDomainNameModel.OzName forState:UIControlStateNormal];
    [self.maskView removeFromSuperview];
}
        


#pragma mark - UI
-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.logoImageView];
    [self.mainScrollView addSubview:self.welcomeLoginLabel];
    [self.mainScrollView addSubview:self.userNameTextField];
    [self.mainScrollView addSubview:self.line1];
    [self.mainScrollView addSubview:self.passwordTextField];
    [self.mainScrollView addSubview:self.checkPwdBtn];
    [self.mainScrollView addSubview:self.line2];
//    [self.mainScrollView addSubview:self.forgetPwdBtn];
    [self.mainScrollView addSubview:self.loginBtn];
    [self.mainScrollView addSubview:self.bottomView];
    [self.bottomView addSubview:self.agreeAppBtn];
    [self.bottomView addSubview:self.privacyBtn];
    
    self.mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.logoImageView.sd_layout
    .topSpaceToView(self.mainScrollView, _kph(100))
    .leftSpaceToView(self.mainScrollView, 30)
    .widthIs(150)
    .heightIs(49);
    
    self.welcomeLoginLabel.sd_layout
    .topSpaceToView(self.logoImageView, 52)
    .leftSpaceToView(self.mainScrollView, 30)
    .rightSpaceToView(self.mainScrollView, 30)
    .heightIs(52);

    self.userNameTextField.sd_layout
    .topSpaceToView(self.welcomeLoginLabel, 30)
    .leftSpaceToView(self.mainScrollView, 30)
    .rightSpaceToView(self.mainScrollView, 30)
    .heightIs(40);
    
    self.line1.sd_layout
    .topSpaceToView(self.userNameTextField, 0)
    .leftEqualToView(self.userNameTextField)
    .rightEqualToView(self.userNameTextField)
    .heightIs(1);
    
    self.passwordTextField.sd_layout
    .topSpaceToView(self.line1, 30)
    .leftEqualToView(self.userNameTextField)
    .rightSpaceToView(self.mainScrollView, 60)
    .heightIs(40);
    
    self.checkPwdBtn.sd_layout
    .centerYEqualToView(self.passwordTextField)
    .rightSpaceToView(self.mainScrollView, 30)
    .widthIs(30)
    .heightIs(40);
    
    self.checkPwdBtn.imageView.sd_layout
    .centerYEqualToView(self.checkPwdBtn)
    .rightEqualToView(self.checkPwdBtn)
    .widthIs(20)
    .heightIs(13);
    
    
    self.line2.sd_layout
    .topSpaceToView(self.passwordTextField, 0)
    .leftEqualToView(self.userNameTextField)
    .rightEqualToView(self.userNameTextField)
    .heightIs(1);
    
//    self.forgetPwdBtn.sd_layout
//    .topSpaceToView(self.line2, 6)
//    .rightEqualToView(self.line2)
//    .widthIs(100)
//    .heightIs(30);
//
//    self.forgetPwdBtn.imageView.sd_layout
//    .centerYEqualToView(self.forgetPwdBtn)
//    .rightEqualToView(self.forgetPwdBtn)
//    .heightIs(10)
//    .widthEqualToHeight();
//
//    self.forgetPwdBtn.titleLabel.sd_layout
//    .centerYEqualToView(self.forgetPwdBtn)
//    .leftEqualToView(self.forgetPwdBtn)
//    .rightSpaceToView(self.forgetPwdBtn.imageView, 5)
//    .heightIs(14);
    
    self.loginBtn.sd_layout
    .topSpaceToView(self.line2, 50)
    .leftEqualToView(self.userNameTextField)
    .rightEqualToView(self.userNameTextField)
    .heightIs(45);
    self.loginBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.loginBtn.imageView.sd_layout
    .centerYEqualToView(self.loginBtn)
    .centerXEqualToView(self.loginBtn).offset(20)
    .widthIs(15)
    .heightEqualToWidth();
    
    self.loginBtn.titleLabel.sd_layout
    .centerYEqualToView(self.loginBtn)
    .centerXEqualToView(self.loginBtn).offset(-20)
    .widthIs(50)
    .heightIs(25);
    
    self.bottomView.sd_layout
    .topSpaceToView(self.loginBtn, 20)
    .centerXEqualToView(self.mainScrollView)
    .heightIs(30);
    
    self.agreeAppBtn.sd_layout
    .leftSpaceToView(self.bottomView, 0)
    .centerYEqualToView(self.bottomView)
    .heightIs(30);
    
    self.agreeAppBtn.imageView.sd_layout
    .leftEqualToView(self.agreeAppBtn)
    .centerYEqualToView(self.agreeAppBtn)
    .widthIs(20)
    .heightEqualToWidth();
    
    self.agreeAppBtn.titleLabel.sd_layout
    .centerYEqualToView(self.agreeAppBtn)
    .leftSpaceToView(self.agreeAppBtn.imageView, 10)
    .heightIs(18);
    [self.agreeAppBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    [self.agreeAppBtn setupAutoWidthWithRightView:self.agreeAppBtn.titleLabel rightMargin:5];
    
    self.privacyBtn.sd_layout
    .leftSpaceToView(self.agreeAppBtn, 0)
    .centerYEqualToView(self.bottomView)
    .heightIs(30);
    self.privacyBtn.titleLabel.sd_layout
    .centerYEqualToView(self.privacyBtn)
    .leftSpaceToView(self.privacyBtn, 0)
    .heightIs(18);
    [self.privacyBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    [self.privacyBtn setupAutoWidthWithRightView:self.privacyBtn.titleLabel rightMargin:5];
    
    [self.bottomView setupAutoWidthWithRightView:self.privacyBtn rightMargin:0];
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.bottomView bottomMargin:50];
    
#ifdef kHXCanChangeServer
    ///长按切换
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeEnvironment:)];
    press.minimumPressDuration = 0.6;
    [self.logoImageView addGestureRecognizer:press];
    //双击自定义输入
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customEditServer:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.logoImageView addGestureRecognizer:doubleTap];
    
    [doubleTap requireGestureRecognizerToFail:press];
    
    UILabel *tiplabel = [[UILabel alloc] init];
    tiplabel.text = @"如果想切换环境，请长按Logo切换，便于开发调试！";
    tiplabel.font = HXFont(12);
    tiplabel.textColor = [UIColor redColor];
    tiplabel.textAlignment = NSTextAlignmentCenter;
    [self.mainScrollView addSubview:tiplabel];
    tiplabel.sd_layout
    .topSpaceToView(self.logoImageView, 5)
    .leftEqualToView(self.logoImageView)
    .rightSpaceToView(self.mainScrollView, 30)
    .heightIs(15);
#endif
    
    
#ifdef DEBUG

    if (kHXAPPEdition == kHXReleaseEdition) {
        self.userNameTextField.text = @"445322199905108545";//正式帐号:430481200008085667   测试帐号:654226198808126083
        self.passwordTextField.text = @"445322199905108545";
    }else{
        self.userNameTextField.text = @"445322199905108545";
        self.passwordTextField.text = @"445322199905108545";
    }
#endif
}

#pragma mark - lazyload
-(NSMutableArray *)domainNameList{
    if (!_domainNameList) {
        _domainNameList = [NSMutableArray array];
    }
    return _domainNameList;
}
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mainScrollView;
}

-(UILabel *)welcomeLoginLabel{
    if (!_welcomeLoginLabel) {
        _welcomeLoginLabel = [[UILabel alloc] init];
        _welcomeLoginLabel.text = @"用户名登录";
        _welcomeLoginLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _welcomeLoginLabel.font = HXBoldFont(25);
    }
    return _welcomeLoginLabel;
}

-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"login_logo"];
        _logoImageView.userInteractionEnabled = YES;
    }
    return _logoImageView;
}

-(UITextField *)userNameTextField{
    if (!_userNameTextField) {
        _userNameTextField = [[UITextField alloc] init];
        _userNameTextField.delegate = self;
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        userNameLabel.textAlignment = NSTextAlignmentLeft;
        userNameLabel.font = HXFont(14);
        userNameLabel.textColor = COLOR_WITH_ALPHA(0x9C9C9C, 1);
        userNameLabel.text = @"用户名";
        [leftView addSubview:userNameLabel];
        _userNameTextField.leftView = leftView;
        _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _userNameTextField;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = COLOR_WITH_ALPHA(0xC8C8C8, 1);
    }
    return _line1;
}


-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        passwordLabel.textAlignment = NSTextAlignmentLeft;
        passwordLabel.font = HXFont(14);
        passwordLabel.textColor = COLOR_WITH_ALPHA(0x9C9C9C, 1);
        passwordLabel.text = @"密码";
        [leftView addSubview:passwordLabel];
        _passwordTextField.leftView = leftView;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTextField;
}

-(UIButton *)checkPwdBtn{
    if (!_checkPwdBtn) {
        _checkPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkPwdBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _checkPwdBtn.selected = NO;
        [_checkPwdBtn setImage:[UIImage imageNamed:@"pwd_nosee"] forState:UIControlStateNormal];
        [_checkPwdBtn setImage:[UIImage imageNamed:@"pwd_see"] forState:UIControlStateSelected];
        [_checkPwdBtn addTarget:self action:@selector(checkPwd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkPwdBtn;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = COLOR_WITH_ALPHA(0xC8C8C8, 1);
    }
    return _line2;
}

-(UIButton *)forgetPwdBtn{
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPwdBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _forgetPwdBtn.titleLabel.font = HXFont(10);
        [_forgetPwdBtn setTitleColor:COLOR_WITH_ALPHA(0x2183EB, 1) forState:UIControlStateNormal];
        [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPwdBtn setImage:[UIImage imageNamed:@"login_ask"] forState:UIControlStateNormal];
        [_forgetPwdBtn addTarget:self action:@selector(forgetPwdButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.selected = NO;
        _loginBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _loginBtn.titleLabel.font = HXBoldFont(18);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setImage:[UIImage imageNamed:@"login_arrow"] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = COLOR_WITH_ALPHA(0xB7B7B7, 1);
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_unselect"] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_select"] forState:UIControlStateSelected];
        [_loginBtn addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

-(UIButton *)agreeAppBtn{
    if (!_agreeAppBtn) {
        _agreeAppBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeAppBtn.selected = NO;
        _agreeAppBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _agreeAppBtn.titleLabel.font = HXFont(13);
        [_agreeAppBtn setTitleColor:COLOR_WITH_ALPHA(0x9C9C9C, 1) forState:UIControlStateNormal];
        [_agreeAppBtn setTitle:@"已阅读并同意本APP" forState:UIControlStateNormal];
        [_agreeAppBtn setImage:[UIImage imageNamed:@"noagree_icon"] forState:UIControlStateNormal];
        [_agreeAppBtn setImage:[UIImage imageNamed:@"agree_icon"] forState:UIControlStateSelected];
        [_agreeAppBtn addTarget:self action:@selector(agreeApp) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeAppBtn;
}

-(UIButton *)privacyBtn{
    if (!_privacyBtn) {
        _privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _privacyBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _privacyBtn.titleLabel.font = HXFont(13);
        [_privacyBtn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
        [_privacyBtn setTitle:@"《用户协议隐私政策》" forState:UIControlStateNormal];
        [_privacyBtn addTarget:self action:@selector(checkPrivacy) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacyBtn;
}

#pragma mark - 选择机构弹框
-(UIView *)jiGouView{
    if (!_jiGouView) {
        _jiGouView = [[UIView alloc] initWithFrame:self.view.bounds];
        _jiGouView.backgroundColor = UIColor.whiteColor;
        [_jiGouView addSubview:self.logoImageView2];
        [_jiGouView addSubview:self.selectJiGouLabel];
        [_jiGouView addSubview:self.loginJiGouLabel];
        [_jiGouView addSubview:self.jiGouNameBtn];
        [_jiGouView addSubview:self.line3];
        [_jiGouView addSubview:self.confireBtn];
        [_jiGouView addSubview:self.previousBtn];
        
        self.logoImageView2.sd_layout
        .topSpaceToView(_jiGouView, _kph(100))
        .leftSpaceToView(_jiGouView, 30)
        .widthIs(150)
        .heightIs(49);
        
        self.selectJiGouLabel.sd_layout
        .topSpaceToView(self.logoImageView2, 52)
        .leftSpaceToView(_jiGouView, 30)
        .rightSpaceToView(_jiGouView, 30)
        .heightIs(52);
        
        self.line3.sd_layout
        .topSpaceToView(self.selectJiGouLabel, 81)
        .leftEqualToView(self.selectJiGouLabel)
        .rightEqualToView(self.selectJiGouLabel)
        .heightIs(1);

        self.loginJiGouLabel.sd_layout
        .bottomSpaceToView(self.line3, 6)
        .leftEqualToView(self.line3)
        .widthIs(60)
        .heightIs(20);
        
        self.jiGouNameBtn.sd_layout
        .bottomSpaceToView(self.line3, 0)
        .leftSpaceToView(self.loginJiGouLabel, 25)
        .rightEqualToView(self.line3)
        .heightIs(30);
        
        self.jiGouNameBtn.imageView.sd_layout
        .centerYEqualToView(self.jiGouNameBtn)
        .rightSpaceToView(self.jiGouNameBtn, 6)
        .widthIs(10)
        .heightIs(7);
        
        self.jiGouNameBtn.titleLabel.sd_layout
        .centerYEqualToView(self.jiGouNameBtn)
        .rightSpaceToView(self.jiGouNameBtn.imageView, 6)
        .leftEqualToView(self.jiGouNameBtn)
        .heightIs(22);
        
        self.confireBtn.sd_layout
        .topSpaceToView(self.line3, 50)
        .leftEqualToView(self.line3)
        .rightEqualToView(self.line3)
        .heightIs(45);
        self.confireBtn.sd_cornerRadiusFromHeightRatio = @0.5;
        
        self.confireBtn.imageView.sd_layout
        .centerYEqualToView(self.confireBtn)
        .centerXEqualToView(self.confireBtn).offset(20)
        .widthIs(15)
        .heightEqualToWidth();
        
        self.confireBtn.titleLabel.sd_layout
        .centerYEqualToView(self.confireBtn)
        .centerXEqualToView(self.confireBtn).offset(-20)
        .widthIs(50)
        .heightIs(25);
        
        self.previousBtn.sd_layout
        .bottomSpaceToView(_jiGouView, 60)
        .rightSpaceToView(_jiGouView, 20)
        .widthIs(120)
        .heightIs(30);
        
        self.previousBtn.titleLabel.sd_layout
        .centerYEqualToView(self.previousBtn)
        .rightEqualToView(self.previousBtn)
        .heightIs(20);
        [self.previousBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:80];
        
        self.previousBtn.imageView.sd_layout
        .centerYEqualToView(self.previousBtn)
        .rightSpaceToView(self.previousBtn.titleLabel, 5)
        .heightIs(15)
        .widthIs(15);
        
    }
    return _jiGouView;
}


-(UIImageView *)logoImageView2{
    if (!_logoImageView2) {
        _logoImageView2 = [[UIImageView alloc] init];
        _logoImageView2.image = [UIImage imageNamed:@"login_logo"];
        _logoImageView2.userInteractionEnabled = YES;
    }
    return _logoImageView2;
}

-(UILabel *)selectJiGouLabel{
    if (!_selectJiGouLabel) {
        _selectJiGouLabel = [[UILabel alloc] init];
        _selectJiGouLabel.text = @"选择您即将登陆的机构";
        _selectJiGouLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _selectJiGouLabel.font = HXBoldFont(25);
    }
    return _selectJiGouLabel;
}

-(UILabel *)loginJiGouLabel{
    if (!_loginJiGouLabel) {
        _loginJiGouLabel = [[UILabel alloc] init];
        _loginJiGouLabel.text = @"登陆机构";
        _loginJiGouLabel.textColor = COLOR_WITH_ALPHA(0x9C9C9C, 1);
        _loginJiGouLabel.font = HXFont(14);
    }
    return _loginJiGouLabel;
}


-(UIButton *)jiGouNameBtn{
    if (!_jiGouNameBtn) {
        _jiGouNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jiGouNameBtn.selected = NO;
        _jiGouNameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _jiGouNameBtn.titleLabel.font = HXFont(16);
        [_jiGouNameBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_jiGouNameBtn setImage:[UIImage imageNamed:@"triangle_down"] forState:UIControlStateNormal];
        [_jiGouNameBtn addTarget:self action:@selector(selectJiGou:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jiGouNameBtn;
}

- (UIView *)line3{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = COLOR_WITH_ALPHA(0xC8C8C8, 1);
    }
    return _line3;
}

-(UIButton *)confireBtn{
    if (!_confireBtn) {
        _confireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confireBtn.selected = NO;
        _confireBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _confireBtn.titleLabel.font = HXBoldFont(18);
        [_confireBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confireBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confireBtn setImage:[UIImage imageNamed:@"login_arrow"] forState:UIControlStateNormal];
        _confireBtn.backgroundColor = COLOR_WITH_ALPHA(0xB7B7B7, 1);
        [_confireBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_unselect"] forState:UIControlStateNormal];
        [_confireBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_select"] forState:UIControlStateSelected];
        [_confireBtn addTarget:self action:@selector(confireBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confireBtn;
}

-(UIButton *)previousBtn{
    if (!_previousBtn) {
        _previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _previousBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _previousBtn.titleLabel.font = HXFont(14);
        [_previousBtn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
        [_previousBtn setTitle:@"返回上一步" forState:UIControlStateNormal];
        [_previousBtn setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_previousBtn addTarget:self action:@selector(previousBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousBtn;
}


-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(80, CGRectGetMinY(self.line3.frame)+1, kScreenWidth-110, (self.domainNameList.count*50>300?230:self.domainNameList.count*50))];
        _maskView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
        _maskView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _maskView.layer.shadowOffset = CGSizeMake(0, 3);
        _maskView.layer.shadowRadius = 6;
        _maskView.layer.shadowOpacity = 1;
        [_maskView addSubview:self.jiGouTableView];
        self.jiGouTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _maskView;
}

-(UITableView *)jiGouTableView{
    if (!_jiGouTableView) {
        _jiGouTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _jiGouTableView.backgroundColor = UIColor.whiteColor;
        _jiGouTableView.bounces = NO;
        _jiGouTableView.delegate = self;
        _jiGouTableView.dataSource = self;
        _jiGouTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_jiGouTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_jiGouTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if (@available(iOS 11.0, *)) {
            _jiGouTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _jiGouTableView.estimatedRowHeight = 0;
        }
        _jiGouTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _jiGouTableView.scrollIndicatorInsets = _jiGouTableView.contentInset;
        _jiGouTableView.showsVerticalScrollIndicator = YES;
    }
    return _jiGouTableView;
    
}


- (void)showAppVersion {
    // app版本
    NSString *app_Version = [NSString stringWithFormat:@"当前版本：v%@ (%@)",APP_VERSION,APP_BUILDVERSION];
    self.versionLabel.text = app_Version;
}





#pragma mark - 点击切换域名

#ifdef kHXCanChangeServer

- (void)changeEnvironment:(UILongPressGestureRecognizer*)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"服务器切换" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [controller addAction:[UIAlertAction actionWithTitle:@"正式服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HXUserDefaults setObject:kHXReleasServer forKey:KP_SERVER_KEY];
            
            NSLog(@"切换到服务器: %@", KHX_URL_MAIN);
            
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"TestOP测试服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HXUserDefaults setObject:kHXDevelopOPServer forKey:KP_SERVER_KEY];
            NSLog(@"切换到服务器: %@", KHX_URL_MAIN);
            
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"TestMD测试服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HXUserDefaults setObject:kHXDevelopMDServer forKey:KP_SERVER_KEY];
            NSLog(@"切换到服务器: %@", KHX_URL_MAIN);
            
        }]];
       
        [controller addAction:[UIAlertAction actionWithTitle:@"LWJ主机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HXUserDefaults setObject:kHXDevelopLWJEServer forKey:KP_SERVER_KEY];
            NSLog(@"切换到服务器: %@", KHX_URL_MAIN);
            
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)customEditServer:(UITapGestureRecognizer *)tap {
    
    __block UITextField *_textfield;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"输入服务器地址" message:@"编辑IP地址即可" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _textfield = textField;
        _textfield.text = KHX_URL_MAIN;
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = [NSString stringWithFormat:@"%@",_textfield.text];
        [HXUserDefaults setObject:url forKey:KP_SERVER_KEY];
        NSLog(@"切换到服务器: %@", KHX_URL_MAIN);
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

///注销登录
- (void)presentToLogin {
    [[HXPublicParamTool sharedInstance] logOut];
}

#endif


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
