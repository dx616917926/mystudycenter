//
//  HXResetTableViewCell.m
//  HXMinedu
//
//  Created by Mac on 2020/11/3.
//

#import "HXResetTableViewCell.h"

@implementation HXResetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.mTextField setTintColor:kNavigationBarColor];
    [self.mLineView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
