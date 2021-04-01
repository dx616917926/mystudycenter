//
//  HXNavigationBar.m
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import "HXNavigationBar.h"

@interface HXNavigationBar ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) CAGradientLayer *gradientLayer;

@end

@implementation HXNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = (CGRect){0, 0, kScreenWidth, kNavigationBarHeight};
        _backgroundAlpha = 1;
        self.backgroundColor = kNavigationBarColor;
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = (CGRect){0, 0, kScreenWidth, kNavigationBarHeight};
        [self.imageView setImage:[UIImage imageNamed:@"navbar_bg"]];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageView];
        self.lineView = [[UIView alloc] initWithFrame:(CGRect){0, kNavigationBarHeight, kScreenWidth, 0.5}];
        self.lineView.backgroundColor = kNavigationBarLineColor;
//        [self addSubview:self.lineView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeChangeNotification) name:kThemeDidChangeNotification object:nil];
        
    }
    return self;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.bounds =(CGRect){0, 0, kScreenWidth, kNavigationBarHeight};
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        _gradientLayer.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr = @[(id)[UIColor redColor].CGColor,(id)[UIColor greenColor].CGColor,(id)[UIColor blueColor].CGColor];
        _gradientLayer.colors = colorArr;
    }
    return _gradientLayer;
}


-(void)setBackgroundAlpha:(CGFloat)alpha
{
    _backgroundAlpha = alpha;
    self.backgroundColor = [kNavigationBarColor colorWithAlphaComponent:alpha];
    self.imageView.alpha = alpha;
    self.lineView.backgroundColor = [kNavigationBarLineColor colorWithAlphaComponent:alpha];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isTransition) {
        return;
    }
    if (self.notNeedLayoutSubviews) {
        return;
    }
    self.frame = (CGRect){0, self.y, kScreenWidth, kNavigationBarHeight};
    
    self.backgroundColor = [kNavigationBarColor colorWithAlphaComponent:self.backgroundAlpha];
    
    self.lineView.frame=(CGRect){0, kNavigationBarHeight, kScreenWidth, 0.5};
    self.lineView.backgroundColor = [kNavigationBarLineColor colorWithAlphaComponent:self.backgroundAlpha];
    
    if (_leftBarButtonItem) {
        _leftBarButtonItem.view.x = 0;
        _leftBarButtonItem.view.centerY = kStatusBarHeight+22;
    }
    
    if (_rightBarButtonItem) {
        _rightBarButtonItem.view.x = kScreenWidth - _rightBarButtonItem.view.width;
        _rightBarButtonItem.view.centerY = kStatusBarHeight+22;
    }
    if (_customRigthView) {
        _customRigthView.x = kScreenWidth - _customRigthView.width;
        _customRigthView.centerY = kStatusBarHeight+22;
    }
    if (_titleLabel) {
        [_titleLabel sizeToFit];
        NSUInteger otherButtonWidth = self.leftBarButtonItem.view.width + self.rightBarButtonItem.view.width;
        _titleLabel.width = kScreenWidth - otherButtonWidth - 20;
        _titleLabel.centerY = kStatusBarHeight+22;
        _titleLabel.centerX = kScreenWidth/2;
    }
    
    if (_titleView) {
        NSUInteger otherButtonWidth = self.leftBarButtonItem.view.width + self.rightBarButtonItem.view.width;
        _titleView.width = kScreenWidth - otherButtonWidth ;
        _titleView.centerY = kStatusBarHeight+22;
        _titleView.x = self.leftBarButtonItem.view.right;
    }
}

- (void)setTitle:(NSString *)title {
    
    //如果设置了titleLabel，则隐藏titleView，只能二选一
    [_titleView removeFromSuperview];
    _titleView = nil;
    
    _title = title;
    
    if (!title) {
        _titleLabel.text = @"";
        return;
    }
    
    if ([title isEqualToString:_titleLabel.text]) {
        return;
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [_titleLabel setTextColor:kNavigationBarTintColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_titleLabel];
    }
    
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    NSUInteger otherButtonWidth = self.leftBarButtonItem.view.width + self.rightBarButtonItem.view.width;
    _titleLabel.width = kScreenWidth - otherButtonWidth - 20;
    _titleLabel.centerY = kStatusBarHeight+22;
    _titleLabel.centerX = kScreenWidth/2;
}

- (void)setTitleView:(UIView *)titleView {
    
    //如果设置了titleView，则隐藏titleLabel
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
    
    [_titleView removeFromSuperview];
    
    _titleView  = titleView;
    
    if (titleView) {
        NSUInteger otherButtonWidth = self.leftBarButtonItem.view.width + self.rightBarButtonItem.view.width;
        _titleView.width = kScreenWidth - otherButtonWidth ;
        _titleView.centerY = kStatusBarHeight+22;
        _titleView.x = self.leftBarButtonItem.view.right;
        [self addSubview:titleView];
    }
}

- (void)setLeftBarButtonItem:(HXBarButtonItem *)leftBarButtonItem {
    
    [_leftBarButtonItem.view removeFromSuperview];
    
    if (leftBarButtonItem) {
        leftBarButtonItem.view.x = 0;
        leftBarButtonItem.view.centerY = kStatusBarHeight+22;
        [self addSubview:leftBarButtonItem.view];
    }
    
    _leftBarButtonItem = leftBarButtonItem;
}

- (void)setRightBarButtonItem:(HXBarButtonItem *)rightBarButtonItem {
    
    [_rightBarButtonItem.view removeFromSuperview];
    
    if (rightBarButtonItem) {
        rightBarButtonItem.view.x = kScreenWidth - rightBarButtonItem.view.width;
        rightBarButtonItem.view.centerY = kStatusBarHeight+22;
        [self addSubview:rightBarButtonItem.view];
    }
    
    _rightBarButtonItem = rightBarButtonItem;
}
- (void)setCustomRigthView:(UIView *)customRigthView{
    [_customRigthView removeFromSuperview];
    if (customRigthView) {
        customRigthView.x = kScreenWidth - customRigthView.width;
        customRigthView.centerY = kStatusBarHeight+22;
        [self addSubview:customRigthView];
    }
}
#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    self.backgroundColor = [kNavigationBarColor colorWithAlphaComponent:self.backgroundAlpha];
    self.lineView.backgroundColor = [kNavigationBarLineColor colorWithAlphaComponent:self.backgroundAlpha];
    [_titleLabel setTextColor:kNavigationBarTintColor];
}

@end
