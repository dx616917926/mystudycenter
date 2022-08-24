//
//  HXTouSuView.m
//  HXMinedu
//
//  Created by mac on 2022/8/24.
//

#import "HXTouSuView.h"

@interface HXTouSuView ()

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UIImageView *topImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) UIButton *callBtn;
@property(nonatomic,strong) UIButton *cancelBtn;




@end

@implementation HXTouSuView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)dealloc{
    [HXNotificationCenter removeObserver:self];
}

#pragma mark  - Setter
-(void)setPhone:(NSString *)phone{
    _phone = phone;
    self.phoneLabel.text = phone;
}


#pragma mark - show
-(void)show{
   
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

#pragma mark - UI
-(void)createUI{
    [self.maskView addSubview:self];
    [self addSubview:self.whiteView];
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.topImageView];
    [self.whiteView addSubview:self.titleLabel];
    [self.whiteView addSubview:self.phoneLabel];
    [self.whiteView addSubview:self.callBtn];
    [self.whiteView addSubview:self.cancelBtn];

    
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.whiteView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self).offset(-kStatusBarHeight)
    .widthIs(220)
    .heightIs(270);
    self.whiteView.sd_cornerRadius = @8;
    
    self.topImageView.sd_layout
    .topEqualToView(self.whiteView)
    .leftEqualToView(self.whiteView)
    .rightEqualToView(self.whiteView)
    .heightIs(112);

    self.titleLabel.sd_layout
    .topSpaceToView(self.topImageView, 14)
    .leftSpaceToView(self.whiteView, 20)
    .rightSpaceToView(self.whiteView, 20)
    .heightIs(20);
    
    self.phoneLabel.sd_layout
    .topSpaceToView(self.titleLabel, 12)
    .leftSpaceToView(self.whiteView, 20)
    .rightSpaceToView(self.whiteView, 20)
    .heightIs(20);
    
    self.callBtn.sd_layout
    .topSpaceToView(self.phoneLabel, 12)
    .centerXEqualToView(self.whiteView)
    .widthIs(120)
    .heightIs(28);
    self.callBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.cancelBtn.sd_layout
    .topSpaceToView(self.callBtn, 5)
    .centerXEqualToView(self.whiteView)
    .widthIs(120)
    .heightIs(28);
    
    
}



#pragma mark - Event
-(void)call:(UIButton *)sender{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phone];
    NSURL *urlStr = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:urlStr options:@{} completionHandler:nil];
        } else {// iOS 10.0 之前
            [[UIApplication sharedApplication] openURL:urlStr];
        }
    }
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}

-(void)close:(UIButton *)sender{
    [self.maskView removeFromSuperview];
     self.maskView = nil;
}

#pragma mark - LazyLoad
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _maskView.backgroundColor = COLOR_WITH_ALPHA(0x000000, 0.36);
    }
    return _maskView;
}

-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _whiteView.clipsToBounds = YES;
    }
    return _whiteView;
}

-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"kefu_icon"];
    }
    return _topImageView;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HXFont(14);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x333333, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"拨打您的专属客服联系电话";
    }
    return _titleLabel;
}

-(UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = HXFont(14);
        _phoneLabel.textColor = COLOR_WITH_ALPHA(0x333333, 1);
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.numberOfLines = 1;
    }
    return _phoneLabel;
}

-(UIButton *)callBtn{
    if (!_callBtn) {
        _callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _callBtn.titleLabel.font = HXFont(12);
        _callBtn.backgroundColor = COLOR_WITH_ALPHA(0x327FFE, 1);
        [_callBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_callBtn setTitle:@"立即拨打" forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = HXFont(12);
        _cancelBtn.backgroundColor = UIColor.clearColor;
        [_cancelBtn setTitleColor:COLOR_WITH_ALPHA(0x4188FE, 1) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


@end

