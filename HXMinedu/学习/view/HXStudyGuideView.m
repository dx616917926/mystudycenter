//
//  HXStudyGuideView.m
//  HXMinedu
//
//  Created by mac on 2021/4/20.
//

#import "HXStudyGuideView.h"

@interface HXStudyGuideView ()

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIImageView *switchZhuanYeImageView;
@property(nonatomic,strong) UIImageView *switchCengCiImageView;
@property(nonatomic,strong) UIButton *knowBtn;

@end

@implementation HXStudyGuideView

- (instancetype)initWithFrame:(CGRect)frame WithRect:(CGRect)rect
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithRect:rect];
    }
    return self;
}

-(void)createUIWithRect:(CGRect)rect{
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.knowBtn];
    [self.maskView addSubview:self.switchZhuanYeImageView];
    [self.maskView addSubview:self.switchCengCiImageView];
    
    self.knowBtn.sd_layout
    .centerXEqualToView(self.maskView)
    .bottomSpaceToView(self.maskView, 63+kScreenBottomMargin)
    .widthIs(_kpw(168))
    .heightIs(_kpw(50));
    
    self.switchZhuanYeImageView.sd_layout
    .topSpaceToView(self.maskView, kNavigationBarHeight+5)
    .rightSpaceToView(self.maskView, _kpw(30))
    .widthIs(_kpw(168))
    .heightIs(_kpw(174));
    
    self.switchCengCiImageView.sd_layout
    .topSpaceToView(self.maskView, CGRectGetMaxY(rect)+25)
    .rightSpaceToView(self.maskView, _kpw(10))
    .widthIs(_kpw(172))
    .heightIs(_kpw(166));
    
    
    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.maskView.bounds];
    // 透明path
    UIBezierPath *path2 = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, IS_iPhoneX?34:20, kScreenWidth, kNavigationBarHeight-(IS_iPhoneX?34:20)) cornerRadius:0] bezierPathByReversingPath];
    [path appendPath:path2];
    
    // 透明path3
    UIBezierPath *path3 = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, rect.origin.y-rect.size.height/2, kScreenWidth, 40) cornerRadius:0] bezierPathByReversingPath];
    [path appendPath:path3];
    
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.maskView.layer setMask:shapeLayer];
}

-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)close{
    [self removeFromSuperview];
   
}


-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = COLOR_WITH_ALPHA(0x000000, 0.5);
    }
    return _maskView;
}

-(UIImageView *)switchZhuanYeImageView{
    if (!_switchZhuanYeImageView) {
        _switchZhuanYeImageView = [[UIImageView alloc] init];
        _switchZhuanYeImageView.image = [UIImage imageNamed:@"switch_zhuanye"];
    }
    return _switchZhuanYeImageView;
}

-(UIImageView *)switchCengCiImageView{
    if (!_switchCengCiImageView) {
        _switchCengCiImageView = [[UIImageView alloc] init];
        _switchCengCiImageView.image = [UIImage imageNamed:@"switch_cengci"];
    }
    return _switchCengCiImageView;
}

-(UIButton *)knowBtn{
    if (!_knowBtn) {
        _knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knowBtn setImage:[UIImage imageNamed:@"i_know"] forState:UIControlStateNormal];
        [_knowBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knowBtn;
}

@end
