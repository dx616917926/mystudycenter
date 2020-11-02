//
//  XHImageViewer.m
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华 
//  本人QQ群（142557668）. All rights reserved.
//

#import "XHImageViewer.h"
#import "XHViewState.h"
#import "XHZoomingImageView.h"

#define kXHImageViewerBaseTopToolBarTag 100
#define kXHImageViewerBaseBottomToolBarTag 200
#define kXHImageViewerBaseBottomSaveImageViewTag 300
#define kXHImageViewerBaseBottomPageNumViewTag 400
#define kXHImageViewerBaseBottomMenuViewTag 500

@interface XHImageViewer () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSArray *imgViews;

@property(nonatomic, copy) WillDismissWithSelectedViewBlock willDismissWithSelectedViewBlock;
@property(nonatomic, copy) DidDismissWithSelectedViewBlock didDismissWithSelectedViewBlock;
@property(nonatomic, copy) DidChangeToImageViewBlock didChangeToImageViewBlock;

@end

@implementation XHImageViewer

- (void)setImageViewsFromArray:(NSArray *)views {
    NSMutableArray *imgViews = [NSMutableArray array];
    for (id obj in views) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [imgViews addObject:obj];
            
            UIImageView *view = obj;
            
            XHViewState *state = [XHViewState viewStateForView:view];
            [state setStateWithView:view];
            
            view.userInteractionEnabled = NO;
        }
    }
    _imgViews = [imgViews copy];
}

- (void)showWithImageViews:(NSArray *)views
              selectedView:(UIImageView *)selectedView {
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [self setImageViewsFromArray:views];
    
    if (_imgViews.count > 0) {
        if (![selectedView isKindOfClass:[UIImageView class]] ||
            ![_imgViews containsObject:selectedView]) {
            selectedView = _imgViews[0];
        }
        [self showWithSelectedView:selectedView];
    }
}

#pragma mark - Life Cycle

- (void)_setup {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.backgroundScale = 0.95;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGestureRecognizer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithImageViewerWillDismissWithSelectedViewBlock:(WillDismissWithSelectedViewBlock)willDismissWithSelectedViewBlock
                          didDismissWithSelectedViewBlock:(DidDismissWithSelectedViewBlock)didDismissWithSelectedViewBlock
                                didChangeToImageViewBlock:(DidChangeToImageViewBlock)didChangeToImageViewBlock {
    
    if (self = [self initWithFrame:CGRectZero]) {
        self.willDismissWithSelectedViewBlock = willDismissWithSelectedViewBlock;
        self.didDismissWithSelectedViewBlock = didDismissWithSelectedViewBlock;
        self.didChangeToImageViewBlock = didChangeToImageViewBlock;
        
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self _setup];
    }
    return self;
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[backgroundColor colorWithAlphaComponent:0]];
}

- (NSInteger)pageIndex {
    return (_scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5);
}

#pragma mark - Getter Method

- (UIView *)topToolBar {
    UIView *topToolBar = [self viewWithTag:kXHImageViewerBaseTopToolBarTag];
    if (!topToolBar) {
        if ([self.delegate respondsToSelector:@selector(customTopToolBarOfImageViewer:)]) {
            topToolBar = [self.delegate customTopToolBarOfImageViewer:self];
            topToolBar.frame = CGRectMake(0, -CGRectGetHeight(topToolBar.bounds), CGRectGetWidth(topToolBar.bounds), CGRectGetHeight(topToolBar.bounds));
            topToolBar.tag = kXHImageViewerBaseTopToolBarTag;
        }
    }
    
    return topToolBar;
}

- (UIView *)bottomToolBar {
    UIView *bottomToolBar = [self viewWithTag:kXHImageViewerBaseBottomToolBarTag];
    if (!bottomToolBar) {
        if ([self.delegate respondsToSelector:@selector(customBottomToolBarOfImageViewer:)]) {
            bottomToolBar = [self.delegate customBottomToolBarOfImageViewer:self];
            bottomToolBar.tag = kXHImageViewerBaseBottomToolBarTag;
            bottomToolBar.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(bottomToolBar.bounds), CGRectGetHeight(bottomToolBar.bounds));
        }
    }
    return bottomToolBar;
}

