//
//  XHImageViewer.h
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华 
//  本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHImageViewer;

typedef void (^WillDismissWithSelectedViewBlock)(XHImageViewer *imageViewer, UIImageView *selectedView);

typedef void (^DidDismissWithSelectedViewBlock)(XHImageViewer *imageViewer, UIImageView *selectedView);

typedef void (^DidChangeToImageViewBlock)(XHImageViewer *imageViewer, UIImageView *selectedView);

@protocol XHImageViewerDelegate <NSObject>

@optional
- (void)imageViewer:(XHImageViewer *)imageViewer
    willDismissWithSelectedView:(UIImageView *)selectedView;
- (void)imageViewer:(XHImageViewer *)imageViewer
    didDismissWithSelectedView:(UIImageView *)selectedView;
- (void)imageViewer:(XHImageViewer *)imageViewer
    didChangeToImageView:(UIImageView *)selectedView;
- (void)imageViewer:(XHImageViewer *)imageViewer
    didClickMenuBtn:(UIButton *)menuBtn;

- (UIView *)customTopToolBarOfImageViewer:(XHImageViewer *)imageViewer;
- (UIView *)customBottomToolBarOfImageViewer:(XHImageViewer *)imageViewer;
@end

@interface XHImageViewer : UIView

@property(nonatomic, weak) id<XHImageViewerDelegate> delegate;

@property(nonatomic, assign) CGFloat backgroundScale;

@property(nonatomic, assign) BOOL disableTouchDismiss;

@property(nonatomic, assign) BOOL disablePanDismiss;

@property(nonatomic, assign) BOOL showPageNumOnBottom; //在底部显示页码

@property(nonatomic, assign) BOOL showSaveImageToLibraryBtn; //在左下部显示保存图片到本地相册按钮

@property(nonatomic, assign) BOOL showMenuBtn; //在右下角显示菜单按钮

- (void)showWithImageViews:(NSArray *)views
              selectedView:(UIImageView *)selectedView;

- (id)initWithImageViewerWillDismissWithSelectedViewBlock:(WillDismissWithSelectedViewBlock)willDismissWithSelectedViewBlock
                          didDismissWithSelectedViewBlock:(DidDismissWithSelectedViewBlock)didDismissWithSelectedViewBlock
                                didChangeToImageViewBlock:(DidChangeToImageViewBlock)didChangeToImageViewBlock;

- (void)dismiss;

@end
