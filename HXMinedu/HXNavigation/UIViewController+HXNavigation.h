//
//  UIViewController+HXNavigation.h
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBarButtonItem.h"
#import "HXNavigationBar.h"

@interface UIViewController (HXNavigation)

@property (nonatomic, strong) HXNavigationBar *sc_navigationBar;

@property (nonatomic,assign) BOOL sc_NavigationBarAnimateInvalid;//关闭跳转动画时Navigationbar的动画

@property(nonatomic, getter = sc_isNavigationBarHidden) BOOL sc_navigationBarHidden;

- (void)sc_setNavigationBarBackgroundAlpha:(CGFloat)alpha;

- (void)sc_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (HXBarButtonItem *)createBackItem;

- (void)createNavigationBar;
@end
