//
//  HXHomePageGuideCell.m
//  HXMinedu
//
//  Created by mac on 2021/5/20.
//

#import "HXHomePageGuideCell.h"

@interface HXHomePageGuideCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *guideTitleLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIImageView *tipImageView;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UIImageView *guideImageView;
@property(nonatomic,strong) UIButton *checkBtn;
@end

@implementation HXHomePageGuideCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

-(void)setCount:(NSInteger)count{
    _count = count;
    self.guideImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"homepageguide_%ld",(long)count]];
    NSArray *titleArray = @[@"成考指南",@"自考指南",@"国开指南",@"网教指南",@"职业资格精品课程"];
    NSArray *tipArray = @[@"成考的同学注意啦",@"自考的同学注意啦",@"国开的同学注意啦",@"网教的同学注意啦",@"职业资格报考攻略"];
    self.guideTitleLabel.text = titleArray[count-1];
    self.tipLabel.text = tipArray[count-1];
    [self.tipImageView updateLayout];
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:self.tipImageView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame =self.tipImageView.bounds;
    maskLayer.path = bPath.CGPath;
    self.tipImageView.layer.mask = maskLayer;
    if (count == 3) {
        self.tipImageView.backgroundColor = COLOR_WITH_ALPHA(0xFAF2DD, 1);
        self.tipLabel.textColor = COLOR_WITH_ALPHA(0xFAC639, 1);
        self.checkBtn.backgroundColor = COLOR_WITH_ALPHA(0xFAC639, 1);
    }else if (count == 5) {
        self.tipImageView.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
        self.tipLabel.textColor = COLOR_WITH_ALPHA(0x4DC656, 1);
        self.checkBtn.backgroundColor = COLOR_WITH_ALPHA(0x4DC656, 1);
    }
}

-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.guideTitleLabel];
    [self.bigBackgroundView addSubview:self.guideImageView];
    [self.bigBackgroundView addSubview:self.timeLabel];
    [self.bigBackgroundView addSubview:self.tipImageView];
    [self.tipImageView addSubview:self.tipLabel];
    [self.bigBackgroundView addSubview:self.guideImageView];
    [self.bigBackgroundView addSubview:self.checkBtn];
    
   
    self.shadowBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, 13)
    .topSpaceToView(self.contentView, 5)
    .bottomSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 13);
    self.shadowBackgroundView.layer.cornerRadius = 12;
    
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, 13)
    .topSpaceToView(self.contentView, 5)
    .bottomSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 13);
    self.bigBackgroundView.sd_cornerRadius = @12;
    
    self.guideTitleLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 20)
    .leftSpaceToView(self.bigBackgroundView, 24)
    .heightIs(28);
    [self.guideTitleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth*0.6];
   
    
    self.tipImageView.sd_layout
    .centerYEqualToView(self.guideTitleLabel)
    .leftSpaceToView(self.guideTitleLabel, 10)
    .heightIs(22);
 
    self.tipLabel.sd_layout
    .centerYEqualToView(self.tipImageView)
    .leftSpaceToView(self.tipImageView, 15)
    .heightIs(17);
    [self.tipLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth*0.3];
    
    [self.tipImageView setupAutoWidthWithRightView:self.tipLabel rightMargin:15];
    
    
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.guideTitleLabel, 10)
    .leftEqualToView(self.guideTitleLabel)
    .rightSpaceToView(self.bigBackgroundView, 20)
    .heightIs(17);
    
    self.guideImageView.sd_layout
    .topSpaceToView(self.timeLabel, 6)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .heightIs(207);
    
    self.checkBtn.sd_layout
    .topSpaceToView(self.guideImageView, 10)
    .rightSpaceToView(self.bigBackgroundView, 10)
    .widthIs(108)
    .heightIs(33);
    self.checkBtn.sd_cornerRadius = @6;
    
}

-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
        _shadowBackgroundView.layer.shadowRadius = 10;
        _shadowBackgroundView.layer.shadowOpacity = 1;
    }
    return _shadowBackgroundView;
}

-(UIView *)bigBackgroundView{
    if (!_bigBackgroundView) {
        _bigBackgroundView = [[UIView alloc] init];
        _bigBackgroundView.backgroundColor = [UIColor whiteColor];
        _bigBackgroundView.clipsToBounds = YES;
    }
    return _bigBackgroundView;
}

-(UILabel *)guideTitleLabel{
    if (!_guideTitleLabel) {
        _guideTitleLabel = [[UILabel alloc] init];
        _guideTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _guideTitleLabel.textAlignment = NSTextAlignmentLeft;
        _guideTitleLabel.font = HXBoldFont(20);
        
        
    }
    return _guideTitleLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = COLOR_WITH_ALPHA(0xB2B2B2, 1);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = HXBoldFont(12);
        _timeLabel.text = @"5月20日更新";
    }
    return _timeLabel;
}


-(UIImageView *)tipImageView{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
        _tipImageView.backgroundColor = COLOR_WITH_ALPHA(0xDCEAFF, 1);
    }
    return _tipImageView;;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.font = HXBoldFont(12);
    }
    return _tipLabel;
}


-(UIImageView *)guideImageView{
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] init];
        _guideImageView.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
        _guideImageView.clipsToBounds = YES;
        _guideImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _guideImageView;;
}

-(UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.titleLabel.font = HXFont(16);
        _checkBtn.backgroundColor = COLOR_WITH_ALPHA(0x4da0ff, 1);
        [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_checkBtn setTitle:@"立即查看" forState:UIControlStateNormal];
    }
    return _checkBtn;
}



@end
