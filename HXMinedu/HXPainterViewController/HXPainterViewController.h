//
//  HXPainterViewController.h
//  eplatform-painter
//
//  Created by  MAC on 15/7/21.
//  Copyright (c) 2015年 华夏大地教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXPainterViewControllerDelegate <NSObject>

//当你画完之后，点击提交按钮会返回的。
-(void)didFinishDrawingWithImage:(UIImage *)image;

@end


typedef NS_ENUM(NSUInteger, SelectImageType) {
    SelectImageType_PhotoLibrary = 1,
    SelectImageType_Camera = 2
};

#define HXPainterViewVersion   1.0.0

@interface HXPainterViewController : UIViewController

@property (weak, nonatomic) id<HXPainterViewControllerDelegate>delegate;

@property (assign,nonatomic) SelectImageType selectImageType;//0、1

@property (assign,nonatomic) BOOL showHintLabel; //配合hintString，在屏幕底部展示

@property (copy,nonatomic) NSString * hintString;

@property (weak, nonatomic) IBOutlet UIView *myTopBgView;

@property (weak, nonatomic) IBOutlet UIView *myBackgroundView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarTopLayoutConstraint;


@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
- (IBAction)goBackButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
- (IBAction)selectImageButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *penButton;
- (IBAction)penButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *colorButton;
- (IBAction)colorButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *handButton;
- (IBAction)handButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *undoButton;
- (IBAction)undoButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *redoButton;
- (IBAction)redoButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
- (IBAction)clearButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
- (IBAction)completeButtonAction:(id)sender;



@end
