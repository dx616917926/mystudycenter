//
//  HXPainterViewController.m
//  eplatform-painter
//
//  Created by  MAC on 15/7/21.
//  Copyright (c) 2015年 华夏大地教育. All rights reserved.
//

#import "HXPainterViewController.h"
#import "ACEDrawingView.h"
#import "TestColorViewController.h"
#import "HXPenPickerController.h"
#import "HXPopoverView.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface HXPainterViewController ()<UIScrollViewDelegate,ACEDrawingViewDelegate,TestColorViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HXPenPickerDelegate,PopoverViewDelegate,UIPopoverControllerDelegate>
{
    UIColor* defaultColor;
    CGFloat  defaultLineWidth;
    HXPopoverView * pv;
    HXPenPickerController * penView;
    TestColorViewController * colorView;
    BOOL popViewIsShowing;
    UIPopoverController * popover;
    UIAlertView *alert;
}

@property (nonatomic, strong) ACEDrawingView *drawingView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation HXPainterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.toolBarTopLayoutConstraint.constant = kStatusBarHeight;
    
    //设置topView背景
    UIImage *backgroundImage;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        backgroundImage = [UIImage imageNamed:@"painter_bg"];
    }else
    {
        backgroundImage = [UIImage imageNamed:@"painter_bg2"];
    }
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    [_myTopBgView setBackgroundColor:backgroundColor];
    
    //取色
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    NSData * objColor = [userdefault objectForKey:@"color"];
    UIImage * image = _colorButton.imageView.image;
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_colorButton setImage:image forState:UIControlStateNormal];
    if (!objColor) {
        defaultColor = [UIColor redColor]; //默认颜色是红色
    }else
    {
        defaultColor = [NSKeyedUnarchiver unarchiveObjectWithData:objColor];
    }
    [_colorButton setTintColor:defaultColor];
    
    //取线条粗细
    CGFloat size = [userdefault integerForKey:@"LineSize"];
    if (size != 0) {
        defaultLineWidth = size;
    }else
    {
        defaultLineWidth = 10;  //1--30
    }

    [_myScrollView setScrollEnabled:NO];
    [_myScrollView setDelegate:nil];
    _myScrollView.minimumZoomScale = 0.5;
    _myScrollView.maximumZoomScale = 1.5;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self sc_setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (popViewIsShowing) {
        
        if (isPad) {
            [popover dismissPopoverAnimated:NO];
        }else
        {
            [pv dismiss:NO];
        }
    }
    
    if (alert) {
        [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //禁用全局滑动手势
    HXNavigationController * navigationController = (HXNavigationController *)self.navigationController;
    navigationController.enableInnerInactiveGesture = NO;
    
    if (!self.containerView) {
        
        //设置画板
        CGRect rect = _myScrollView.bounds;
        
        self.drawingView = [[ACEDrawingView alloc]initWithFrame:rect];
        self.drawingView.delegate = self;
        self.drawingView.lineColor = defaultColor;
        self.drawingView.lineWidth = defaultLineWidth;
        
        rect.size.width *= 2;
        rect.size.height *= 2;
        
        self.containerView = [[UIView alloc]initWithFrame:rect];
        //self.containerView.backgroundColor = [UIColor redColor];
        
        [self.containerView addSubview:self.drawingView];
        self.drawingView.center = self.containerView.center;
        [_myScrollView addSubview:self.containerView];
        
        _myScrollView.contentSize = self.containerView.bounds.size;

        //居中
        [_myScrollView setContentOffset:CGPointMake(self.drawingView.frame.origin.x, self.drawingView.frame.origin.y) animated:NO];
        
        [self updateButtonStatus];
        
        //设置scrollView背景
        UIImage *backgroundImage2 = [UIImage imageNamed:@"painter_clear"];
        UIColor *backgroundColor2 = [UIColor colorWithPatternImage:backgroundImage2];
        [_myBackgroundView setBackgroundColor:backgroundColor2];
    }
    
    if (_selectImageType>=1) {
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = _selectImageType-1;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        _selectImageType = 0;
        
        if (isPad && imagePickerController.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            CGRect frame = _selectImageButton.bounds;
            
            popViewIsShowing = YES;
            popover = [[UIPopoverController alloc]initWithContentViewController:imagePickerController];
            popover.delegate = self;
            [popover presentPopoverFromRect:frame inView:self.selectImageButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else
        {
            [self presentViewController:imagePickerController animated:YES completion:^{
                //
            }];
        }

    }
}

- (void)setShowHintLabel:(BOOL)showHintLabel
{
    if (showHintLabel) {
        
        if (self.hintString) {
            UIView * hintView = [[UIView alloc]init];
            hintView.frame = CGRectMake((kScreenWidth-230)/2, kScreenHeight-70, 230, 46);
            hintView.backgroundColor = [UIColor colorWithRed:1 green:0.19 blue:0.24 alpha:1];
            hintView.tag = 501;
            UILabel * hintLabel = [[UILabel alloc]initWithFrame:hintView.bounds];
            hintLabel.textAlignment = UITextAlignmentCenter;
            hintLabel.text = self.hintString;
            hintLabel.textColor = [UIColor whiteColor];
            hintLabel.font = [UIFont systemFontOfSize:18];
            [hintView addSubview:hintLabel];
            hintView.layer.cornerRadius = 10;
            hintView.layer.masksToBounds = YES;
            hintView.alpha = 0;
            [self.view addSubview:hintView];
            
            [UIView animateWithDuration:0.5 animations:^{
                //
                hintView.alpha = 1;
            }];
            
            [UIView animateWithDuration:0.5 delay:5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                //
                
                hintView.alpha = 0;
                
            } completion:^(BOOL finished) {
                //
                
                [hintView removeFromSuperview];
            }];
        }
        
    }else
    {
        UIView * hintView = [self.view viewWithTag:501];
        if (hintView) {
            [hintView removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollViewDelegate


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    //NSLog(@"scrollViewDidZoom");
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    //NSLog(@"scrollViewWillBeginZooming");
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //NSLog(@"scrollViewDidEndZooming  atScale:%lf",scale);
}


#pragma mark - ACEDrawingViewDelegate

- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool
{
    
}
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool
{
    [self updateButtonStatus];
}

#pragma mark - TestColorViewDelegate

-(void)colorViewDidSelectColor:(UIColor *)color
{
    if (color) {
        self.drawingView.lineColor = color;
        
        [self.colorButton setTintColor:color];
    }
}

-(void)colorViewWillDismiss:(UIColor *)color
{
    
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    
    NSData *objColor = [NSKeyedArchiver archivedDataWithRootObject:color];
    
    [userdefault setObject:objColor forKey:@"color"];
    
    [userdefault synchronize];
}

#pragma mark - HXPenPickerDelegate

-(void)penPickerDidChangeLineWidth:(CGFloat)lineWidth
{
    if (lineWidth >= 1) {
        self.drawingView.lineWidth = lineWidth;
    }
}

-(void)penPickerDidSelectPenType:(PenType)type
{
    switch (type) {
        case PenType_Pen:
            self.drawingView.drawTool = ACEDrawingToolTypePen;
            [_penButton setImage:[UIImage imageNamed:@"painter_pen"] forState:UIControlStateNormal];
            break;
            
        case PenType_Rect:
            self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
            [_penButton setImage:[UIImage imageNamed:@"painter_rect"] forState:UIControlStateNormal];
            break;
            
        case PenType_Circle:
            self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
            [_penButton setImage:[UIImage imageNamed:@"painter_cir"] forState:UIControlStateNormal];
            break;
            
        case PenType_Line:
            self.drawingView.drawTool = ACEDrawingToolTypeLine;
            [_penButton setImage:[UIImage imageNamed:@"painter_line"] forState:UIControlStateNormal];
            break;
            
        case PenType_Text:
            self.drawingView.drawTool = ACEDrawingToolTypeMultilineText;
            [_penButton setImage:[UIImage imageNamed:@"painter_text"] forState:UIControlStateNormal];
            break;
    }
    
    popViewIsShowing = NO;
    
    [pv dismiss:NO];
}

#pragma mark - UIImagePickerControllerDelegate

//选完图片要绘图
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [[UIApplication sharedApplication] setStatusBarStyle:kStatusBarStyle];
    
    popViewIsShowing = NO;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
    
    [self.drawingView loadImage:image];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{    
    popViewIsShowing = NO;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
    
    BOOL enable = self.drawingView.userInteractionEnabled;
    //self.penButton.enabled = self.drawingView.userInteractionEnabled;
    //self.colorButton.enabled = self.drawingView.userInteractionEnabled;
    
    self.penButton.alpha = enable?1.0:0.6;
    self.colorButton.alpha = enable?1.0:0.6;
    self.handButton.alpha = enable?0.6:1.0;
}

/**
 *  @author wangxuanao, 15-07-21 11:07:16
 *
 *  返回按钮事件
 *
 *  @param sender
 */
- (IBAction)goBackButtonAction:(id)sender {
    
    if (self.delegate) {
        [self.delegate didFinishDrawingWithImage:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  @author wangxuanao, 15-07-21 14:07:14
 *
 *  选择照片按钮事件
 *
 *  @param sender
 */
- (IBAction)selectImageButtonAction:(id)sender {
    
    UIButton * btn = sender;
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    if (isPad) {
        CGRect frame = btn.bounds;
        popViewIsShowing = YES;
        popover = [[UIPopoverController alloc]initWithContentViewController:imagePickerController];
        popover.delegate = self;
        [popover presentPopoverFromRect:frame inView:self.selectImageButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else
    {
        [self presentViewController:imagePickerController animated:YES completion:^{
            //
        }];
    }
    
}

/**
 *  @author wangxuanao, 15-07-21 14:07:30
 *
 *  选择画笔
 *
 *  @param sender
 */
- (IBAction)penButtonAction:(id)sender {
    
    if (popViewIsShowing) {
        return;
    }
    popViewIsShowing = YES;
    
    [self.drawingView setUserInteractionEnabled:YES];
    [_myScrollView setScrollEnabled:NO];
    [_myScrollView setDelegate:nil];
    [self updateButtonStatus];
    
    UIButton * btn = sender;

    //弹出选择画笔选择框
    if (isPad) {
        if (!penView) {
            penView = [[HXPenPickerController alloc]initWithNibName:@"HXPenPickerController" bundle:nil];
            penView.delegate = self;
        }
        popover = [[UIPopoverController alloc] initWithContentViewController:penView];
        popover.popoverContentSize = CGSizeMake(315 , 160);
        CGRect frame = btn.bounds;
        //计算位置并弹出信息框
        popover.delegate = self;
        [popover presentPopoverFromRect:frame inView:self.penButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else
    {
        if (!penView) {
            penView = [[HXPenPickerController alloc]initWithNibName:@"HXPenPickerController2" bundle:nil];
            penView.delegate = self;
        }
        CGPoint point = [self.view convertPoint:btn.center fromView:btn.superview];
        point.y += btn.bounds.size.height/2-5;
        pv = [HXPopoverView showPopoverAtPoint:point
                                                    inView:self.view
                                           withContentView:penView.view
                                                  delegate:self];
    }
}

/**
 *  @author wangxuanao, 15-07-21 14:07:46
 *
 *  选择颜色
 *
 *  @param sender
 */
- (IBAction)colorButtonAction:(id)sender {
    
    if (popViewIsShowing) {
        return;
    }
    popViewIsShowing = YES;
    
    [self.drawingView setUserInteractionEnabled:YES];
    [_myScrollView setScrollEnabled:NO];
    [_myScrollView setDelegate:nil];
    [self updateButtonStatus];
    
    UIButton * btn = sender;
    
    if (!colorView) {
        colorView = [[TestColorViewController alloc]init];
        colorView.delegate = self;
        colorView.defaultColor = self.drawingView.lineColor;
    }
    
    if (isPad) {
        //弹出颜色选择框
        popover = [[UIPopoverController alloc] initWithContentViewController:colorView];
        popover.popoverContentSize = CGSizeMake(320 , 460);
        
        CGRect frame = btn.bounds;
        popover.delegate = self;
        //计算位置并弹出信息框
        [popover presentPopoverFromRect:frame inView:self.colorButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else{
        //弹出颜色选择框
        CGPoint point = [self.view convertPoint:btn.center fromView:btn.superview];
        point.y += btn.bounds.size.height/2-5;
        pv = [HXPopoverView showPopoverAtPoint:point
                                      inView:self.view
                             withContentView:colorView.view
                                    delegate:self];
        
    }
}

/**
 *  @author wangxuanao, 15-08-17 17:08:15
 *
 *  PopoverViewDelegate
 *
 *  @param popoverView
 */
- (void)popoverViewDidDismiss:(HXPopoverView *)popoverView
{
    popViewIsShowing = NO;
    
    if (popoverView.contentView == colorView.view) {
        
        NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
        
        NSData *objColor = [NSKeyedArchiver archivedDataWithRootObject:self.drawingView.lineColor];
        
        [userdefault setObject:objColor forKey:@"color"];
        
        [userdefault synchronize];
        
    }
}

/**
 *  @author wangxuanao, 15-07-21 14:07:54
 *
 *  小手
 *
 *  @param sender
 */
- (IBAction)handButtonAction:(id)sender {
    
    [self.drawingView setUserInteractionEnabled:!self.drawingView.userInteractionEnabled];
    
    [_myScrollView setScrollEnabled:!self.drawingView.userInteractionEnabled
     ];
    
    [_myScrollView setDelegate:!self.drawingView.userInteractionEnabled?self:nil];
    
    [self updateButtonStatus];
}

/**
 *  @author wangxuanao, 15-07-21 15:07:03
 *
 *  撤销按钮
 *
 *  @param sender
 */
- (IBAction)undoButtonAction:(id)sender {
    
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

/**
 *  @author wangxuanao, 15-07-21 15:07:18
 *
 *  重做按钮
 *
 *  @param sender
 */
- (IBAction)redoButtonAction:(id)sender {
    
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

/**
 *  @author wangxuanao, 15-07-21 15:07:34
 *
 *  清空按钮
 *
 *  @param sender
 */
- (IBAction)clearButtonAction:(id)sender {
    
    [self.drawingView clear];
    [self updateButtonStatus];
}

/**
 *  @author wangxuanao, 15-07-21 15:07:43
 *
 *  完成按钮
 *
 *  @param sender
 */
- (IBAction)completeButtonAction:(id)sender {
    
    _completeButton.enabled = NO;
    
    UIImage * image = self.drawingView.image;
    
    if (self.delegate) {
        
        //也保存到相册比较好
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
        
        [self.delegate didFinishDrawingWithImage:image];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [self saveImageToPhotos:image];
    }
}

//保存图片到相册
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败!";
    }else{
        msg = @"保存图片成功!";
    }
    alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
        
    _completeButton.enabled = YES;
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    popViewIsShowing = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
