//
//  HXCustomToastView.m
//  HXMinedu
//
//  Created by mac on 2021/6/7.
//

#import "HXCustomToastView.h"

@interface HXCustomToastView ()
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *tipLabel;
@end

@implementation HXCustomToastView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


-(void)createUI{
    [self.maskView addSubview:self];
    [self addSubview:self.whiteView];
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.iconImageView];
    [self.whiteView addSubview:self.tipLabel];
    
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.whiteView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self).offset(-kNavigationBarHeight)
    .widthIs(kScreenWidth-_kpw(40)*2)
    .heightIs(164);
    self.whiteView.sd_cornerRadius = @10;
    
    self.iconImageView.sd_layout
    .centerXEqualToView(self.whiteView)
    .topSpaceToView(self.whiteView, 32)
    .widthIs(50)
    .heightEqualToWidth();
    
    self.tipLabel.sd_layout
    .topSpaceToView(self.iconImageView, 25)
    .leftSpaceToView(self.whiteView, _kpw(32))
    .rightSpaceToView(self.whiteView, _kpw(32))
    .autoHeightRatio(0);
    
}

-(void)showConfirmToastHideAfter:(NSTimeInterval)second{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    self.iconImageView.image = [UIImage imageNamed:@"toastconfirm_icon"];
    self.tipLabel.text = @"您已完成确认，请耐心等待审核哦~";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

-(void)showRejectToastHideAfter:(NSTimeInterval)second{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    self.iconImageView.image = [UIImage imageNamed:@"toastreject_icon"];
    self.tipLabel.text = @"您已驳回，请及时与老师沟通哦~";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

-(void)dismiss{
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}

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

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = HXFont(14);
        _tipLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

@end
