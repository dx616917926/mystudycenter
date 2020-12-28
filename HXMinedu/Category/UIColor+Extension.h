//
//  UIColor+Extension.h
//  HXMinedu
//
//  Created by Mac on 2020/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

/**
 *  获取当前 UIColor 对象里的红色色值
 *
 *  @return 红色通道的色值，值范围为0.0-1.0
 */
@property(nonatomic, assign, readonly) CGFloat color_red;

/**
 *  获取当前 UIColor 对象里的绿色色值
 *
 *  @return 绿色通道的色值，值范围为0.0-1.0
 */
@property(nonatomic, assign, readonly) CGFloat color_green;

/**
 *  获取当前 UIColor 对象里的蓝色色值
 *
 *  @return 蓝色通道的色值，值范围为0.0-1.0
 */
@property(nonatomic, assign, readonly) CGFloat color_blue;

/**
 *  获取当前 UIColor 对象里的透明色值
 *
 *  @return 透明通道的色值，值范围为0.0-1.0
 */
@property(nonatomic, assign, readonly) CGFloat color_alpha;

/**
 *  将自身变化到某个目标颜色，可通过参数progress控制变化的程度，最终得到一个纯色
 *  @param toColor 目标颜色
 *  @param progress 变化程度，取值范围0.0f~1.0f
 */
- (UIColor *)transitionToColor:(nullable UIColor *)toColor progress:(CGFloat)progress;

/**
 *  将颜色A变化到颜色B，可通过progress控制变化的程度
 *  @param fromColor 起始颜色
 *  @param toColor 目标颜色
 *  @param progress 变化程度，取值范围0.0f~1.0f
 */
+ (UIColor *)colorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress;


/*!
 * 通过16进制计算颜色
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

/*!
 * 随机色
 */
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
