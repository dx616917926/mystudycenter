//
//  HXExamRecordCell.m
//  HXMinedu
//
//  Created by Mac on 2020/12/25.
//

#import "HXExamRecordCell.h"

@implementation HXExamRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mBackgroundView.layer.cornerRadius = 8;
    self.mBackgroundView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    self.mBackgroundView.layer.shadowOffset = CGSizeMake(0,0);
    self.mBackgroundView.layer.shadowOpacity = 1;
    self.mBackgroundView.layer.shadowRadius = 4;
    
    //
    [self.mContinueExamButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [self.mContinueExamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.mContinueExamButton setBackgroundColor:[UIColor whiteColor]];
    self.mContinueExamButton.layer.cornerRadius = 15;
    self.mContinueExamButton.layer.borderColor = kNavigationBarColor.CGColor;
    self.mContinueExamButton.layer.borderWidth = 1;
    
    //
    [self.mLookExamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mLookExamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.mLookExamButton setBackgroundColor:kNavigationBarColor];
    self.mLookExamButton.layer.cornerRadius = 15;
    self.mLookExamButton.layer.shadowColor = kNavigationBarColor.CGColor;
    self.mLookExamButton.layer.shadowOffset = CGSizeMake(0,0);
    self.mLookExamButton.layer.shadowOpacity = 1;
    self.mLookExamButton.layer.shadowRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)continueExamButtonPressed:(id)sender {
    
    [self.delegate didClickContinueExamButtonInCell:self];
}

- (IBAction)lookExamButtonPressed:(id)sender {
    
    [self.delegate didClickLookExamButtonInCell:self];
}

@end
