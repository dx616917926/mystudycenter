//
//  HXFloatButtonView.h
//  zikaoks
//
//  Created by Mac on 2021/12/13.
//  Copyright © 2021 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HXFloatButtonView;
@protocol HXFloatButtonViewDelegate <NSObject>
@required
/// 点击了悬浮按钮
- (void)didClickFloatButtonView:(HXFloatButtonView *)floatView;

@end

@interface HXFloatButtonView : UIView

@property(nonatomic, weak) id<HXFloatButtonViewDelegate> delegate;

@property(nonatomic, strong) UIImage *contentImage;

@property(nonatomic, assign) CGFloat marginBottom;  //拖动时底部边距

@end
