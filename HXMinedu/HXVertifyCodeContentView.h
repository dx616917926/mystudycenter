//
//  HXVertifyCodeContentView.h
//  HXMinedu
//
//  Created by Mac on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HXVertifyCodeContentViewDeleagte <NSObject>

- (void)completeButtonClick;
- (void)sendButtonClick;

@end

@interface HXVertifyCodeContentView : UIView

@property (weak, nonatomic) IBOutlet UILabel *mMobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *mVertifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *mCompleteButton;
@property (weak, nonatomic) IBOutlet UIButton *mSendButton;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *mLineView;

@property(nonatomic, weak) id<HXVertifyCodeContentViewDeleagte> delegate;

@end

NS_ASSUME_NONNULL_END
