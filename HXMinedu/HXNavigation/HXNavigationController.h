//
//  HXNavigationController.h
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXNavigationController : UINavigationController

@property (nonatomic, assign) BOOL enableInnerInactiveGesture;
@property (nonatomic, assign) BOOL openTableEditGesture;//cell滑动手势冲突

+ (void)createNavigationBarForViewController:(UIViewController *)viewController;

@end
