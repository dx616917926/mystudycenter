//
//  HXCustomToastView.h
//  HXMinedu
//
//  Created by mac on 2021/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXCustomToastView : UIView

-(void)showConfirmToastHideAfter:(NSTimeInterval)second;

-(void)showRejectToastHideAfter:(NSTimeInterval)second;

@end

NS_ASSUME_NONNULL_END
