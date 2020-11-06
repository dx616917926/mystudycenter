//
//  Rotation.h
//  ClassBook
//
//  Created by Wangxuanao on 14-3-1.
//  Copyright (c) 2014年 AlphaStudio. All rights reserved.
//

#ifndef ClassBook_Rotation_h
#define ClassBook_Rotation_h

// UINavigationController
@implementation UINavigationController (Rotation_IOS6)

- (BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
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

// UITabBarController
@implementation UITabBarController (Rotation_IOS6)

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end

#endif
