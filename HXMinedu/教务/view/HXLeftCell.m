//
//  HXLeftCell.m
//  HXMinedu
//
//  Created by mac on 2021/3/31.
//

#import "HXLeftCell.h"

@interface HXLeftCell ()

@property(nonatomic,strong) UIImageView *backgroudImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXLeftCell

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


-(void)setModel:(HXVersionModel *)model{
    _model = model;
    self.titleLabel.text = HXSafeString(model.versionName);
    self.titleLabel.textColor = model.isSelected?[UIColor whiteColor]:COLOR_WITH_ALPHA(0x2C2C2E, 1);
    self.backgroudImageView.image = model.isSelected?[UIImage imageNamed:@"navbar_bg"]:nil;
    self.bottomLine.hidden = model.isSelected;
}

-(void)createUI{
    [self addSubview:self.backgroudImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.bottomLine];
    
    self.backgroudImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

    
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, 20)
    .autoHeightRatio(0);
    
    self.bottomLine.sd_layout
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, 20)
    .bottomEqualToView(self)
    .heightIs(1);
    
}

#pragma mark - lazyLoad
-(UIImageView *)backgroudImageView{
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc] init];
        _backgroudImageView.backgroundColor = [UIColor whiteColor];
        _backgroudImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroudImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXFont(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0xDFDFDF, 1);
    }
    return _bottomLine;
}
    

@end