- (UIButton *)saveImageViewBtn {
    UIButton *saveImageViewBtn = [self viewWithTag:kXHImageViewerBaseBottomSaveImageViewTag];
    if (!saveImageViewBtn) {
        if (self.showSaveImageToLibraryBtn) {
            saveImageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [saveImageViewBtn setBackgroundImage:[UIImage imageNamed:@"save_icon"] forState:UIControlStateNormal];
            [saveImageViewBtn setBackgroundImage:[UIImage imageNamed:@"save_icon_highlighted"] forState:UIControlStateHighlighted];
            [saveImageViewBtn addTarget:self action:@selector(saveCurrentImageToLibray) forControlEvents:UIControlEventTouchUpInside];
            saveImageViewBtn.tag = kXHImageViewerBaseBottomSaveImageViewTag;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                saveImageViewBtn.frame = CGRectMake(10, CGRectGetHeight(self.bounds)-50, 38 , 38);
            }else
            {
                saveImageViewBtn.frame = CGRectMake(40, CGRectGetHeight(self.bounds)-90, 45 , 45);
            }
            
        }
    }
    return saveImageViewBtn;
}

- (UIButton *)menuImageViewBtn {
    UIButton *menuImageViewBtn = [self viewWithTag:kXHImageViewerBaseBottomMenuViewTag];
    if (!menuImageViewBtn) {
        if (self.showMenuBtn) {
            menuImageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuImageViewBtn setImageEdgeInsets:UIEdgeInsetsMake(6.5,8,6.5,8)];
            [menuImageViewBtn setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
            [menuImageViewBtn setImage:[UIImage imageNamed:@"menu_icon_highlighted"] forState:UIControlStateHighlighted];
            [menuImageViewBtn addTarget:self action:@selector(menuImageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            menuImageViewBtn.tag = kXHImageViewerBaseBottomMenuViewTag;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                menuImageViewBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)-50, CGRectGetHeight(self.bounds)-50, 40 , 34);
            }else
            {
                menuImageViewBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)-90, CGRectGetHeight(self.bounds)-90, 45 , 37);
            }
            
        }
    }
    return menuImageViewBtn;
}

-(UILabel *)currentPageNumLabel {
    UILabel *label = [self viewWithTag:kXHImageViewerBaseBottomPageNumViewTag];
    if (!label) {
        if (self.showPageNumOnBottom) {
            label = [[UILabel alloc] init];
            label.tag = kXHImageViewerBaseBottomPageNumViewTag;
            label.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-50, CGRectGetWidth(self.bounds) , 50);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:19];
        }
    }
    return label;
}

//保存图片到本地相册
-(void)saveCurrentImageToLibray
{
    UIImage * theImage = [[self currentView] image];
    UIImageWriteToSavedPhotosAlbum(theImage,
                                   self,
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:),
                                   NULL);
}

//菜单按钮
-(void)menuImageViewBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(imageViewer:didClickMenuBtn:)]) {
        [self.delegate imageViewer:self didClickMenuBtn:btn];
    }
}
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
        [self showErrorWithMessage:error.localizedDescription];
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
        [self showSuccessWithMessage:@"图片已保存到相册"];
    }
}

#pragma mark - View management

- (UIImageView *)currentView {
    return [_imgViews objectAtIndex:self.pageIndex];
}

