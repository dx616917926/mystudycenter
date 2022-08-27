//
//  HXTouSuPhoneCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/25.
//

#import "HXTouSuPhoneCell.h"

@interface HXTouSuPhoneCell ()


@property(nonatomic,strong) UIView *bigView;
@property(nonatomic,strong) UIButton *phoneBtn;

@end

@implementation HXTouSuPhoneCell

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
    
    [self.phoneBtn setTitle:HXSafeString(contactModel.value) forState:UIControlStateNormal];
}

#pragma mark - UI
-(void)createUI{
    [self addSubview:self.bigView];
    [self addSubview:self.phoneBtn];
  
    self.bigView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.phoneBtn.sd_layout
    .centerXEqualToView(self.bigView)
    .centerYEqualToView(self.bigView)
    .heightIs(20);
    
    self.phoneBtn.imageView.sd_layout
    .centerYEqualToView(self.phoneBtn)
    .leftEqualToView(self.phoneBtn)
    .widthIs(15)
    .heightEqualToWidth();
    
    self.phoneBtn.titleLabel.sd_layout
    .centerYEqualToView(self.phoneBtn)
    .leftSpaceToView(self.phoneBtn.imageView, 5)
    .heightIs(20);
    [self.phoneBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    [self.phoneBtn setupAutoWidthWithRightView:self.phoneBtn.titleLabel rightMargin:5];
    
}


-(UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = UIColor.whiteColor;
    }
    return _bigView;
}

-(UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.titleLabel.font = HXFont(14);
        _phoneBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_phoneBtn setTitleColor:COLOR_WITH_ALPHA(0x5595FE, 1) forState:UIControlStateNormal];
        [_phoneBtn setImage:[UIImage imageNamed:@"tousuphone_icon"] forState:UIControlStateNormal];
        
    }
    return _phoneBtn;
}

@end


