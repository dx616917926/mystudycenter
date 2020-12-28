//
//  UIColor+Extension.m
//  HXMinedu
//
//  Created by Mac on 2020/12/28.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

- (CGFloat)color_red {
    CGFloat r;
    if ([self getRed:&r green:0 blue:0 alpha:0]) {
        return r;
    }
    return 0;
}

- (CGFloat)color_green {
    CGFloat g;
    if ([self getRed:0 green:&g blue:0 alpha:0]) {
        return g;
    }
    return 0;
}

- (CGFloat)color_blue {
    CGFloat b;
    if ([self getRed:0 green:0 blue:&b alpha:0]) {
        return b;
    }
    return 0;
}

- (CGFloat)color_alpha {
    CGFloat a;
    if ([self getRed:0 green:0 blue:0 alpha:&a]) {
        return a;
    }
    return 0;
}

- (UIColor *)transitionToColor:(UIColor *)toColor progress:(CGFloat)progress {
    return [UIColor colorFromColor:self toColor:toColor progress:progress];
}

+ (UIColor *)colorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    progress = MIN(progress, 1.0f);
    CGFloat fromRed = fromColor.color_red;
    CGFloat fromGreen = fromColor.color_green;
    CGFloat fromBlue = fromColor.color_blue;
    CGFloat fromAlpha = fromColor.color_alpha;
    
    CGFloat toRed = toColor.color_red;
    CGFloat toGreen = toColor.color_green;
    CGFloat toBlue = toColor.color_blue;
    CGFloat toAlpha = toColor.color_alpha;
    
    CGFloat finalRed = fromRed + (toRed - fromRed) * progress;
    CGFloat finalGreen = fromGreen + (toGreen - fromGreen) * progress;
    CGFloat finalBlue = fromBlue + (toBlue - fromBlue) * progress;
    CGFloat finalAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    
    return [UIColor colorWithRed:finalRed green:finalGreen blue:finalBlue alpha:finalAlpha];
}

/*!
 * 通过16进制计算颜色
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

/*!
 * 随机色
 */
+ (UIColor *)randomColor {
    CGFloat red = (arc4random()%255/255.0);
    CGFloat green = (arc4random()%255/255.0);
    CGFloat blue = (arc4random()%255/255.0);
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
