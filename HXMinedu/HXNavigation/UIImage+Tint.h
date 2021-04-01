//
//  UIImage+Tint.h
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

@property (nonatomic, strong) UIImage *imageForCurrentTheme;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

- (CGSize)fitWidth:(CGFloat)fitWidth;

@end
