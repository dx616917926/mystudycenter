//
//  HXCourseListTableViewCell.m
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import "HXCourseListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HXCourseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mBackgroundView.layer.cornerRadius = 8;
    self.mBackgroundView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    self.mBackgroundView.layer.shadowOffset = CGSizeMake(0,0);
    self.mBackgroundView.layer.shadowOpacity = 1;
    self.mBackgroundView.layer.shadowRadius = 4;
    
    self.modelView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXCourseModel *)model {
    
    _model = model;
    
    self.mTitleLabel.text = model.courseName;
    
    self.modelView.listModel = model.modules;
}

- (IBAction)reportButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReportButtonInCell:)]) {
        [self.delegate didClickReportButtonInCell:self];
    }
}

/// 点击了按钮
- (void)didClickButtonWithModel:(HXModelItem *)modelItem
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStudyButtonWithModel:)]) {
        [self.delegate didClickStudyButtonWithModel:modelItem];
    }
}

@end
