//
//  HXVertifyCodeContentView.m
//  HXMinedu
//
//  Created by Mac on 2021/1/5.
//

#import "HXVertifyCodeContentView.h"

@implementation HXVertifyCodeContentView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mMobileLabel.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1];
    self.mTimeLabel.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1];
    //重新发送按钮
    [self.mSendButton setTitleColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] forState:UIControlStateNormal];
    [self.mSendButton setTitleColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] forState:UIControlStateDisabled];
    [self.mSendButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    //分割线
    [self.mLineView setBackgroundColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.8]];
    
    //完成
    self.mCompleteButton.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:1.0].CGColor;
    self.mCompleteButton.layer.cornerRadius = 20;
    self.mCompleteButton.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:0.5].CGColor;
    self.mCompleteButton.layer.shadowOffset = CGSizeMake(0,0);
    self.mCompleteButton.layer.shadowOpacity = 1;
    self.mCompleteButton.layer.shadowRadius = 4;
}

- (IBAction)completeButtonClickAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeButtonClick)]) {
        [self.delegate completeButtonClick];
    }
}

- (IBAction)sendButtonClickAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendButtonClick)]) {
        [self.delegate sendButtonClick];
    }
}

@end
