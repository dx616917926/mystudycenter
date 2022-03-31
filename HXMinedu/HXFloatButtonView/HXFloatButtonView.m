//
//  HXFloatButtonView.m
//  zikaoks
//
//  Created by Mac on 2021/12/13.
//  Copyright © 2021 华夏大地教育网. All rights reserved.
//

#import "HXFloatButtonView.h"

@interface HXFloatButtonView ()
{
    
}
@property(nonatomic, strong) UIImageView *contentImageView;
@property(nonatomic, assign) CGPoint touchPoint; //拖动按钮的起始坐标点
@property(nonatomic, assign) CGFloat touchBtnX;
@property(nonatomic, assign) CGFloat touchBtnY;

@end

@implementation HXFloatButtonView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentImageView.frame = self.bounds;
}

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        //
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.frame = self.bounds;
        _contentImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImageViewTapAction)];
        [_contentImageView addGestureRecognizer:tap];
        
        [self addSubview:_contentImageView];
    }
    return _contentImageView;
}

- (void)setContentImage:(UIImage *)contentImage
{
    _contentImage = contentImage;
    
    [self.contentImageView setImage:contentImage];
}

- (void)contentImageViewTapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFloatButtonView:)]) {
        [self.delegate didClickFloatButtonView:self];
    }
}

#pragma mark -  move
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    //按钮刚按下的时候，获取此时的起始坐标
    UITouch *touch = [touches anyObject];
    self.touchPoint = [touch locationInView:self];
    
    self.touchBtnX = self.frame.origin.x;
    self.touchBtnY = self.frame.origin.y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    
    //偏移量(当前坐标 - 起始坐标 = 偏移量)
    CGFloat offsetX = currentPosition.x - self.touchPoint.x;
    CGFloat offsetY = currentPosition.y - self.touchPoint.y;
    
    //移动后的按钮中心坐标
    CGFloat centerX = self.center.x + offsetX;
    CGFloat centerY = self.center.y + offsetY;
    self.center = CGPointMake(centerX, centerY);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGFloat btnWidth = self.frame.size.width;
    CGFloat btnHeight = self.frame.size.height;
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnX = self.frame.origin.x;
    
    CGFloat minDistance = 2;
    
    //结束move的时候，计算移动的距离是>最低要求，如果没有，就调用按钮点击事件
    BOOL isOverX = fabs(btnX - self.touchBtnX) > minDistance;
    BOOL isOverY = fabs(btnY - self.touchBtnY) > minDistance;
    
    if (isOverX || isOverY) {
        //超过移动范围就不响应点击 - 只做移动操作
        [self touchesCancelled:touches withEvent:event];
    }else{
        [super touchesEnded:touches withEvent:event];
    }
    
    //距离屏幕的边距
    CGFloat margin = 10;
    
    CGFloat minY = kNavigationBarHeight + margin;
    if (btnY < minY)
    {
        btnY = minY;
    }
    CGFloat maxY = self.superview.frame.size.height - btnHeight - margin*2 - self.marginBottom;
    if (btnY > maxY)
    {
        btnY = maxY;
    }
    
    //自动识别贴边
    if (self.center.x >= self.superview.frame.size.width/2) {
        
        [UIView animateWithDuration:0.5 animations:^{
            //按钮靠右自动吸边
            CGFloat btnX = self.superview.frame.size.width - btnWidth - margin;
            self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            //按钮靠左吸边
            CGFloat btnX = margin;
            self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
        }];
    }
}
@end
