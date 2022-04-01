//
//  UIView+loading.m
//  HXProgressHUD
//
//  Created by iMac on 16/7/20.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import "UIView+loading.h"
#import "HXProgressHUD.h"

@implementation UIView (loading)


- (void)showLoading
{
    [self showLoadingWithMessage:nil];
}

- (void)showLoadingWithMessage:(NSString *)message
{
    [self showLoadingWithMessage:message hideAfter:0];
}

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second
{
    [self showLoadingWithMessage:message onView:self hideAfter:second];
}

- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second
{
    
    HXProgressHUD *hud = [HXProgressHUD HUDForView:aView];
    
    if (!hud) {
        hud = [HXProgressHUD showHUDAddedTo:aView animated:YES];
    }
    
    if (message) {
        hud.label.text = message;
//        hud.label.font = [UIFont systemFontOfSize:12];
    }
    
    hud.mode = HXProgressHUDModeIndeterminate;
    
    if (second > 0) {
        [hud hideAnimated:YES afterDelay:second];
    }
}

- (void)showTostWithMessage:(NSString *)message
{
    [self showTostWithMessage:message onView:self hideAfter:2];
}

- (void)showTostWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second
{
    [self showTostWithMessage:message onView:self hideAfter:second];
}

- (void)showTostWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second
{
    [self showHUDWithMessage:message onView:aView hideAfter:second hudMode:HXProgressHUDModeText completionBlock:nil];
}

- (void)showSuccessWithMessage:(NSString *)message
{
    [self showSuccessWithMessage:message onView:self hideAfter:2];
}

- (void)showSuccessWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second
{
    [self showSuccessWithMessage:message onView:self hideAfter:second];
}

- (void)showSuccessWithMessage:(NSString *)message completionBlock:(void(^)(void))completionBlock
{
    [self showHUDWithMessage:message onView:self hideAfter:2 hudMode:HXProgressHUDModeSuccess completionBlock:completionBlock];
}

- (void)showSuccessWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second
{
    [self showHUDWithMessage:message onView:aView hideAfter:second hudMode:HXProgressHUDModeSuccess completionBlock:nil];
}

- (void)showErrorWithMessage:(NSString *)message
{
    [self showErrorWithMessage:message onView:self hideAfter:2];
}

- (void)showErrorWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second
{
    [self showErrorWithMessage:message onView:self hideAfter:second];
}

- (void)showErrorWithMessage:(NSString *)message completionBlock:(void(^)(void))completionBlock
{
    [self showHUDWithMessage:message onView:self hideAfter:2 hudMode:HXProgressHUDModeError completionBlock:completionBlock];
}

- (void)showErrorWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second
{
    [self showHUDWithMessage:message onView:aView hideAfter:second hudMode:HXProgressHUDModeError completionBlock:nil];
}

- (void)showHUDWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second hudMode:(HXProgressHUDMode)mode completionBlock:(HXProgressHUDCompletionBlock)completionBlock
{
    HXProgressHUD *hud = [HXProgressHUD HUDForView:aView];
    
    if (!hud) {
        hud = [HXProgressHUD showHUDAddedTo:aView animated:YES];
    }
    
    hud.completionBlock = completionBlock;
    
    if (message) {
        hud.label.text = message;
        //hud.label.font = [UIFont systemFontOfSize:12];
        hud.mode = mode;
        
        if (mode != HXProgressHUDModeText) {
            hud.minSize = CGSizeMake(100.f, 100.f);
        }
    }
    
    if (second > 0) {
        [hud hideAnimated:YES afterDelay:second];
    }
}

- (void)hideLoading
{
    [self hideLoadingOnView:self];
}

- (void)hideLoadingOnView:(UIView *)aView
{
    [HXProgressHUD hideAllHUDsForView:aView animated:YES];
}

@end
