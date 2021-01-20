//
//  HXExamListCell.m
//  HXMinedu
//
//  Created by Mac on 2021/1/12.
//

#import "HXExamListCell.h"

@implementation HXExamListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mBackgroundView.layer.cornerRadius = 8;
    self.mBackgroundView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    self.mBackgroundView.layer.shadowOffset = CGSizeMake(0,0);
    self.mBackgroundView.layer.shadowOpacity = 1;
    self.mBackgroundView.layer.shadowRadius = 4;
    
}

-(void)setEntity:(HXExam *)entity
{
    _entity = entity;
    
    self.mTitleLabel.text = entity.examTitle;
    self.mLastExamNumLabel.text = entity.leftExamNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
