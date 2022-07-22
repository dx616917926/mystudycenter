//
//  HXPlaceholderTextView.h
//  zikaoks
//
//  Created by Mac on 2021/12/10.
//  Copyright © 2021 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface HXPlaceholderTextView : UITextView

@property (nonatomic, strong) IBInspectable NSString * placeholderText;
@property (nonatomic, strong) IBInspectable UIColor  * placeholderTextColor;   // Default lightGray

@end

NS_ASSUME_NONNULL_END
