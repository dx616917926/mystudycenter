//
//  QCScrollView.m
//  eplatform-edu
//
//  Created by iMac on 2016/10/28.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "QCScrollView.h"

@implementation QCScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer)
    {
        //限定滑动范围
        if (self.contentOffset.x == 0) {
            //不能超出左边界
            CGPoint translation = [self.panGestureRecognizer translationInView:self];
            return translation.x < 0;
        }else if (self.contentOffset.x == self.contentSize.width - self.bounds.size.width) {
            //不能超出右边界
            CGPoint translation = [self.panGestureRecognizer translationInView:self];
            return translation.x > 0;
        }
    }
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([otherGestureRecognizer class] == [UIPanGestureRecognizer class]) {
//        
//        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
//            return YES;
//        }
//    }
//    
//    return NO;
//}

@end
