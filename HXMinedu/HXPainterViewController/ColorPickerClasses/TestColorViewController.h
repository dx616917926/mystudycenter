//
//  TestColorViewController.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/14/13.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"
#import "RSColorFunctions.h"

@class RSBrightnessSlider;
@class RSOpacitySlider;
@class TestColorViewController;


@protocol TestColorViewDelegate<NSObject>

@optional

/**
 *  @author wangxuanao, 15-07-21 18:07:49
 *
 *  选取任意一个颜色都会调用
 *
 *  @param color
 */
-(void)colorViewDidSelectColor:(UIColor *)color;

/**
 *  @author wangxuanao, 15-07-21 18:07:10
 *
 *  取色完毕，消失的时候调用
 */
-(void)colorViewWillDismiss:(UIColor *)color;

@end


@interface TestColorViewController : UIViewController <RSColorPickerViewDelegate> {
    BOOL isSmallSize;
}

@property (nonatomic,weak)id<TestColorViewDelegate> delegate;

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) RSOpacitySlider *opacitySlider;
@property (nonatomic) UIView *colorPatch;
@property (nonatomic) UIColor * defaultColor;

@end
