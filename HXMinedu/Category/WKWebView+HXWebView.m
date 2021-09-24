//
//  WKWebView+HXWebView.m
//  gaojijiao
//
//  Created by Mac on 2021/9/9.
//  Copyright © 2021 华夏大地教育网. All rights reserved.
//

#import "WKWebView+HXWebView.h"

@implementation WKWebView (HXWebView)

+ (void)load
{
    if (@available(iOS 11, *)) {
        SEL originalSelector = @selector(canPerformAction:withSender:);
        SEL swizzledSelector = @selector(hx_canPerformAction:withSender:);

        Class class = WKWebView.class;
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (BOOL)hx_canPerformAction:(SEL)action withSender:(id)sender
{
    //NSLog(@"action:%@",NSStringFromSelector(action));
    
    //长按会出现UIMenuController菜单
    //这里只允许基本的全选、复制、粘贴功能，屏蔽查询、学习、共享等功能。
    if(action == @selector(copy:)||
       action == @selector(selectAll:)||
       action == @selector(cut:)||
       action == @selector(select:)||
       action == @selector(paste:)) {
        
        return [self hx_canPerformAction:action withSender:sender];
    }
    
    return NO;
}

@end