- (void)showWithSelectedView:(UIImageView *)selectedView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    const NSInteger currentPage = [_imgViews indexOfObject:selectedView];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView *topToolBar = [self topToolBar];
    if (topToolBar) {
        if (![self.subviews containsObject:topToolBar]) {
            topToolBar.alpha = 0.0;
            [self addSubview:topToolBar];
        }
    }
    
    UIView *bottomToolBar = [self bottomToolBar];
    if (bottomToolBar) {
        if (![self.subviews containsObject:bottomToolBar]) {
            bottomToolBar.alpha = 0.0;
            [self addSubview:bottomToolBar];
        }
    }
    
    UILabel *pageNumLabel = [self currentPageNumLabel];
    if (pageNumLabel) {
        if (![self.subviews containsObject:pageNumLabel]) {
            pageNumLabel.alpha = 0.0;
            pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentPage+1,_imgViews.count];
            [self addSubview:pageNumLabel];
        }
    }
    
    UIButton *saveImageBtn = [self saveImageViewBtn];
    if (saveImageBtn) {
        if (![self.subviews containsObject:saveImageBtn]) {
            saveImageBtn.alpha = 0.0;
            [self addSubview:saveImageBtn];
        }
    }
    
    UIButton *menuImageBtn = [self menuImageViewBtn];
    if (menuImageBtn) {
        if (![self.subviews containsObject:menuImageBtn]) {
            menuImageBtn.alpha = 0.0;
            [self addSubview:menuImageBtn];
        }
    }
    
    CGRect scrollViewFrame = self.bounds;
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor =
        [self.backgroundColor colorWithAlphaComponent:1];
        _scrollView.alpha = 0;
        _scrollView.delegate = self;
    }
    
    [self insertSubview:_scrollView atIndex:0];
    [window addSubview:self];
    
    const CGFloat fullW = window.frame.size.width;
    const CGFloat fullH = window.frame.size.height;
    
    selectedView.frame =
    [window convertRect:selectedView.frame fromView:selectedView.superview];
    [window addSubview:selectedView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.alpha = 1;
                         window.rootViewController.view.transform = CGAffineTransformMakeScale(
                                                                                               self.backgroundScale, self.backgroundScale);
                         
                         selectedView.transform = CGAffineTransformIdentity;
                         
                         CGSize size = (selectedView.image) ? selectedView.image.size
                         : selectedView.frame.size;
                         CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                         CGFloat W = ratio * size.width;
                         CGFloat H = ratio * size.height;
                         selectedView.frame =
                         CGRectMake((fullW - W) / 2, (fullH - H) / 2, W, H);
                     }
                     completion:^(BOOL finished) {
                         _scrollView.contentSize = CGSizeMake(_imgViews.count * fullW, 0);
                         _scrollView.contentOffset = CGPointMake(currentPage * fullW, 0);
                         
                         UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                                            initWithTarget:self
                                                            action:@selector(tappedScrollView:)];
                         [_scrollView addGestureRecognizer:gesture];
                         
                         for (UIImageView *view in _imgViews) {
                             view.transform = CGAffineTransformIdentity;
                             
                             CGSize size = (view.image) ? view.image.size : view.frame.size;
                             CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                             CGFloat W = ratio * size.width;
                             CGFloat H = ratio * size.height;
                             view.frame = CGRectMake((fullW - W) / 2, (fullH - H) / 2, W, H);
                             
                             XHZoomingImageView *tmp = [[XHZoomingImageView alloc]
                                                        initWithFrame:CGRectMake([_imgViews indexOfObject:view] * fullW,
                                                                                 0, fullW, fullH)];
                             tmp.imageView = view;
                             
                             [_scrollView addSubview:tmp];
                         }
                         
                         [self showToolBar];
                     }];
}

