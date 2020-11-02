//
//  HXPenPickerController.h
//  eplatform-painter
//
//  Created by  MAC on 15/7/22.
//  Copyright © 2015年 华夏大地教育. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PenType) {
    PenType_Pen = 1,
    PenType_Rect,
    PenType_Circle,
    PenType_Line,
    PenType_Text
};

@protocol HXPenPickerDelegate <NSObject>

@optional

-(void)penPickerDidChangeLineWidth:(CGFloat)lineWidth;

-(void)penPickerDidSelectPenType:(PenType)type;

@end


@interface HXPenPickerController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UILabel *optionsValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *optionsSlider;
- (IBAction)toolButtonsAction:(id)sender;

@property(nonatomic,weak)id<HXPenPickerDelegate>delegate;

@end
