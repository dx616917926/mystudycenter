//
//  HXVertifyCodeViewController.m
//  HXMinedu
//
//  Created by Mac on 2021/1/5.
//

#import "HXVertifyCodeViewController.h"
#import "HXVertifyCodeContentView.h"

@interface HXVertifyCodeViewController ()<HXVertifyCodeContentViewDeleagte>
{
    HXVertifyCodeContentView *contentView;
}

@property(nonatomic, strong) HXBarButtonItem *leftBarItem;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger currentTimeCount;

@end

@implementation HXVertifyCodeViewController

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
    
    self.sc_navigationBar.title = @"手机号验证";
    self.sc_navigationBar.titleLabel.textColor = [UIColor blackColor];
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    
    [self initContentView];
    [self initTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [contentView.mVertifyCodeTextField becomeFirstResponder];
}

- (void)initContentView {
    
    contentView = [[UINib nibWithNibName:NSStringFromClass([HXVertifyCodeContentView class]) bundle:nil] instantiateWithOwner:self options:nil].lastObject;
    contentView.delegate = self;
    contentView.mMobileLabel.text = self.mobile;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationBarHeight);
        make.height.mas_equalTo(@220);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
    }];
}

- (void)initTimer {
    self.currentTimeCount = 60;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction{
    if (self.currentTimeCount == 0) {
        contentView.mTimeLabel.text = @"";
        contentView.mSendButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }
    else{
        contentView.mSendButton.enabled = NO;
        self.currentTimeCount --;
        contentView.mTimeLabel.text = [NSString stringWithFormat:@"(%lds)",(long)self.currentTimeCount];
    }
}

#pragma mark - HXVertifyCodeContentViewDeleagte

//完成按钮
- (void)completeButtonClick
{
    NSDictionary *parameters = @{@"mobile":self.mobile,@"pwd":self.pwd,@"yzm":contentView.mVertifyCodeTextField.text};

    [self.view showLoading];
            
    __weak __typeof(self)weakSelf = self;
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_RESET_PWD withDictionary:parameters success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            NSString *message = [dictionary stringValueForKey:@"Message"];
            [weakSelf.view showSuccessWithMessage:message completionBlock:^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
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

//重新发送验证码
- (void)sendButtonClick
{
    if (self.timer.isValid) {
        return;
    }
    
    NSDictionary *parameters = @{@"mobile":self.mobile};

    [self.view showLoading];
            
    __weak __typeof(self)weakSelf = self;
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_SENDCODE withDictionary:parameters success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            
            NSString *message = [dictionary stringValueForKey:@"Message"];
            [weakSelf.view showSuccessWithMessage:message];
            
            weakSelf.currentTimeCount = 60;
            weakSelf.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];

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
