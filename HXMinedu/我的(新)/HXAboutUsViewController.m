//
//  HXAboutUsViewController.m
//  HXMinedu
//
//  Created by 邓雄 on 2021/4/8.
//

#import "HXAboutUsViewController.h"
#import "HXCommonWebViewController.h"
#import "HXCheckUpdateTool.h"
@interface HXAboutUsViewController ()

@property(nonatomic,strong) UIImageView *logeImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *versionLabel;

@property(nonatomic,strong) UIButton *updateBtn;
@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,strong) UIButton *privacyBtn;
@property(nonatomic,strong) UILabel *copyrightLabel;

@end

@implementation HXAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //UI
    [self createUI];
   
}

#pragma mark - Event
-(void)checkUpdate:(UIButton *)sender{
   //检查更新
    [[HXCheckUpdateTool sharedInstance] checkUpdateWithInController:self];
}

-(void)lookPrivacy:(UIButton *)sender{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: 
    HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
    webViewVC.urlString = [HXPublicParamTool sharedInstance].privacyUrl;
    webViewVC.cuntomTitle = @"隐私协议";
    [self.navigationController pushViewController:webViewVC animated:YES];
}

#pragma mark - UI
-(void)createUI{
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"关于我们";
    
    [self.view addSubview:self.logeImageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.updateBtn];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.privacyBtn];
    [self.view addSubview:self.copyrightLabel];
    
    
   
   
    self.logeImageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, kNavigationBarHeight+_kph(80))
    .widthIs(_kpw(56))
    .heightEqualToWidth();
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.logeImageView, 18)
    .leftSpaceToView(self.view, _kpw(30))
    .rightSpaceToView(self.view, _kpw(30))
    .heightIs(25);
    
    self.versionLabel.sd_layout
    .topSpaceToView(self.nameLabel, 6)
    .leftSpaceToView(self.view, _kpw(30))
    .rightSpaceToView(self.view, _kpw(30))
    .heightIs(17);
    
    self.updateBtn.sd_layout
    .topSpaceToView(self.versionLabel, 24)
    .leftSpaceToView(self.view, _kpw(30))
    .rightSpaceToView(self.view, _kpw(30))
    .heightIs(42);
    
    self.updateBtn.titleLabel.sd_layout
    .centerYEqualToView(self.updateBtn)
    .leftSpaceToView(self.updateBtn, 3)
    .widthIs(120)
    .heightRatioToView(self.updateBtn, 1);
    
    self.updateBtn.imageView.sd_layout
    .centerYEqualToView(self.updateBtn)
    .rightSpaceToView(self.updateBtn, 7)
    .widthIs(16)
    .heightEqualToWidth();
    
    self.lineView.sd_layout
    .topSpaceToView(self.updateBtn, 1)
    .leftSpaceToView(self.view, _kpw(30))
    .rightSpaceToView(self.view, _kpw(30))
    .heightIs(1);
    
    self.copyrightLabel.sd_layout
    .bottomSpaceToView(self.view, kScreenBottomMargin+32)
    .leftSpaceToView(self.view, _kpw(30))
    .rightSpaceToView(self.view, _kpw(30))
    .autoHeightRatio(0);
    
    
    self.privacyBtn.sd_layout
    .bottomSpaceToView(self.copyrightLabel, 10)
    .centerXEqualToView(self.view)
    .widthIs(150)
    .heightIs(20);
    
    
    
}


#pragma mark - lazyLoad
-(UIImageView *)logeImageView{
    if (!_logeImageView) {
        _logeImageView = [[UIImageView alloc] init];
        _logeImageView.image = [UIImage imageNamed:@"version_logo"];
    }
    return _logeImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _nameLabel.font = HXFont(18);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        _nameLabel.text = appName;
    }
    return _nameLabel;
}

-(UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _versionLabel.font = HXFont(16);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _versionLabel.text = [NSString stringWithFormat:@"Version %@",versionStr];
    }
    return _versionLabel;
}

-(UIButton *)updateBtn{
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateBtn.titleLabel.font = HXFont(16);
        [_updateBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
        [_updateBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_updateBtn setTitle:@"检查新版本" forState:UIControlStateNormal];
        [_updateBtn addTarget:self action:@selector(checkUpdate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.4);
    }
    return _lineView;
}

-(UIButton *)privacyBtn{
    if (!_privacyBtn) {
        _privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _privacyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _privacyBtn.titleLabel.font = HXFont(12);
        [_privacyBtn setTitleColor:COLOR_WITH_ALPHA(0x4BA4FE, 1) forState:UIControlStateNormal];
        [_privacyBtn setTitle:@"《隐私保护指引》" forState:UIControlStateNormal];
        [_privacyBtn addTarget:self action:@selector(lookPrivacy:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacyBtn;
}

-(UILabel *)copyrightLabel{
    if (!_copyrightLabel) {
        _copyrightLabel = [[UILabel alloc] init];
        _copyrightLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _copyrightLabel.font = HXFont(12);
        _copyrightLabel.textAlignment = NSTextAlignmentCenter;
        _copyrightLabel.text = @"湖南灵越网络科技有限公司 版权所有";
    }
    return _copyrightLabel;
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
