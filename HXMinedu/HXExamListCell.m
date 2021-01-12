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
