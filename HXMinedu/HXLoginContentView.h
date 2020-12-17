//
//  HXLoginContentView.h
//  HXMinedu
//
//  Created by Mac on 2020/12/17.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HXLoginTypeUserName,
    HXLoginTypePhone,
} HXLoginType;

NS_ASSUME_NONNULL_BEGIN

@protocol HXLoginContentViewDeleagte <NSObject>

- (void)loginButtonClick;
- (void)forgetPassworkButtonClick;
- (void)privacyPolicyButtonClick;

@end

@interface HXLoginContentView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property(nonatomic, weak) id<HXLoginContentViewDeleagte> delegate;

@property(nonatomic, assign, readonly) HXLoginType loginType;

@end

NS_ASSUME_NONNULL_END
