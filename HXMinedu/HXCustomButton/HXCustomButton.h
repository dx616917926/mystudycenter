//
//  HXCustomButton.h
//  HXMinedu
//
//  Created by Mac on 2021/1/20.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HXButtonEdgeInsetsStyleTop,   // image在上，label在下
    HXButtonEdgeInsetsStyleLeft,  // image在左
    HXButtonEdgeInsetsStyleBottom,// image在下
    HXButtonEdgeInsetsStyleRight, // image在右
} HXButtonEdgeInsetsStyle;

@interface HXCustomButton : UIButton

@property(nonatomic, assign) HXButtonEdgeInsetsStyle style;
@property(nonatomic, assign) CGFloat imageTitleSpace;

@end
