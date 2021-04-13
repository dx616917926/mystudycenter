//
//  HXMyNewsCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/12.
//

#import "HXMyNewsCell.h"

@interface HXMyNewsCell ()

@property(nonatomic,strong) UIImageView *newsIcon;
@property(nonatomic,strong) UILabel *newsTitleLabel;
@property(nonatomic,strong) UILabel *newsDetailLabel;
@property(nonatomic,strong) UILabel *newsTimeLabel;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXMyNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    
}

-(UIImageView *)newsIcon{
    if (!_newsIcon) {
        _newsIcon = [[UIImageView alloc] init];
        _newsIcon.image = [UIImage imageNamed:@"systemnotification_icon"];
    }
    return _newsIcon;
}

-(UILabel *)newsTitleLabel{
    if (!_newsTitleLabel) {
        _newsTitleLabel = [[UILabel alloc] init];
        _newsTitleLabel.textAlignment = NSTextAlignmentLeft;
        _newsTitleLabel.font = HXFont(16);
        _newsTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _newsTitleLabel.text = @"系统通知";
    }
    return _newsTitleLabel;
}

-(UILabel *)newsDetailLabel{
    if (!_newsDetailLabel) {
        _newsDetailLabel = [[UILabel alloc] init];
        _newsDetailLabel.textAlignment = NSTextAlignmentLeft;
        _newsDetailLabel.font = HXFont(12);
        _newsDetailLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
    }
    return _newsDetailLabel;
}

-(UILabel *)newsTimeLabel{
    if (!_newsTimeLabel) {
        _newsTimeLabel = [[UILabel alloc] init];
        _newsTimeLabel.textAlignment = NSTextAlignmentRight;
        _newsTimeLabel.font = HXFont(12);
        _newsTimeLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
    }
    return _newsTimeLabel;
}

@end
