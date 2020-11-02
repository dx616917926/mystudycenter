//
//  XHViewState.h
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHViewState : UIView

@property (nonatomic, strong) UIView *superview;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) BOOL userInteratctionEnabled;
@property (nonatomic, assign) CGAffineTransform transform;

+ (XHViewState *)viewStateForView:(UIView *)view;
- (void)setStateWithView:(UIView *)view;

@end
