//
//  HXCourseToastView.m
//  HXMinedu
//
//  Created by mac on 2021/7/30.
//

#import "HXCourseToastView.h"

@interface HXCourseToastView ()
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UIButton *closeBtn;

@end

@implementation HXCourseToastView

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
    [self.whiteView addSubview:self.closeBtn];
    
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.whiteView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self).offset(-kNavigationBarHeight)
    .widthIs(kScreenWidth-_kpw(40)*2)
    .heightIs(200);
    self.whiteView.sd_cornerRadius = @14;
    
    self.iconImageView.sd_layout
    .centerXEqualToView(self.whiteView)
    .topSpaceToView(self.whiteView, 32)
    .widthIs(50)
    .heightEqualToWidth();
    
    self.tipLabel.sd_layout
    .topSpaceToView(self.iconImageView, 16)
    .leftSpaceToView(self.whiteView, _kpw(40))
    .rightSpaceToView(self.whiteView, _kpw(40))
    .autoHeightRatio(0);
    
    self.closeBtn.sd_layout
    .rightSpaceToView(self.whiteView, 20)
    .bottomSpaceToView(self.whiteView, 14)
    .widthIs(56)
    .heightIs(32);
    self.closeBtn.sd_cornerRadius = @4;
    
}

-(void)showToastHideAfter:(NSTimeInterval)second{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    self.iconImageView.image = [UIImage imageNamed:@"coursetoast"];
    self.tipLabel.text = @"您的课件版本已更新为最新内容\n加油学习哦~";
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

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.layer.borderWidth = 1;
        _closeBtn.layer.borderColor = COLOR_WITH_ALPHA(0xCFCFCF, 1).CGColor;
        _closeBtn.titleLabel.font = HXFont(14);
        [_closeBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end

