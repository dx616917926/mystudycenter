//
//  HXSelectJiGouCell.m
//  HXMinedu
//
//  Created by mac on 2022/3/29.
//

#import "HXSelectJiGouCell.h"

@interface HXSelectJiGouCell ()
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIView *bgView;

@end

@implementation HXSelectJiGouCell

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

-(void)setDomainNameModel:(HXDomainNameModel *)domainNameModel{
    _domainNameModel = domainNameModel;
    self.nameLabel.text = domainNameModel.OzName;
    self.bgView.backgroundColor = domainNameModel.isSelected?COLOR_WITH_ALPHA(0xF5F5F5, 1):COLOR_WITH_ALPHA(0xFFFFFF, 1);
}

#pragma mark - UI
-(void)createUI{
    
    [self addSubview:self.bgView];
    [self addSubview:self.nameLabel];
    
    self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.nameLabel.sd_layout
    .centerYEqualToView(self.bgView)
    .leftEqualToView(self.bgView).offset(30)
    .rightEqualToView(self.bgView)
    .heightIs(20);
    
    
}
#pragma mark - lazyLoad

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = HXFont(16);
        _nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _nameLabel.numberOfLines=1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
    }
    return _bgView;
}

@end
