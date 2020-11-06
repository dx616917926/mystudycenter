//
//  HXIntroViewManager.h
//  HXMinedu
//
//  Created by Mac on 2020/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *引导页消失的时候发送的通知
 */
FOUNDATION_EXPORT NSString * const HXIntroViewDismissNotification;

@interface HXIntroViewManager : NSObject

+ (instancetype)sharedInstance;

/*
 *直接显示引导页面
 */
- (void)showIntroViewInView:(UIView *)view;

/*
 *如果是第一次启动显示引导页面
 */
- (void)checkAndShowIntroViewInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
