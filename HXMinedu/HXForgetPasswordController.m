//
//  HXForgetPasswordController.m
//  HXMinedu
//
//  Created by Mac on 2021/1/5.
//

#import "HXForgetPasswordController.h"
#import "HXResetTableViewCell.h"
#import "HXVertifyCodeViewController.h"
#import "NSString+HXString.h"

@interface HXForgetPasswordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITextField *mobileTextField;//手机号
@property(nonatomic,strong)UITextField *personIdTextField;//身份证号
@property(nonatomic,strong)UITextField *firstPassWordTextField;//新的密码1
@property(nonatomic,strong)UITextField *secondPassWordTextField;//新的密码2
//
@property (nonatomic, strong) UITableView *mTableView;/*表视图*/
@property (nonatomic, strong) NSArray *cellTitleArray;/*cell内容数组*/
@property (nonatomic, strong) NSArray *placeholderTitleArray;/*提示信息*/

@property (nonatomic, strong)HXBarButtonItem *leftBarItem;
@end

@implementation HXForgetPasswordController


-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStyleCustom handler:^(id sender) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self sc_setNavigationBarBackgroundAlpha:0];
    [self setSc_NavigationBarAnimateInvalid:YES];
    
    self.sc_navigationBar.title = @"重设密码";
    self.sc_navigationBar.titleLabel.textColor = [UIColor blackColor];
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    
    self.cellTitleArray = @[@"手机号：",@"身份证号：",@"新密码：",@"确认密码："];
    self.placeholderTitleArray = @[@"请输入手机号",@"请输入身份证号",@"请输入新的密码",@"请再一次输入新密码"];
    
    [self createResetPassWordView];
}

-(void)createResetPassWordView
{
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.backgroundColor = [UIColor whiteColor];
    [_mTableView registerNib:[UINib nibWithNibName:@"HXResetTableViewCell" bundle:nil] forCellReuseIdentifier:@"HXResetTableViewCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeybord)];
    [_mTableView addGestureRecognizer:tap];
    [self.view addSubview:_mTableView];
}

#pragma mark - 表视图代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXResetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXResetTableViewCell"];
    cell.mTitleLabel.text = _cellTitleArray[indexPath.row];
    cell.mTextField.placeholder = _placeholderTitleArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
            self.mobileTextField = cell.mTextField;
            break;
        case 1:
            self.personIdTextField = cell.mTextField;
            break;
        case 2:
            self.firstPassWordTextField = cell.mTextField;
            break;
        case 3:
            self.secondPassWordTextField = cell.mTextField;
            break;
        default:
            break;
    }
    
    self.mobileTextField.returnKeyType = UIReturnKeyNext;
    self.mobileTextField.keyboardType = UIKeyboardTypePhonePad;
    self.mobileTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mobileTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.personIdTextField.returnKeyType = UIReturnKeyNext;
    self.personIdTextField.keyboardType = UIKeyboardTypePhonePad;
    self.personIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.personIdTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(12,6,kScreenWidth-24,34);
    label.numberOfLines = 0;
    [view addSubview:label];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"请设置登录密码，需8-20位字符，必须包含字母/数字/字符中两种以上组合" attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 1.0;
                                         
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    CGRect frameRect = CGRectMake(0, 0, kScreenWidth, 80);
    view.frame = frameRect;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenWidth-220)/2, 40, 220, 40);
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:1.0].CGColor;
    button.layer.cornerRadius = 20;
    button.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:0.5].CGColor;
    button.layer.shadowOffset = CGSizeMake(0,0);
    button.layer.shadowOpacity = 1;
    button.layer.shadowRadius = 4;
    [view addSubview:button];
    return view;
}

#pragma mark - 按钮事件
//重置密码
-(void)resetBtnAction
{
    if (self.mobileTextField.text.length == 0) {
        [self.view showTostWithMessage:@"请输入手机号"];
        [self.mobileTextField becomeFirstResponder];
        return;
    }
    
    if (![NSString isValidateTelNumber:self.mobileTextField.text]) {
        [self.view showTostWithMessage:@"请填写正确的手机号"];
        return;
    }
    
    if (self.personIdTextField.text.length == 0) {
        [self.view showTostWithMessage:@"请输入身份证号"];
        [self.personIdTextField becomeFirstResponder];
        return;
    }
    
    if (self.firstPassWordTextField.text.length == 0) {
        [self.view showTostWithMessage:@"请输入新密码"];
        [self.firstPassWordTextField becomeFirstResponder];
        return;
    }
    
    if (self.firstPassWordTextField.text.length < 8 || self.firstPassWordTextField.text.length > 20) {
        [self.view showTostWithMessage:@"新密码需8-20位字符"];
        return;
    }
    
    if ([NSString isOnlyNumString:self.firstPassWordTextField.text] || [NSString isOnlyLetterString:self.firstPassWordTextField.text]) {
        [self.view showTostWithMessage:@"新密码必须包含字母/数字/字符中两种以上组合"];
        return;
    }
    
    if (self.secondPassWordTextField.text.length == 0) {
        [self.view showTostWithMessage:@"请输入确认密码"];
        [self.secondPassWordTextField becomeFirstResponder];
        return;
    }
    
    if (![self.firstPassWordTextField.text isEqualToString:self.secondPassWordTextField.text])
    {
        [self.view showTostWithMessage:@"两次密码输入不一致"];
        return;
    }
    
    [self hideKeybord];
    
    NSDictionary *parameters = @{@"mobile":self.mobileTextField.text};

    [self.view showLoading];
            
    __weak __typeof(self)weakSelf = self;
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_SENDCODE withDictionary:parameters success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            NSString *message = [dictionary stringValueForKey:@"Message"];
            [weakSelf.view showSuccessWithMessage:message];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //查收验证码
                HXVertifyCodeViewController *codeVC = [[HXVertifyCodeViewController alloc] init];
                codeVC.personId = self.personIdTextField.text;
                codeVC.mobile = self.mobileTextField.text;
                codeVC.pwd = self.firstPassWordTextField.text;
                [weakSelf.navigationController pushViewController:codeVC animated:YES];
            });

        }else
        {
            NSString *errorMessage = [dictionary stringValueForKey:@"Message"];
            [weakSelf.view showTostWithMessage:errorMessage];
        }
    } failure:^(NSError * _Nonnull error) {
        if (error.code == NSURLErrorBadServerResponse) {
            [weakSelf.view showErrorWithMessage:@"服务器出错，请稍后再试！"];
        }else
        {
            [weakSelf.view showErrorWithMessage:@"请求失败，请重试！"];
        }
    }];
}

#pragma mark 隐藏键盘
//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)hideKeybord
{
    [_mTableView endEditing:YES];
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
