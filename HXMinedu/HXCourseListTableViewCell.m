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
    
    //
    [self.startStudyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startStudyButton setBackgroundColor:kNavigationBarColor];
    self.startStudyButton.layer.cornerRadius = 14;
    self.startStudyButton.layer.shadowColor = kNavigationBarColor.CGColor;
    self.startStudyButton.layer.shadowOffset = CGSizeMake(0,0);
    self.startStudyButton.layer.shadowOpacity = 1;
    self.startStudyButton.layer.shadowRadius = 4;
    
    //
    self.mImageView.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXCourseModel *)model {
    
    _model = model;
    
    self.mTitleLabel.text = model.courseName;
    
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:[model.imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"course_default"]];
}

- (IBAction)startStudyButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStudyButtonInCell:)]) {
        [self.delegate didClickStudyButtonInCell:self];
    }
}


@end
