//
//  HXNavigationPushAnimation.m
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import "HXNavigationPushAnimation.h"

@implementation HXNavigationPushAnimation

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    //    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    fromViewController.view.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(fromViewController.view.frame));
    toViewController.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(toViewController.view.frame));
    
    toViewController.sc_navigationBar.isTransition = YES;
    fromViewController.sc_navigationBar.isTransition = YES;
    
    // Configure Navi Transition
    
//    UIView *naviBarView;
    UIImageView *naviBarView;

    UIView *toNaviLeft;
    UIView *toNaviRight;
    UIView *toNaviTitle;
    UIView *toNaviTitleView;
    
    UIView *fromNaviLeft;
    UIView *fromNaviRight;
    UIView *fromNaviTitle;
    UIView *fromNaviTitleView;
    
    if (fromViewController.sc_NavigationBarAnimateInvalid || toViewController.sc_NavigationBarAnimateInvalid || fromViewController.sc_isNavigationBarHidden || toViewController.sc_isNavigationBarHidden) {
        ;
    } else {
        
        naviBarView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kNavigationBarHeight}];
        naviBarView.contentMode = UIViewContentModeScaleToFill;
//        naviBarView.backgroundColor = kNavigationBarColor;
        naviBarView.image = [UIImage imageNamed:@"navi_bgImage"];
        [containerView addSubview:naviBarView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0, kNavigationBarHeight, kScreenWidth, 0.5}];
        lineView.backgroundColor = kNavigationBarLineColor;
        [naviBarView addSubview:lineView];
        
        toNaviLeft = toViewController.sc_navigationBar.leftBarButtonItem.view;
        toNaviRight = toViewController.sc_navigationBar.rightBarButtonItem.view;
        toNaviTitle = toViewController.sc_navigationBar.titleLabel;
        toNaviTitleView = toViewController.sc_navigationBar.titleView;
        
        fromNaviLeft = fromViewController.sc_navigationBar.leftBarButtonItem.view;
        fromNaviRight = fromViewController.sc_navigationBar.rightBarButtonItem.view;
        fromNaviTitle = fromViewController.sc_navigationBar.titleLabel;
        fromNaviTitleView = fromViewController.sc_navigationBar.titleView;
        
        [containerView addSubview:toNaviLeft];
        [containerView addSubview:toNaviTitle];
        [containerView addSubview:toNaviTitleView];
        [containerView addSubview:toNaviRight];
        
        [containerView addSubview:fromNaviLeft];
        [containerView addSubview:fromNaviTitle];
        [containerView addSubview:fromNaviTitleView];
        [containerView addSubview:fromNaviRight];
        
        fromNaviLeft.alpha = 1.0;
        fromNaviRight.alpha =  1.0;
        fromNaviTitle.alpha = 1.0;
        fromNaviTitleView.alpha = 1.0;
        
        toNaviLeft.alpha = 0.0;
        toNaviRight.alpha = 0.0;
        toNaviTitle.alpha = 0.0;
        toNaviTitle.centerX = 44;
        toNaviTitleView.alpha = 0.0;
        toNaviTitleView.centerX = 44;
        
        toNaviLeft.x = 0;
        toNaviTitle.centerX = kScreenWidth;
        toNaviTitleView.centerX = kScreenWidth;
        toNaviRight.x = kScreenWidth + 50 - toNaviRight.width;
        
    }
    
    // End configure
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.x = 0;
        fromViewController.view.x = -120;
        
        fromNaviLeft.alpha = 0;
        fromNaviRight.alpha =  0;
        fromNaviTitle.alpha = 0;
        fromNaviTitle.centerX = 0;
        fromNaviTitleView.alpha = 0;
        fromNaviTitleView.centerX = 0;
        
        toNaviLeft.alpha = 1.0;
        toNaviRight.alpha = 1.0;
        toNaviTitle.alpha = 1.0;
        toNaviTitle.centerX = kScreenWidth/2;
        toNaviTitleView.alpha = 1.0;
        toNaviTitleView.centerX = kScreenWidth/2;
        toNaviLeft.x = 0;
        toNaviRight.x = kScreenWidth - toNaviRight.width;
        
        
    } completion:^(BOOL finished) {
        
        toViewController.sc_navigationBar.isTransition = NO;
        fromViewController.sc_navigationBar.isTransition = NO;
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        fromNaviLeft.alpha = 1.0;
        fromNaviRight.alpha = 1.0;
        fromNaviTitle.alpha = 1.0;
        fromNaviTitle.centerX = kScreenWidth / 2;
        fromNaviTitleView.alpha = 1.0;
        fromNaviTitleView.centerX = kScreenWidth / 2;
        fromNaviLeft.x = 0;
        fromNaviRight.x = kScreenWidth - fromNaviRight.width;
        
        [naviBarView removeFromSuperview];
        
        [toNaviLeft removeFromSuperview];
        [toNaviTitle removeFromSuperview];
        [toNaviTitleView removeFromSuperview];
        [toNaviRight removeFromSuperview];
        
        [fromNaviLeft removeFromSuperview];
        [fromNaviTitle removeFromSuperview];
        [fromNaviTitleView removeFromSuperview];
        [fromNaviRight removeFromSuperview];
        
        [toViewController.sc_navigationBar addSubview:toNaviLeft];
        [toViewController.sc_navigationBar addSubview:toNaviTitle];
        [toViewController.sc_navigationBar addSubview:toNaviTitleView];
        [toViewController.sc_navigationBar addSubview:toNaviRight];
        
        [fromViewController.sc_navigationBar addSubview:fromNaviLeft];
        [fromViewController.sc_navigationBar addSubview:fromNaviTitle];
        [fromViewController.sc_navigationBar addSubview:fromNaviTitleView];
        [fromViewController.sc_navigationBar addSubview:fromNaviRight];
        
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
