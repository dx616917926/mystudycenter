//
//  HXRegistFormCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/3.
//

#import "HXRegistFormCell.h"

@interface HXRegistFormCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIImageView *formImageView;
@property(nonatomic,strong) UILabel *versionLabel;
@property(nonatomic,strong) UILabel *kaoqiLabel;
@property(nonatomic,strong) UILabel *majorLabel;
@property (nonatomic, strong) UIButton *downLoadBtn;//报名表单下载按钮
@property (nonatomic, strong) UIButton *downLoadSignTreatyBtn;//报名协议下载按钮

@end

@implementation HXRegistFormCell

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

#pragma mark - 预览大图
-(void)downLoad:(UIButton *)sender{
    NSInteger tag = sender.tag;
    NSString *downUrl = (tag==6000?self.registFormModel.url:self.registFormModel.SignTreatyUrl);
    if (self.delegate && [self.delegate respondsToSelector:@selector(registFormCell:downLoadUrl:)]) {
        [self.delegate registFormCell:self downLoadUrl:downUrl];
    }
}

-(void)setRegistFormModel:(HXRegistFormModel *)registFormModel{
    _registFormModel = registFormModel;
    self.versionLabel.text = HXSafeString(registFormModel.versionName);
    if (![HXCommonUtil isNull:registFormModel.enterDate]&&![HXCommonUtil isNull:registFormModel.educationName]) {
        self.kaoqiLabel.text = [NSString stringWithFormat:@"%@/%@",registFormModel.enterDate,registFormModel.educationName];
    }else if([HXCommonUtil isNull:registFormModel.educationName]){
        self.kaoqiLabel.text = registFormModel.enterDate;
    }
    
    if (![HXCommonUtil isNull:registFormModel.bkSchool]&&![HXCommonUtil isNull:registFormModel.majorName]) {
        self.majorLabel.text = [NSString stringWithFormat:@"%@-%@",registFormModel.bkSchool,registFormModel.majorName];
    }else if([HXCommonUtil isNull:registFormModel.bkSchool]){
        self.majorLabel.text = registFormModel.majorName;
    }
    
    self.downLoadSignTreatyBtn.hidden = (registFormModel.isSignTreaty==1?NO:YES);
}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.versionLabel];
    [self.bigBackgroundView addSubview:self.formImageView];
    [self.bigBackgroundView addSubview:self.kaoqiLabel];
    [self.bigBackgroundView addSubview:self.majorLabel];
    [self.bigBackgroundView addSubview:self.downLoadBtn];
    [self.bigBackgroundView addSubview:self.downLoadSignTreatyBtn];
   
    
    self.shadowBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(8, 16, 8, 16));
    self.shadowBackgroundView.layer.cornerRadius = 10;
    
    self.bigBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(8, 16, 8, 16));
    self.bigBackgroundView.sd_cornerRadius = @10;
    
    self.formImageView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 30)
    .rightSpaceToView(self.bigBackgroundView, 38)
    .widthIs(56)
    .heightIs(42);
    
    self.downLoadBtn.sd_layout
    .bottomSpaceToView(self.bigBackgroundView, 15)
    .rightSpaceToView(self.bigBackgroundView, 24)
    .widthIs(84)
    .heightIs(30);
    self.downLoadBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.downLoadBtn.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor,(id)COLOR_WITH_ALPHA(0x45EFCF, 1).CGColor];
    gradientLayer.colors = colorArr;
    [self.downLoadBtn.layer insertSublayer:gradientLayer below:self.downLoadBtn.titleLabel.layer];
    
    
    self.downLoadSignTreatyBtn.sd_layout
    .centerYEqualToView(self.downLoadBtn)
    .rightSpaceToView(self.downLoadBtn, 24)
    .widthIs(84)
    .heightIs(30);
    self.downLoadSignTreatyBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.bounds = self.downLoadSignTreatyBtn.bounds;
    gradientLayer2.startPoint = CGPointMake(0, 0.5);
    gradientLayer2.endPoint = CGPointMake(1, 0.5);
    gradientLayer2.anchorPoint = CGPointMake(0, 0);
    gradientLayer2.colors = colorArr;
    [self.downLoadSignTreatyBtn.layer insertSublayer:gradientLayer2 below:self.downLoadSignTreatyBtn.titleLabel.layer];
    
    self.versionLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 20)
    .leftSpaceToView(self.bigBackgroundView, 28)
    .rightSpaceToView(self.downLoadBtn, 10)
    .heightIs(25);
    
    self.kaoqiLabel.sd_layout
    .topSpaceToView(self.versionLabel, 6)
    .leftEqualToView(self.versionLabel)
    .rightEqualToView(self.versionLabel)
    .heightIs(17);
    
    self.majorLabel.sd_layout
    .topSpaceToView(self.kaoqiLabel, 10)
    .leftEqualToView(self.versionLabel)
    .rightEqualToView(self.versionLabel)
    .autoHeightRatio(0);
    
}


-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.2).CGColor;
        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
        _shadowBackgroundView.layer.shadowRadius = 6;
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

-(UIImageView *)formImageView{
    if (!_formImageView) {
        _formImageView = [[UIImageView alloc] init];
        _formImageView.image = [UIImage imageNamed:@"ziliao_icon"];
    }
    return _formImageView;
}

-(UIButton *)downLoadBtn{
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downLoadBtn.tag = 6000;
        _downLoadBtn.titleLabel.font = HXBoldFont(12);
        [_downLoadBtn setTitle:@"报名表单" forState:UIControlStateNormal];
        [_downLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downLoadBtn.backgroundColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        [_downLoadBtn addTarget:self action:@selector(downLoad:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}

-(UIButton *)downLoadSignTreatyBtn{
    if (!_downLoadSignTreatyBtn) {
        _downLoadSignTreatyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downLoadSignTreatyBtn.tag = 6001;
        _downLoadSignTreatyBtn.hidden = YES;
        _downLoadSignTreatyBtn.titleLabel.font = HXBoldFont(12);
        [_downLoadSignTreatyBtn setTitle:@"报名协议" forState:UIControlStateNormal];
        [_downLoadSignTreatyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downLoadSignTreatyBtn.backgroundColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        [_downLoadSignTreatyBtn addTarget:self action:@selector(downLoad:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadSignTreatyBtn;
}


-(UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textAlignment = NSTextAlignmentLeft;
        _versionLabel.font = HXBoldFont(18);
        _versionLabel.textColor = COLOR_WITH_ALPHA(0x000000, 1);
        
    }
    return _versionLabel;
}

-(UILabel *)kaoqiLabel{
    if (!_kaoqiLabel) {
        _kaoqiLabel = [[UILabel alloc] init];
        _kaoqiLabel.textAlignment = NSTextAlignmentLeft;
        _kaoqiLabel.font = HXFont(14);
        _kaoqiLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        
    }
    return _kaoqiLabel;
}
-(UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [[UILabel alloc] init];
        _majorLabel.textAlignment = NSTextAlignmentLeft;
        _majorLabel.font = HXFont(14);
        _majorLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _majorLabel.numberOfLines = 0;
    }
    return _majorLabel;
}
@end

