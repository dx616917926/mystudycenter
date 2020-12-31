//
//  HXExamCell.m
//  HXMinedu
//
//  Created by Mac on 2020/12/24.
//

#import "HXExamCell.h"

@implementation HXExamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mBackgroundView.layer.cornerRadius = 8;
    self.mBackgroundView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    self.mBackgroundView.layer.shadowOffset = CGSizeMake(0,0);
    self.mBackgroundView.layer.shadowOpacity = 1;
    self.mBackgroundView.layer.shadowRadius = 4;
    
    self.mStartExamButton.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:1.0].CGColor;
    self.mStartExamButton.layer.cornerRadius = 15;
    self.mStartExamButton.layer.shadowColor = [UIColor colorWithRed:75/255.0 green:164/255.0 blue:254/255.0 alpha:0.5].CGColor;
    self.mStartExamButton.layer.shadowOffset = CGSizeMake(0,0);
    self.mStartExamButton.layer.shadowOpacity = 1;
    self.mStartExamButton.layer.shadowRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)startExamButtonPressed:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStartExamButtonInCell:)]) {
        [self.delegate didClickStartExamButtonInCell:self];
    }
}


@end
