//
//  UIViewController+HXNavigation.m
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

static char const * const kNaviHidden = "kNaviBarHidden";
static char const * const kNaviBarView = "kNaviBarView";
static char const * const kNaviBarAnimate = "kNaviBarAnimate";
#import <objc/runtime.h>


@implementation UIViewController (HXNavigation)

@dynamic sc_navigationBar;
@dynamic sc_navigationBarHidden;
@dynamic sc_NavigationBarAnimateInvalid;

- (BOOL)sc_isNavigationBarHidden {
    return [objc_getAssociatedObject(self, kNaviHidden) boolValue];
}

- (void)setSc_navigationBarHidden:(BOOL)sc_navigationBarHidden {
    objc_setAssociatedObject(self, kNaviHidden, @(sc_navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)sc_NavigationBarAnimateInvalid{
    return [objc_getAssociatedObject(self, kNaviBarAnimate) boolValue];
}

- (void)setSc_NavigationBarAnimateInvalid:(BOOL)sc_NavigationBarAnimateInvalid{
    objc_setAssociatedObject(self, kNaviBarAnimate, @(sc_NavigationBarAnimateInvalid), OBJC_ASSOCIATION_ASSIGN);
}

- (void)sc_setNavigationBarBackgroundAlpha:(CGFloat)alpha{
    //仅仅改变了背景色
    self.sc_navigationBar.backgroundAlpha = alpha;
    
}

- (void)sc_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (animated) {
        if (hidden) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.sc_navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(-44);
                }];
                self.sc_navigationBar.y = -44;
                for (UIView *view in self.sc_navigationBar.subviews) {
                    view.alpha = 0.0;
                }
            } completion:^(BOOL finished) {
                self.sc_navigationBarHidden = YES;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self.sc_navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(0);
                }];
                self.sc_navigationBar.y = 0;
                for (UIView *view in self.sc_navigationBar.subviews) {
                    view.alpha = 1.0;
                }
            } completion:^(BOOL finished) {
                self.sc_navigationBarHidden = NO;
            }];
        }
    }
    else{
        if (hidden) {
            [self.sc_navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.offset(-kNavigationBarHeight);
            }];
            self.sc_navigationBar.y = -kNavigationBarHeight;
            for (UIView *view in self.sc_navigationBar.subviews) {
                view.alpha = 0.0;
            }
            self.sc_navigationBarHidden = YES;
        }
        else{
            [self.sc_navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
            }];
            self.sc_navigationBar.y = 0;
            for (UIView *view in self.sc_navigationBar.subviews) {
                view.alpha = 1.0;
            }
            self.sc_navigationBarHidden = NO;
        }
    }
}

- (HXNavigationBar *)sc_navigationBar {
    return objc_getAssociatedObject(self, kNaviBarView);
}

- (void)setSc_navigationBar:(HXNavigationBar *)sc_navigationBar {
    objc_setAssociatedObject(self, kNaviBarView, sc_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HXBarButtonItem *)createBackItem {
    
    @weakify(self);
    return [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)createNavigationBar {
    
    return [HXNavigationController createNavigationBarForViewController:self];
    
}

@end
