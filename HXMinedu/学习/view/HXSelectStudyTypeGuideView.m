//
//  HXSelectStudyTypeGuideView.m
//  HXMinedu
//
//  Created by mac on 2021/4/20.
//

#import "HXSelectStudyTypeGuideView.h"
@interface HXSelectStudyTypeGuideView ()

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIImageView *switchBothImageView;
@property(nonatomic,strong) UIButton *knowBtn;

@end

@implementation HXSelectStudyTypeGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.knowBtn];
    [self.maskView addSubview:self.switchBothImageView];

    
    self.knowBtn.sd_layout
    .centerXEqualToView(self.maskView)
    .bottomSpaceToView(self.maskView, 63+kScreenBottomMargin)
    .widthIs(_kpw(168))
    .heightIs(_kpw(50));
    
    self.switchBothImageView.sd_layout
    .topSpaceToView(self.maskView, kNavigationBarHeight+120)
    .centerXEqualToView(self.maskView)
    .widthIs(_kpw(226))
    .heightIs(_kpw(181));
    

    
    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.maskView.bounds];
    // 透明path
    UIBezierPath *path2 = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, kNavigationBarHeight, kScreenWidth, 105) cornerRadius:0] bezierPathByReversingPath];
    [path appendPath:path2];
    
 
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


-(UIImageView *)switchBothImageView{
    if (!_switchBothImageView) {
        _switchBothImageView = [[UIImageView alloc] init];
        _switchBothImageView.image = [UIImage imageNamed:@"switch_both"];
    }
    return _switchBothImageView;
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