- (void)showToolBar {
    [UIView animateWithDuration:0.3 animations:^{
        UIView *topToolBar = [self topToolBar];
        UIView *bottomToolBar = [self bottomToolBar];
        UILabel *pageNumLabel = [self currentPageNumLabel];
        UIButton *saveImageBtn = [self saveImageViewBtn];
        UIButton *menuImageBtn = [self menuImageViewBtn];
        pageNumLabel.alpha = 1.0;
        saveImageBtn.alpha = 1.0;
        menuImageBtn.alpha = 1.0;
        
        topToolBar.frame = CGRectMake(0, 0, CGRectGetWidth(topToolBar.bounds), CGRectGetHeight(topToolBar.bounds));
        topToolBar.alpha = 1.0;
        
        bottomToolBar.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - CGRectGetHeight(bottomToolBar.bounds), CGRectGetWidth(bottomToolBar.bounds), CGRectGetHeight(bottomToolBar.bounds));
        bottomToolBar.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissToolBar {
    [UIView animateWithDuration:0.3 animations:^{
        UIView *topToolBar = [self topToolBar];
        UIView *bottomToolBar = [self bottomToolBar];
        UILabel *pageNumLabel = [self currentPageNumLabel];
        UIButton *saveImageBtn = [self saveImageViewBtn];
        UIButton *menuImageBtn = [self menuImageViewBtn];
        pageNumLabel.alpha = 0.0;
        saveImageBtn.alpha = 0.0;
        menuImageBtn.alpha = 0.0;
        
        topToolBar.frame = CGRectMake(0, -CGRectGetHeight(topToolBar.bounds), CGRectGetWidth(topToolBar.bounds), CGRectGetHeight(topToolBar.bounds));
        topToolBar.alpha = 0.0;
        
        bottomToolBar.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(bottomToolBar.bounds), CGRectGetHeight(bottomToolBar.bounds));
        bottomToolBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)prepareToDismiss {
    UIImageView *currentView = [self currentView];
    
    if ([self.delegate respondsToSelector:@selector(imageViewer:willDismissWithSelectedView:)]) {
        [self.delegate imageViewer:self willDismissWithSelectedView:currentView];
    }
    
    if (self.willDismissWithSelectedViewBlock) {
        self.willDismissWithSelectedViewBlock(self, currentView);
    }
    
    [self dismissToolBar];
    
    for (UIImageView *view in _imgViews) {
        if (view != currentView) {
            XHViewState *state = [XHViewState viewStateForView:view];
            view.transform = CGAffineTransformIdentity;
            view.frame = state.frame;
            view.transform = state.transform;
            [state.superview addSubview:view];
        }
    }
}

- (void)dismissWithAnimate {
    UIImageView *currentView = [self currentView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect rct = currentView.frame;
    currentView.transform = CGAffineTransformIdentity;
    currentView.frame = [window convertRect:rct fromView:currentView.superview];
    [window addSubview:currentView];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.alpha = 0;
                         window.rootViewController.view.transform = CGAffineTransformIdentity;
                         
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.frame =
                         [window convertRect:state.frame fromView:state.superview];
                         currentView.transform = state.transform;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             XHViewState *state = [XHViewState viewStateForView:currentView];
                             currentView.transform = CGAffineTransformIdentity;
                             currentView.frame = state.frame;
                             currentView.transform = state.transform;
                             [state.superview addSubview:currentView];
                             
                             for (UIView *view in _imgViews) {
                                 XHViewState *_state = [XHViewState viewStateForView:view];
                                 view.userInteractionEnabled = _state.userInteratctionEnabled;
                             }
                             [self removeFromSuperview];
                             
                             if ([self.delegate
                                  respondsToSelector:@selector(imageViewer:didDismissWithSelectedView:)]) {
                                 [self.delegate imageViewer:self
                                 didDismissWithSelectedView:currentView];
                             }
                             
                             if (self.didDismissWithSelectedViewBlock) {
                                 self.didDismissWithSelectedViewBlock(self, currentView);
                             }
                         }
                     }];
}

-(void)dismiss
{
    [self prepareToDismiss];
    [self dismissWithAnimate];
}

#pragma mark - Gesture events

- (void)tappedScrollView:(UITapGestureRecognizer *)sender {
    if (self.disableTouchDismiss) {
        return;
    }
    [self prepareToDismiss];
    [self dismissWithAnimate];
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)sender {
    if (self.disablePanDismiss) {
        return;
    }
    static UIImageView *currentView = nil;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        currentView = [self currentView];
        
        UIView *targetView = currentView.superview;
        while (![targetView isKindOfClass:[XHZoomingImageView class]]) {
            targetView = targetView.superview;
        }
        
        if (((XHZoomingImageView *)targetView).isViewing) {
            currentView = nil;
        } else {
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            currentView.frame =
            [window convertRect:currentView.frame fromView:currentView.superview];
            [window addSubview:currentView];
            
            [self prepareToDismiss];
        }
    }
    
    if (currentView) {
        if (sender.state == UIGestureRecognizerStateEnded) {
            if (_scrollView.alpha > 0.5) {
                [self showWithSelectedView:currentView];
            } else {
                [self dismissWithAnimate];
            }
            currentView = nil;
        } else {
            CGPoint p = [sender translationInView:self];
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, p.y);
            transform = CGAffineTransformScale(transform, 1 - fabs(p.y) / 1000,
                                               1 - fabs(p.y) / 1000);
            currentView.transform = transform;
            
            CGFloat r = 1 - fabs(p.y) / 200;
            _scrollView.alpha = MAX(0, MIN(1, r));
        }
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    UILabel * pageNumLabel = [self currentPageNumLabel];
    if (pageNumLabel) {
        pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.pageIndex+1,_imgViews.count];
    }
    
    if ([self.delegate respondsToSelector:@selector(imageViewer:didChangeToImageView:)]) {
        [self.delegate imageViewer:self didChangeToImageView:[self currentView]];
    }
    
    if (self.didChangeToImageViewBlock) {
        self.didChangeToImageViewBlock(self, [self currentView]);
    }
}

@end
