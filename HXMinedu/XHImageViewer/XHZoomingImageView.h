//
//  XHZoomingImageView.h
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHZoomingImageView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, readonly) BOOL isViewing;

@end
