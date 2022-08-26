//
//  HXLianXiCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/24.
//

#import "HXLianXiCell.h"

@interface HXLianXiCell ()


@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXLianXiCell

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


#pragma mark - Setter
- (void)setContactModel:(HXContactModel *)contactModel{
    
    _contactModel = contactModel;
    self.titleLabel.text = HXSafeString(contactModel.title);
    self.detailTextLabel.text = HXSafeString(contactModel.value);
    
}



#pragma mark - UI
-(void)createUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.bottomLine];
    
    self.bottomLine.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self, 30)
    .rightSpaceToView(self, 30)
    .heightIs(0.5);
    
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftEqualToView(self.bottomLine).offset(2)
    .widthIs(150)
    .heightIs(22);
    

    
    self.detailLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self.titleLabel, 5)
    .rightEqualToView(self.bottomLine)
    .heightIs(17);
    
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HXFont(16);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    }
    return _titleLabel;;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = HXFont(16);
        _detailLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    }
    return _detailLabel;
}



-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.4);
    }
    return _bottomLine;
}

@end

