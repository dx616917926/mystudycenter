//
//  HXMajorInfoCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/4.
//

#import "HXMajorInfoCell.h"
@interface HXMajorInfoCell ()

@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *versionLabel;
@property(nonatomic,strong) UILabel *schoolLabel;
@property(nonatomic,strong) UILabel *majorLabel;
@property(nonatomic,strong) UILabel *remarksLabel;
@property(nonatomic,strong) UILabel *remarksContentLabel;

@end

@implementation HXMajorInfoCell

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
#pragma mark - UI
-(void)createUI{
    
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.titleLabel];
    [self.bigBackgroundView addSubview:self.versionLabel];
    [self.bigBackgroundView addSubview:self.schoolLabel];
    [self.bigBackgroundView addSubview:self.majorLabel];
    [self.bigBackgroundView addSubview:self.remarksLabel];
    [self.bigBackgroundView addSubview:self.remarksContentLabel];
   
   
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, _kpw(10))
    .topSpaceToView(self.contentView, 8)
    .rightSpaceToView(self.contentView, _kpw(10));
    self.bigBackgroundView.sd_cornerRadius = @6;
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 20)
    .leftSpaceToView(self.bigBackgroundView, 24)
    .rightSpaceToView(self.bigBackgroundView, 24)
    .heightIs(20);
    
    self.versionLabel.sd_layout
    .topSpaceToView(self.titleLabel, 8)
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .heightIs(20);
    
    self.schoolLabel.sd_layout
    .topSpaceToView(self.versionLabel, 8)
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .heightIs(20);
    
    self.majorLabel.sd_layout
    .topSpaceToView(self.schoolLabel, 8)
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .heightIs(20);

    
    self.remarksLabel.sd_layout
    .topSpaceToView(self.majorLabel, 8)
    .leftEqualToView(self.titleLabel)
    .heightIs(17);
    [self.remarksLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.remarksContentLabel.sd_layout
    .topSpaceToView(self.majorLabel, 8)
    .leftSpaceToView(self.remarksLabel, 10)
    .rightSpaceToView(self.bigBackgroundView, 24)
    .autoHeightRatio(0);
    [self.remarksContentLabel setMaxNumberOfLinesToShow:2];
    
    //设置bigBackgroundView自适应高度
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.remarksContentLabel bottomMargin:16];
    
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 6;
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:8];
}

#pragma mark - lazyLoad
-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
        _shadowBackgroundView.layer.shadowRadius = 4;
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

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXBoldFont(16);
        _titleLabel.text = @"原专业信息";
    }
    return _titleLabel;
}

-(UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textAlignment = NSTextAlignmentLeft;
        _versionLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _versionLabel.font = HXFont(14);
        _versionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _versionLabel.text = @"成人高考-2023-专升本-函授";
    }
    return _versionLabel;
}

-(UILabel *)schoolLabel{
    if (!_schoolLabel) {
        _schoolLabel = [[UILabel alloc] init];
        _schoolLabel.textAlignment = NSTextAlignmentLeft;
        _schoolLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _schoolLabel.font = HXFont(14);
        _schoolLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _schoolLabel.text = @"【湖南省】 吉首大学";
    }
    return _schoolLabel;
}

-(UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [[UILabel alloc] init];
        _majorLabel.textAlignment = NSTextAlignmentLeft;
        _majorLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _majorLabel.font = HXFont(14);
        _majorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _majorLabel.text = @"【经济管理类】 020101经济学";
    }
    return _majorLabel;
}

-(UILabel *)remarksLabel{
    if (!_remarksLabel) {
        _remarksLabel = [[UILabel alloc] init];
        _remarksLabel.textAlignment = NSTextAlignmentLeft;
        _remarksLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _remarksLabel.font = HXFont(14);
        _remarksLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _remarksLabel.text = @"异动备注：";
    }
    return _remarksLabel;
}
-(UILabel *)remarksContentLabel{
    if (!_remarksContentLabel) {
        _remarksContentLabel = [[UILabel alloc] init];
        _remarksContentLabel.textAlignment = NSTextAlignmentLeft;
        _remarksContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _remarksContentLabel.font = HXFont(14);
        _remarksContentLabel.numberOfLines = 0;
//        _remarksContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _remarksContentLabel.text = @"备注备注备注备注备注备注备注备注备注s我的；来了我的礼物到了的师傅的师傅我";
    }
    return _remarksContentLabel;
}
    
@end
