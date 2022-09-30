//
//  HXDianPingSuccessViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/12.
//

#import "HXDianPingSuccessViewController.h"

@interface HXDianPingSuccessViewController ()

@property(nonatomic,strong) UIImageView *successImageView;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UIButton *backZhiBoBtn;

@end

@implementation HXDianPingSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    [self createUI];
}

#pragma mark - Event
-(void)backZhiBo:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.title = @"点评成功";
    [self.view addSubview:self.successImageView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.backZhiBoBtn];
    
    self.successImageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, kNavigationBarHeight+70)
    .widthIs(250)
    .heightIs(250);
    
    self.tipLabel.sd_layout
    .topSpaceToView(self.successImageView, 37)
    .centerXEqualToView(self.view)
    .widthIs(250)
    .autoHeightRatio(0);
    
    self.backZhiBoBtn.sd_layout
    .topSpaceToView(self.tipLabel, 50)
    .centerXEqualToView(self.view)
    .widthIs(144)
    .heightIs(40);
    self.backZhiBoBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
}

#pragma mark - LazyLoad
-(UIImageView *)successImageView{
    if(!_successImageView){
        _successImageView = [[UIImageView alloc] init];
        _successImageView.image = [UIImage imageNamed:@"dianpingsuccess"];
    }
    return _successImageView;
}

-(UILabel *)tipLabel{
    if(!_tipLabel){
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = HXFont(14);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = COLOR_WITH_ALPHA(0xB9BEC6, 1);
        _tipLabel.numberOfLines =0;
        _tipLabel.text = @"感谢您的评价！\n我们将为您提供更好的直播内容";
    }
    return _tipLabel;
}

-(UIButton *)backZhiBoBtn{
    if (!_backZhiBoBtn) {
        _backZhiBoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backZhiBoBtn.backgroundColor =COLOR_WITH_ALPHA(0x5699FF, 1);
        _backZhiBoBtn.titleLabel.font = HXFont(16);
        [_backZhiBoBtn setTitle:@"返回教学首页" forState:UIControlStateNormal];
        [_backZhiBoBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_backZhiBoBtn addTarget:self action:@selector(backZhiBo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backZhiBoBtn;
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
