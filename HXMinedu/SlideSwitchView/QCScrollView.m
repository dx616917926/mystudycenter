//
//  QCScrollView.m
//  eplatform-edu
//
//  Created by iMac on 2016/10/28.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "QCScrollView.h"

@implementation QCScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer class] == [UIPanGestureRecognizer class]) {
        
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
