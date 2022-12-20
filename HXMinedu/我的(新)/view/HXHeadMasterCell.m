//
//  HXHeadMasterCell.m
//  HXMinedu
//
//  Created by mac on 2021/5/25.
//

#import "HXHeadMasterCell.h"
#import "SDWebImage.h"

@interface HXHeadMasterCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIImageView *headerImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *jiGouQRCodeImageView;
@property(nonatomic,strong)  UIView *markContainerView;
@property(nonatomic,strong) UIButton *phoneBtn;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) UIButton *emailBtn;
@property(nonatomic,strong) UILabel *emailLabel;

@end

@implementation HXHeadMasterCell

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
-(void)tapImageView:(UITapGestureRecognizer *)ges{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headMasterCell:tapJiGouQRCodeImageView:)]) {
        [self.delegate headMasterCell:self tapJiGouQRCodeImageView:(UIImageView *)ges.view];
    }
}

-(void)setHeadMasterModel:(HXHeadMasterModel *)headMasterModel{
    _headMasterModel = headMasterModel;
    self.nameLabel.text = HXSafeString(headMasterModel.realName);
    self.phoneLabel.text = [HXCommonUtil isNull:headMasterModel.cellPhone]?@"暂无":[self handlePhoneNum:HXSafeString(headMasterModel.cellPhone)];
    self.emailLabel.text = [HXCommonUtil isNull:headMasterModel.email]?@"暂无":HXSafeString(headMasterModel.email);
    [self.jiGouQRCodeImageView sd_setImageWithURL:HXSafeURL(headMasterModel.imageUrl) placeholderImage:nil options:SDWebImageRefreshCached];
    
    [self.markContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    if (headMasterModel.markList.count == 0) {
        self.markContainerView.sd_layout.heightIs(20);
    }else{
        NSArray *backgroundColorArray = @[COLOR_WITH_ALPHA(0xFAF2DD, 1),COLOR_WITH_ALPHA(0xDCEAFF, 1),COLOR_WITH_ALPHA(0xC8FACB, 1),COLOR_WITH_ALPHA(0xFAF2DD, 1),COLOR_WITH_ALPHA(0xDCEAFF, 1),COLOR_WITH_ALPHA(0xC8FACB, 1),COLOR_WITH_ALPHA(0xFAF2DD, 1),COLOR_WITH_ALPHA(0xDCEAFF, 1),COLOR_WITH_ALPHA(0xC8FACB, 1)];
        NSArray *titleColorArray = @[COLOR_WITH_ALPHA(0xFAC639, 1),COLOR_WITH_ALPHA(0x5699FF, 1),COLOR_WITH_ALPHA(0x4DC656, 1),COLOR_WITH_ALPHA(0xFAC639, 1),COLOR_WITH_ALPHA(0x5699FF, 1),COLOR_WITH_ALPHA(0x4DC656, 1),COLOR_WITH_ALPHA(0xFAC639, 1),COLOR_WITH_ALPHA(0x5699FF, 1),COLOR_WITH_ALPHA(0x4DC656, 1)];
        for (int i= 0; i<headMasterModel.markList.count; i++) {
            NSString *title = [headMasterModel.markList[i] objectForKey:@"versionName"];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [self.markContainerView addSubview:btn];
            //将数据关联按钮
            btn.titleLabel.font = HXFont(10);
            [btn setBackgroundColor:backgroundColorArray[i]];
            [btn setTitle:HXSafeString(title) forState:UIControlStateNormal];
            [btn setTitleColor:titleColorArray[i] forState:UIControlStateNormal];
            btn.sd_layout.heightIs(17);
            btn.sd_cornerRadius = @2;
        }
        [self.markContainerView setupAutoWidthFlowItems:self.markContainerView.subviews withPerRowItemsCount:2 verticalMargin:5 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    }
    
}

#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.headerImageView];
    [self.bigBackgroundView addSubview:self.nameLabel];
    [self.bigBackgroundView addSubview:self.jiGouQRCodeImageView];
    [self.bigBackgroundView addSubview:self.markContainerView];
    [self.bigBackgroundView addSubview:self.phoneBtn];
    [self.bigBackgroundView addSubview:self.phoneLabel];
    [self.bigBackgroundView addSubview:self.emailBtn];
    [self.bigBackgroundView addSubview:self.emailLabel];
   

    self.bigBackgroundView.sd_layout
    .topSpaceToView(self.contentView, 5)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10);
    
    self.bigBackgroundView.sd_cornerRadius = @10;
    
    self.headerImageView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 20)
    .leftSpaceToView(self.bigBackgroundView, 30)
    .widthIs(50)
    .heightEqualToWidth();
    self.headerImageView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    
    self.jiGouQRCodeImageView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 30)
    .rightSpaceToView(self.bigBackgroundView, 30)
    .widthIs(80)
    .heightEqualToWidth();
    
    self.nameLabel.sd_layout
    .centerYEqualToView(self.headerImageView)
    .leftSpaceToView(self.headerImageView, 24)
    .rightSpaceToView(self.bigBackgroundView, 20)
    .heightIs(22);
    
    
    self.markContainerView.sd_layout
    .topSpaceToView(self.nameLabel, 6)
    .leftEqualToView(self.nameLabel)
    .rightSpaceToView(self.jiGouQRCodeImageView, 10);

    
    self.phoneBtn.sd_layout
    .topSpaceToView(self.markContainerView, 10)
    .leftSpaceToView(self.bigBackgroundView, 44)
    .widthIs(70)
    .heightIs(24);
    
    self.phoneBtn.imageView.sd_layout
    .centerYEqualToView(self.phoneBtn)
    .leftEqualToView(self.phoneBtn)
    .widthIs(24)
    .heightEqualToWidth();
    
    self.phoneBtn.titleLabel.sd_layout
    .centerYEqualToView(self.phoneBtn)
    .leftSpaceToView(self.phoneBtn.imageView, 12)
    .rightEqualToView(self.phoneBtn)
    .heightIs(20);
    
    self.phoneLabel.sd_layout
    .centerYEqualToView(self.phoneBtn)
    .leftSpaceToView(self.phoneBtn, 16)
    .rightSpaceToView(self.jiGouQRCodeImageView, 20)
    .heightIs(20);
    
    self.emailBtn.sd_layout
    .topSpaceToView(self.phoneBtn, 16)
    .leftEqualToView(self.phoneBtn)
    .widthRatioToView(self.phoneBtn, 1)
    .heightRatioToView(self.phoneBtn, 1);
    
    self.emailBtn.imageView.sd_layout
    .centerYEqualToView(self.emailBtn)
    .leftEqualToView(self.emailBtn)
    .widthIs(24)
    .heightEqualToWidth();
    
    self.emailBtn.titleLabel.sd_layout
    .centerYEqualToView(self.emailBtn)
    .leftSpaceToView(self.emailBtn.imageView, 12)
    .rightEqualToView(self.emailBtn)
    .heightIs(20);
    
    self.emailLabel.sd_layout
    .topEqualToView(self.emailBtn).offset(5)
    .leftEqualToView(self.phoneLabel)
    .rightSpaceToView(self.bigBackgroundView, 30)
    .autoHeightRatio(0);
    [self.emailLabel setMaxNumberOfLinesToShow:2];
    
    //设置bigBackgroundView自适应高度
    [self.bigBackgroundView setupAutoHeightWithBottomViewsArray:@[self.emailBtn,self.emailLabel] bottomMargin:20];
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 10;
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:10];
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

