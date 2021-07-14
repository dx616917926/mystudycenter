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

-(void)setMajorInfoModel:(HXMajorInfoModel *)majorInfoModel{
    
    _majorInfoModel = majorInfoModel;
    
    self.titleLabel.text = majorInfoModel.isRecent ? @"新专业信息": @"原专业信息";
    self.versionLabel.text = HXSafeString(majorInfoModel.title);
    self.schoolLabel.text = HXSafeString(majorInfoModel.BkSchool);
    self.majorLabel.text = HXSafeString(majorInfoModel.majorName);
}

#pragma mark - UI
-(void)createUI{
    
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.titleLabel];
    [self.bigBackgroundView addSubview:self.versionLabel];
    [self.bigBackgroundView addSubview:self.schoolLabel];
    [self.bigBackgroundView addSubview:self.majorLabel];
    
   
   
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
    .leftEqualToView(self.titleLabel).offset(-7)
    .rightEqualToView(self.titleLabel)
    .heightIs(20);
    
    self.majorLabel.sd_layout
    .topSpaceToView(self.schoolLabel, 8)
    .leftEqualToView(self.schoolLabel)
    .rightEqualToView(self.titleLabel)
    .heightIs(20);


    //设置bigBackgroundView自适应高度
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.majorLabel bottomMargin:16];
    
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 6;
    
    
}

#pragma mark - lazyLoad
-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
//        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
//        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
//        _shadowBackgroundView.layer.shadowRadius = 4;
//        _shadowBackgroundView.layer.shadowOpacity = 1;
    }
    return _shadowBackgroundView;
}

-(UIView *)bigBackgroundView{
    if (!_bigBackgroundView) {
        _bigBackgroundView = [[UIView alloc] init];
        _bigBackgroundView.backgroundColor = [UIColor whiteColor];
        _bigBackgroundView.clipsToBounds = YES;
        _bigBackgroundView.layer.borderWidth = 0.5;
        _bigBackgroundView.layer.borderColor = COLOR_WITH_ALPHA(0x979797, 0.3).CGColor;
    }
    return _bigBackgroundView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXBoldFont(16);
        
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
        
    }
    return _majorLabel;
}


    
@end
