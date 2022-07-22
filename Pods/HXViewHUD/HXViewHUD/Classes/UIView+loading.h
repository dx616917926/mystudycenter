//
//  UIView+loading.h
//  HXProgressHUD
//
//  Created by iMac on 16/7/20.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (loading)

/**
 *  功能:显示loading
 */
- (void)showLoading;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示Tost  2s后消失
 */
- (void)showTostWithMessage:(NSString *)message;

/**
 *  功能:显示Tost
 */
- (void)showTostWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示Tost
 */
- (void)showTostWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示Success  2s后消失
 */
- (void)showSuccessWithMessage:(NSString *)message;

/**
 *  功能:显示Success
 */
- (void)showSuccessWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示Success 回调block
 */
- (void)showSuccessWithMessage:(NSString *)message completionBlock:(void(^)(void))completionBlock;

/**
 *  功能:显示Success
 */
- (void)showSuccessWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second;


/**
 *  功能:显示Error  2s后消失
 */
- (void)showErrorWithMessage:(NSString *)message;

/**
 *  功能:显示Error
 */
- (void)showErrorWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示Error
 */
- (void)showErrorWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示Error 回调block
 */
- (void)showErrorWithMessage:(NSString *)message completionBlock:(void(^)(void))completionBlock;

/**
 *  功能:隐藏loading
 */
- (void)hideLoading;

/**
 *  功能:隐藏loading
 */
- (void)hideLoadingOnView:(UIView *)aView;


@end
