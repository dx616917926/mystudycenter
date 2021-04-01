//
//  HXGradientProgressView.m
//  HXMinedu
//
//  Created by mac on 2021/3/31.
//

#import "HXGradientProgressView.h"

@interface HXGradientProgressView ()

@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation HXGradientProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
        [self addSubViews];
        ///默认进度
        self.progress = 0.5;
        ///默认渐变色
        self.colorArr = @[COLOR_WITH_ALPHA(0x4BA4FE, 1) , COLOR_WITH_ALPHA(0x45EFCF, 1)];
        
    }
    return self;
}

///默认设置
- (void)config {
    self.alwaysShowAllColor = YES;
    ///进度条背景颜色
    self.bgProgressColor = COLOR_WITH_ALPHA(0xdcdcdc, 1);
   
}


- (void)addSubViews {
    ///创建背景
    [self bgLayer];
    ///创建渐变背景
    [self gradientLayer];
    
    [self addSubview:self.progressLabel];
    [self addSubview:self.unFinishLabel];
}

//更新视图
- (void)updateView {
    self.gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
    self.gradientLayer.colors = [self calcColor];
    self.progressLabel.hidden = self.progress<=0;
}
///生成渐变色
- (NSArray *)calcColor {
    //两种渐变色
    if (self.colorArr.count < 2) {
        return [self colorToCGColor];
    }
    if (self.alwaysShowAllColor || self.progress <= 0) {
        return [self colorToCGColor];
    }
    NSMutableArray *arr = [NSMutableArray array];
    switch (self.colorArr.count) {
        case 2: {
            UIColor *lColor = self.colorArr[0];
            UIColor *rColor = self.colorArr[1];
            [arr addObject:(id)lColor.CGColor];
            CGFloat d_r = [self calcRGBDifferenceWithColor:lColor otherColor:rColor index:0];
            CGFloat d_g = [self calcRGBDifferenceWithColor:lColor otherColor:rColor index:1];
            CGFloat d_b = [self calcRGBDifferenceWithColor:lColor otherColor:rColor index:2];
            [arr addObject:(id)[UIColor colorWithRed:[self colorOfRGBWithColor:lColor index:0] + d_r * self.progress green:[self colorOfRGBWithColor:lColor index:1] + d_g * self.progress blue:[self colorOfRGBWithColor:lColor index:2] + d_b * self.progress alpha:1].CGColor];
            break;
        }
        case 3: {
            UIColor *lColor = self.colorArr[0];
            UIColor *mColor = self.colorArr[1];
            UIColor *rColor = self.colorArr[2];
            [arr addObject:(id)lColor.CGColor];
            if (self.progress <= 0.5) {
                CGFloat d_r = [self calcRGBDifferenceWithColor:lColor otherColor:mColor index:0];
                CGFloat d_g = [self calcRGBDifferenceWithColor:lColor otherColor:mColor index:1];
                CGFloat d_b = [self calcRGBDifferenceWithColor:lColor otherColor:mColor index:2];
                CGFloat progress = self.progress / 0.5;
                [arr addObject:(id)[UIColor colorWithRed:[self colorOfRGBWithColor:lColor index:0] + d_r * progress green:[self colorOfRGBWithColor:lColor index:1] + d_g * progress blue:[self colorOfRGBWithColor:lColor index:2] + d_b * progress alpha:1].CGColor];
            }else {
                [arr addObject:(id)mColor.CGColor];
                CGFloat d_r = [self calcRGBDifferenceWithColor:mColor otherColor:rColor index:0];
                CGFloat d_g = [self calcRGBDifferenceWithColor:mColor otherColor:rColor index:1];
                CGFloat d_b = [self calcRGBDifferenceWithColor:mColor otherColor:rColor index:2];
                CGFloat progress = (self.progress - 0.5) / 0.5;
                [arr addObject:(id)[UIColor colorWithRed:[self colorOfRGBWithColor:mColor index:0] + d_r * progress green:[self colorOfRGBWithColor:mColor index:1] + d_g * progress blue:[self colorOfRGBWithColor:mColor index:2] + d_b * progress alpha:1].CGColor];
                self.gradientLayer.locations = @[@0, @(0.5 / self.progress),@1];
            }
            
            break;
        }
        default:
            [arr addObjectsFromArray:[self colorToCGColor]];
            break;
    }
    return arr;
}

- (NSArray *)colorToCGColor {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.colorArr.count; i++) {
        UIColor *color = self.colorArr[i];
        [arr addObject:(id)color.CGColor];
    }
    return arr;
}

//计算RGB的颜色差 0:R 1:G 2:B
- (CGFloat)calcRGBDifferenceWithColor:(UIColor *)color otherColor:(UIColor *)otherColor index:(NSInteger)index {
    if (index > 2) {
        return 0;
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);///这个colorComponents参数是一个数组，带有4个数值：[]红色分量, 绿色分量, 蓝色分量, alpha分量];
    const CGFloat *otherComponents = CGColorGetComponents(otherColor.CGColor);
    return otherComponents[index] - components[index];
}

//获取对应的RGB
- (CGFloat)colorOfRGBWithColor:(UIColor *)color index:(NSInteger)index {
    if (index > 2) {
        return 0;
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return components[index];
}

#pragma mark -setter
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateView];
}

- (void)setColorArr:(NSArray *)colorArr {
    _colorArr = colorArr;
    [self updateView];
}

#pragma mark - lazyLoad
- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        //一般不用frame，因为不支持隐式动画
        _bgLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _bgLayer.anchorPoint = CGPointMake(0, 0);
        _bgLayer.backgroundColor = self.bgProgressColor.CGColor;
        _bgLayer.cornerRadius = self.frame.size.height / 2.;
        [self.layer addSublayer:_bgLayer];
    }
    return _bgLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        _gradientLayer.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr = self.colorArr;
        _gradientLayer.colors = colorArr;
        _gradientLayer.cornerRadius = self.frame.size.height / 2.;
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}


-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, self.frame.size.height)];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = HXFont(10);
    }
    return _progressLabel;
}

-(UILabel *)unFinishLabel{
    if (!_unFinishLabel) {
        _unFinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-120, 0, 100, self.frame.size.height)];
        _unFinishLabel.textAlignment = NSTextAlignmentRight;
        _unFinishLabel.textColor = [UIColor blackColor];
        _unFinishLabel.font = HXFont(10);
    }
    return _unFinishLabel;
}

@end

