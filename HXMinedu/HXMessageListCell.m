//
//  HXMessageListCell.m
//  HXMinedu
//
//  Created by Mac on 2020/12/29.
//

#import "HXMessageListCell.h"

@implementation HXMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.showCustomSeparator = YES;
    
    self.mStatusLabel.layer.cornerRadius = 4;
    self.mStatusLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXMessageObject *)model
{
    _model = model;
    
    self.mTitleLabel.text = model.MessageTitle;
    self.mTimeLabel.text = model.sendTime;
    
    if ([model.statusID isEqual:@"1"]) {
        //已读
        self.mStatusLabel.text = @"已读";
        self.mStatusLabel.backgroundColor = [UIColor colorWithRed:0.04 green:0.77 blue:0.55 alpha:1.00];
    }else
    {
        self.mStatusLabel.text = @"未读";
        self.mStatusLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.29 blue:0.29 alpha:1.00];
    }
}

@end
