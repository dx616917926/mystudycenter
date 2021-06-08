//
//  HXToastSuggestionView.h
//  HXMinedu
//
//  Created by mac on 2021/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXToastSuggestionView : UIView

-(void)showConfirmToastWithCallBack:(void(^)(NSString *cotent))callback;

-(void)showRejecttoastWithCallBack:(void(^)(NSString *cotent))callback;

@end

NS_ASSUME_NONNULL_END
