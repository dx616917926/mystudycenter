//
//  UIImage+Extension.h
//  PeiWo
//
//  Created by wihan on 15/4/21.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)name;

/**
 * 声明这张图片用原图(别渲染)
 */
+ (UIImage *)getOriImage:(NSString *)name;

/**
 *  通过给定的颜色值及size得到对应的图片
 *
 *  @param color 颜色值
 *  @param size  图片的尺寸大小
 *
 *  @return 返回值
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

@end
