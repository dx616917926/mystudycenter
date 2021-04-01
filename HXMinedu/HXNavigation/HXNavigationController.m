//
//  HXNavigationController.m
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import "HXNavigationController.h"

@interface HXNavigationController ()  <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@property (nonatomic, assign) UIViewController *lastViewController;

@end

@implementation HXNavigationController

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.enableInnerInactiveGesture = YES;
        
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        self.enableInnerInactiveGesture = YES;
        
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.enableInnerInactiveGesture = YES;
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    
    self.interactivePopGestureRecognizer.delegate = self;
    super.delegate = self;
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
    self.panRecognizer.delegate = self;
    
}

#pragma mark - UINavigationDelegate

// forbid User VC to be NavigationController's delegate
- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
}

#pragma mark - Push & Pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self configureNavigationBarForViewController:viewController];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    return [super popViewControllerAnimated:animated];
    
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    
    [viewController.view bringSubviewToFront:viewController.sc_navigationBar];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (navigationController.viewControllers.count == 1) {
            self.interactivePopGestureRecognizer.delegate = nil;
            self.delegate = nil;
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.interactivePopGestureRecognizer.enabled = self.enableInnerInactiveGesture;
        }
    }
    
    if (self.enableInnerInactiveGesture) {
        BOOL hasPanGesture = NO;
        BOOL hasEdgePanGesture = NO;
        for (UIGestureRecognizer *recognizer in [viewController.view gestureRecognizers]) {
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                    hasEdgePanGesture = YES;
                } else {
                    hasPanGesture = YES;
                }
            }
        }
        if (!hasPanGesture && (navigationController.viewControllers.count > 1)) {
            [viewController.view addGestureRecognizer:self.panRecognizer];
        }
    }
    
    viewController.navigationController.delegate = self;
    
}

// Animation
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPop && navigationController.viewControllers.count >= 1 && self.enableInnerInactiveGesture) {
        return [[HXNavigationPopAnimation alloc] init];
    } else if (operation == UINavigationControllerOperationPush) {
        HXNavigationPushAnimation *animation = [[HXNavigationPushAnimation alloc] init];
        return animation;
    } else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[HXNavigationPopAnimation class]] && self.enableInnerInactiveGesture) {
        return self.interactivePopTransition;
    }
    else {
        return nil;
    }
}


- (void)handlePanRecognizer:(UIPanGestureRecognizer*)recognizer {
    
    if (!self.enableInnerInactiveGesture) {
        return;
    }
    
    static CGFloat startLocationX = 0;
    
    CGPoint location = [recognizer locationInView:self.view];
    
    CGFloat progress = (location.x - startLocationX) / kScreenWidth;
    progress = MIN(1.0, MAX(0.0, progress));
    
    //    NSLog(@"progress:   %.2f", progress);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startLocationX = location.x;
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGFloat velocityX = [recognizer velocityInView:self.view].x;
        if (progress > 0.3 || velocityX > 300) {
            self.interactivePopTransition.completionSpeed = 0.8;
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            self.interactivePopTransition.completionSpeed = 0.8;
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if (self.openTableEditGesture && ([touch.view.superview isKindOfClass:[UITableViewCell class]] || [touch.view.superview.superview isKindOfClass:[UITableViewCell class]])) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (!self.enableInnerInactiveGesture) {
        return NO;
    }
    
    if (gestureRecognizer == self.panRecognizer)
    {
        CGPoint translation = [self.panRecognizer translationInView:self.view];
        return translation.x > 0;
    }
    return YES;
}

#pragma mark - Private Helper

- (void)configureNavigationBarForViewController:(UIViewController *)viewController {
    
    [[self class] createNavigationBarForViewController:viewController];
    
}

+ (void)createNavigationBarForViewController:(UIViewController *)viewController {
    
    if (!viewController.sc_navigationBar && !viewController.sc_navigationBarHidden) {
        viewController.sc_navigationBar = [[HXNavigationBar alloc] init];
        [viewController.view addSubview:viewController.sc_navigationBar];
        [viewController.sc_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewController.view);
            make.leading.trailing.equalTo(viewController.view);
            make.height.mas_equalTo(kNavigationBarHeight);
        }];
    }
    
}

- (BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return [self.viewControllers lastObject];
}
@end
