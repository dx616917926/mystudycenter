//
//  HXCoursewareCell.m
//  HXMinedu
//
//  Created by Mac on 2020/12/24.
//

#import "HXCoursewareCell.h"

@implementation HXCoursewareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mBackgroundView.layer.cornerRadius = 8;
    self.mBackgroundView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    self.mBackgroundView.layer.shadowOffset = CGSizeMake(0,0);
    self.mBackgroundView.layer.shadowOpacity = 1;
    self.mBackgroundView.layer.shadowRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