-(UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:@"defaultheader"];
    }
    return _headerImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = HXBoldFont(16);
       
    }
    return _nameLabel;
}


-(UIImageView *)jiGouQRCodeImageView{
    if (!_jiGouQRCodeImageView) {
        _jiGouQRCodeImageView = [[UIImageView alloc] init];
        _jiGouQRCodeImageView.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
        _jiGouQRCodeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [_jiGouQRCodeImageView addGestureRecognizer:tap];
    }
    return _jiGouQRCodeImageView;
}

-(UIView *)markContainerView{
    if (!_markContainerView) {
        _markContainerView = [[UIView alloc] init];
        _markContainerView.backgroundColor = [UIColor clearColor];
        _markContainerView.clipsToBounds = YES;
    }
    return _markContainerView;
}



-(UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.titleLabel.font = HXFont(14);
        [_phoneBtn setImage:[UIImage imageNamed:@"phone_icon"] forState:UIControlStateNormal];
        [_phoneBtn setTitle:@"电话" forState:UIControlStateNormal];
        [_phoneBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
    }
    return _phoneBtn;
}

-(UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.font = HXFont(12);
    }
    return _phoneLabel;
}

-(UIButton *)emailBtn{
    if (!_emailBtn) {
        _emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _emailBtn.titleLabel.font = HXFont(14);
        [_emailBtn setImage:[UIImage imageNamed:@"email_icon"] forState:UIControlStateNormal];
        [_emailBtn setTitle:@"邮箱" forState:UIControlStateNormal];
        [_emailBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
    }
    return _emailBtn;
}

-(UILabel *)emailLabel{
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _emailLabel.textAlignment = NSTextAlignmentLeft;
        _emailLabel.font = HXFont(12);
        _emailLabel.numberOfLines = 0;
        
    }
    return _emailLabel;
}


-(NSString *)handlePhoneNum:(NSString *)phoneNum{
    if (phoneNum.length == 11) {
        NSString *str1 = [phoneNum substringWithRange:NSMakeRange(0, 3)];
        NSString *str2 = [phoneNum substringWithRange:NSMakeRange(3, 4)];
        NSString *str3 = [phoneNum substringWithRange:NSMakeRange(7, 4)];
        return [NSString stringWithFormat:@"%@-%@-%@",str1,str2,str3];
    }
    return phoneNum;
}
@end
