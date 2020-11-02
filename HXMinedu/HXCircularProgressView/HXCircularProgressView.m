//
//  HXCircularProgressView.m
//  CloudClass
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 TheLittleBoy. All rights reserved.
//

#import "HXCircularProgressView.h"

@interface HXCircularProgressView ()
{
    CAShapeLayer *_trackLayer;
    CAShapeLayer *_progressLayer;
}
@property(nonatomic,strong)UILabel * progressLabel;

@end

@implementation HXCircularProgressView

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(NSArray *)progressColor
          lineWidth:(CGFloat)lineWidth
      labelFontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _progressColor = progressColor;
        _lineWidth = lineWidth;
        _backColor = backColor;
        
        if (!progressColor) {
            _progressColor = [NSArray arrayWithObjects:(id)[UIColor redColor].CGColor,(id)[UIColor yellowColor].CGColor,(id)[UIColor greenColor].CGColor, nil];
        }
        
        _progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_progressLabel setTextAlignment:NSTextAlignmentCenter];
        [_progressLabel setTextColor:[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]];
        [_progressLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [self addSubview:_progressLabel];
        
        //背景圆环
        _trackLayer=[CAShapeLayer layer];
        _trackLayer.frame=self.bounds;
        [self.layer addSublayer:_trackLayer];
        
        _trackLayer.fillColor=[UIColor clearColor].CGColor;
        _trackLayer.strokeColor=_backColor.CGColor;
        _trackLayer.opacity=1;//透明度
        _trackLayer.lineCap=kCALineCapRound;//这个参数主要是调整环型进度条边上是不圆角，主要有三个参数kCALineCapRound(圆角)，kCALineCapButt（直角），kCALineCapSquare（这个参数设了跟直角一样）
        _trackLayer.lineWidth=_lineWidth-5;
        
        UIBezierPath *path=[UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width/2, frame.size.height/2)
                                                          radius:(CGRectGetWidth(self.bounds) - self.lineWidth ) / 2
                                                      startAngle:(CGFloat) - M_PI_2
                                                        endAngle:(CGFloat)(1.5 * M_PI)
                                                       clockwise:YES];
        
        _trackLayer.path=[path CGPath];
        
        //前景圆环
        _progressLayer=[CAShapeLayer layer];
        _progressLayer.frame=self.bounds;
        _progressLayer.fillColor=[[UIColor clearColor] CGColor];
        _progressLayer.strokeColor=[UIColor redColor].CGColor;//这个一定不能用clearColor，然显示不出来
        _progressLayer.lineCap=kCALineCapRound;
        _progressLayer.lineWidth=_lineWidth;
        _progressLayer.path=[path CGPath];
        _progressLayer.strokeEnd=0.0;
        
        //渐变蒙版
        CALayer *layer=[CALayer layer];
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width,  self.bounds.size.height);
        gradientLayer.colors = _progressColor; //渐变色数组
        // 改为从上到下的渐变
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [layer addSublayer:gradientLayer];
        
        [layer setMask:_progressLayer];
        
        [self.layer addSublayer:layer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

//设置进度
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    
    _progress = progress;
    NSString * text = [NSString stringWithFormat:@"%.0f%%",100*self.progress];
    self.progressLabel.text = text;
    
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1];
    _progressLayer.strokeEnd=progress;
    
    [CATransaction commit];
}

@end
