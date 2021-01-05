//
//  HXVertifyCodeViewController.m
//  HXMinedu
//
//  Created by Mac on 2021/1/5.
//

#import "HXVertifyCodeViewController.h"
#import "HXVertifyCodeContentView.h"

@interface HXVertifyCodeViewController ()
{
    HXVertifyCodeContentView *contentView;
}
@property(nonatomic, strong) HXBarButtonItem *leftBarItem;
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
}

- (void)initContentView {
    
    contentView = [[UINib nibWithNibName:NSStringFromClass([HXVertifyCodeContentView class]) bundle:nil] instantiateWithOwner:self options:nil].lastObject;
//    contentView.delegate = self;
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
