//
//  HXResetViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/3.
//

#import "HXResetViewController.h"
#import "HXResetTableViewCell.h"
#import "NSString+HXString.h"

@interface HXResetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITextField *oldPassWordTextField;//旧的密码
@property(nonatomic,strong)UITextField *firstPassWordTextField;//新的密码1
@property(nonatomic,strong)UITextField *secondPassWordTextField;//新的密码2
//
@property (nonatomic, strong) UITableView *mTableView;/*表视图*/
@property (nonatomic, strong) NSArray *cellTitleArray;/*cell内容数组*/
@property (nonatomic, strong) NSArray *placeholderTitleArray;/*提示信息*/


@end

@implementation HXResetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sc_navigationBar.title = @"修改密码";
    self.cellTitleArray = @[@"旧密码：",@"新密码：",@"确认密码："];
    self.placeholderTitleArray = @[@"请输入旧密码",@"请输入新的密码",@"请再一次输入新密码"];
    
    [self createResetPassWordView];
}

-(void)createResetPassWordView
{
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
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
    return 3;
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
            self.oldPassWordTextField = cell.mTextField;
            break;
        case 1:
            self.firstPassWordTextField = cell.mTextField;
            break;
        case 2:
            self.secondPassWordTextField = cell.mTextField;
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    CGRect frameRect = CGRectMake(0, 0, kScreenWidth, 80);
    view.frame = frameRect;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenWidth-220)/2, 40, 220, 40);
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
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
    if (self.oldPassWordTextField.text.length == 0) {
        [self.view showTostWithMessage:@"请输入旧密码"];
        [self.oldPassWordTextField becomeFirstResponder];
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
    
    NSDictionary *parameters = @{@"oldPassword":self.oldPassWordTextField.text,
                                 @"newPassword":self.firstPassWordTextField.text};
    [self.view showLoading];
    
    __weak __typeof(self)weakSelf = self;
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_CHANGE_PWD withDictionary:parameters success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            NSString *message = [dictionary stringValueForKey:@"Message"];
            [weakSelf.view showSuccessWithMessage:message];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //退出登录--弹登录框！
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGIN object:nil];
                [weakSelf.tabBarController setSelectedIndex:0];  //默认选中课程模块
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            });

        }else
        {
            NSString *errorMessage = [dictionary stringValueForKey:@"Message"];
            [weakSelf.view showErrorWithMessage:errorMessage];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
