//
//  HXSetCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXSetCell.h"

@interface HXSetCell ()

@property(nonatomic,strong) UIImageView *arrowImageView;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXSetCell

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.bottomLine];
    
    self.bottomLine.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self, _kpw(30))
    .rightSpaceToView(self, _kpw(30))
    .heightIs(0.5);
    
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftEqualToView(self.bottomLine).offset(2)
    .rightEqualToView(self.bottomLine).offset(-2)
    .heightIs(22);
    
    self.arrowImageView.sd_layout
    .centerYEqualToView(self)
    .rightEqualToView(self.bottomLine).offset(-5)
    .widthIs(14)
    .heightIs(14);
    
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

-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"rightarrow"];
    }
    return _arrowImageView;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.4);
    }
    return _bottomLine;
}

@end
