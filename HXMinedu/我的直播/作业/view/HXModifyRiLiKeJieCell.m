//
//  HXModifyRiLiKeJieCell.m
//  HXMinedu
//
//  Created by mac on 2022/9/20.
//

#import "HXModifyRiLiKeJieCell.h"

@interface HXModifyRiLiKeJieCell ()

@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *beginTimeLabel;
@property(nonatomic,strong) UILabel *endimeLabel;

@property(nonatomic,strong) UIView *line1;
@property(nonatomic,strong) UIView *yellowYuanDian;
@property(nonatomic,strong) UIView *line2;
@property(nonatomic,strong) UIView *blueYuanDian;
@property(nonatomic,strong) UIView *line3;


@property(nonatomic,strong) UIView *containerView;
@property(nonatomic,strong) UIButton *zhanKaiButton;
@property(nonatomic,strong) UIView *typeLine;
@property(nonatomic,strong) UILabel *typeLabel;

@property(nonatomic,strong) UILabel *keJieNameLabel;
@property(nonatomic,strong) UILabel *teacherLabel;
@property(nonatomic,strong) UILabel *classRoomLabel;//上课教室：教室001
@property(nonatomic,strong) UILabel *addressLabel;//教室地址：

@property(nonatomic,strong) UIButton *huiFangButton;
@property(nonatomic,strong) UIButton *goLearnButton;
@property(nonatomic,strong) UIButton *zhiBoButton;


@end

@implementation HXModifyRiLiKeJieCell

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

#pragma mark - Seeter
//-(void)setKeJieModel:(HXKeJieModel *)keJieModel{
//
//    _keJieModel = keJieModel;
//    self.huiFangButton.hidden = self.goLearnButton.hidden = self.zhiBoButton.hidden = YES;
//    self.beginTimeLabel.text = HXSafeString(keJieModel.ClassBeginTime);
//    self.teacherLabel.text = [NSString stringWithFormat:@"授课教师：%@",HXSafeString(keJieModel.TeacherName)];
//    self.keJieNameLabel.text = HXSafeString(keJieModel.ClassName);
//    if (keJieModel.LiveType==1) {
//        self.beginTimeLabel.sd_layout.centerYEqualToView(self.bigBackgroundView).offset(-12);
//        self.shiChangLabel.text = [HXSafeString(keJieModel.ClassTimeSpan) stringByAppendingString:@"分钟"];
//    }else{
//        self.beginTimeLabel.sd_layout.centerYEqualToView(self.bigBackgroundView).offset(0);
//        self.shiChangLabel.text = nil;
//    }
//    ///直播状态 0待开始  1直播中  2已结束
//    if (keJieModel.LiveState==1) {
//        self.zhiBoButton.hidden = NO;
//    }else if (keJieModel.LiveState==2) {
//        self.huiFangButton.hidden = NO;
//    }else{
//        self.goLearnButton.hidden =NO;
//    }
//
//}

-(void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    self.line1.hidden = isFirst;
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    self.line3.hidden = isLast;
}


-(void)setKeJieModel:(HXKeJieModel *)keJieModel{
    
    _keJieModel = keJieModel;
    
    self.zhanKaiButton.selected = keJieModel.IsZhanKai;
    
    self.huiFangButton.hidden = self.goLearnButton.hidden = self.zhiBoButton.hidden = YES;
    self.beginTimeLabel.text = HXSafeString(keJieModel.ClassBeginDate);
    self.endimeLabel.text = HXSafeString(keJieModel.ClassEndDate);
    self.keJieNameLabel.text = HXSafeString(keJieModel.ClassName);
    self.teacherLabel.text = [NSString stringWithFormat:@"授课教师：%@",HXSafeString(keJieModel.TeacherName)];
    self.classRoomLabel.text = [NSString stringWithFormat:@"上课教室：%@",HXSafeString(keJieModel.RoomAddr)];
   
    if (keJieModel.LiveType<=2) {
        self.typeLabel.text = @"直播课";
        self.typeLine.backgroundColor = self.typeLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
    }else{
        self.typeLabel.text = @"面授课";
        self.typeLine.backgroundColor = self.typeLabel.textColor = COLOR_WITH_ALPHA(0x51C29B, 1);
    }
    
    
    ///直播状态 0待开始  1直播中  2已结束
    if (keJieModel.LiveState==1) {
        self.zhiBoButton.hidden = NO;
    }else if (keJieModel.LiveState==2) {
        self.huiFangButton.hidden = NO;
    }else{
        self.goLearnButton.hidden =NO;
    }
    
    self.addressLabel.text = nil;
    
    if (keJieModel.IsZhanKai) {
        if (keJieModel.LiveType<=2) {
            self.teacherLabel.sd_layout.topSpaceToView(self.keJieNameLabel, 6).heightIs(17);
            self.classRoomLabel.sd_layout.topSpaceToView(self.teacherLabel, 0).heightIs(0);
            self.addressLabel.sd_layout.topSpaceToView(self.classRoomLabel, 0);
            self.huiFangButton.sd_layout.topSpaceToView(self.addressLabel, 0);
        }else{
            self.addressLabel.text = [NSString stringWithFormat:@"教室地址：%@",HXSafeString(keJieModel.RoomAddr)];
            self.teacherLabel.sd_layout.topSpaceToView(self.keJieNameLabel, 6).heightIs(17);
            self.classRoomLabel.sd_layout.topSpaceToView(self.teacherLabel, 6).heightIs(17);
            self.addressLabel.sd_layout.topSpaceToView(self.classRoomLabel, 6).autoHeightRatio(0);
            self.huiFangButton.sd_layout.topSpaceToView(self.addressLabel, 10);
        }
    }else{
        self.teacherLabel.sd_layout.topSpaceToView(self.keJieNameLabel, 0).heightIs(0);
        self.classRoomLabel.sd_layout.topSpaceToView(self.teacherLabel, 0).heightIs(0);
        self.addressLabel.sd_layout.topSpaceToView(self.classRoomLabel, 0);
        self.huiFangButton.sd_layout.topSpaceToView(self.addressLabel, 0);
    }
}

#pragma mark - Event
-(void)clickZhanKaiBtn:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zhanKaiCell:)]) {
        [self.delegate zhanKaiCell:self];
    }
}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.beginTimeLabel];
    [self.bigBackgroundView addSubview:self.endimeLabel];
    [self.bigBackgroundView addSubview:self.line1];
    [self.bigBackgroundView addSubview:self.yellowYuanDian];
    [self.bigBackgroundView addSubview:self.line2];
    [self.bigBackgroundView addSubview:self.blueYuanDian];
    [self.bigBackgroundView addSubview:self.line3];
    
    [self.bigBackgroundView addSubview:self.containerView];
    [self.containerView addSubview:self.typeLine];
    [self.containerView addSubview:self.typeLabel];
    [self.containerView addSubview:self.zhanKaiButton];
    [self.containerView addSubview:self.keJieNameLabel];
    [self.containerView addSubview:self.teacherLabel];
    [self.containerView addSubview:self.classRoomLabel];
    [self.containerView addSubview:self.addressLabel];
    [self.containerView addSubview:self.huiFangButton];
    [self.containerView addSubview:self.goLearnButton];
    [self.containerView addSubview:self.zhiBoButton];
   
    

    self.bigBackgroundView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    self.beginTimeLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 12)
    .leftSpaceToView(self.bigBackgroundView, 20)
    .widthIs(40)
    .heightIs(20);
    
    self.endimeLabel.sd_layout
    .topSpaceToView(self.beginTimeLabel, 10)
    .leftEqualToView(self.beginTimeLabel)
    .widthRatioToView(self.beginTimeLabel, 1)
    .heightRatioToView(self.beginTimeLabel, 1);
    
    self.yellowYuanDian.sd_layout
    .centerYEqualToView(self.beginTimeLabel)
    .leftSpaceToView(self.beginTimeLabel, 10)
    .widthIs(6)
    .heightEqualToWidth();
    self.yellowYuanDian.sd_cornerRadiusFromHeightRatio=@0.5;
    
    self.blueYuanDian.sd_layout
    .centerYEqualToView(self.endimeLabel)
    .centerXEqualToView(self.yellowYuanDian)
    .widthRatioToView(self.yellowYuanDian, 1)
    .heightRatioToView(self.yellowYuanDian, 1);
    self.blueYuanDian.sd_cornerRadiusFromHeightRatio=@0.5;
    
    self.line1.sd_layout
    .topSpaceToView(self.bigBackgroundView, 0)
    .bottomSpaceToView(self.yellowYuanDian, 0)
    .centerXEqualToView(self.yellowYuanDian)
    .widthIs(1);
    
    self.line2.sd_layout
    .topSpaceToView(self.yellowYuanDian, 0)
    .bottomSpaceToView(self.blueYuanDian, 0)
    .centerXEqualToView(self.yellowYuanDian)
    .widthIs(1);
    
    self.line3.sd_layout
    .topSpaceToView(self.blueYuanDian, 0)
    .bottomSpaceToView(self.bigBackgroundView, 0)
    .centerXEqualToView(self.yellowYuanDian)
    .widthIs(1);
    
   
    self.containerView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 8)
    .leftSpaceToView(self.yellowYuanDian, 15)
    .rightSpaceToView(self.bigBackgroundView, 20);
    self.containerView.sd_cornerRadius = @8;
    
    
    self.typeLine.sd_layout
    .topSpaceToView(self.containerView, 12)
    .leftSpaceToView(self.containerView, 12)
    .widthIs(2)
    .heightIs(12);
    self.typeLine.sd_cornerRadiusFromWidthRatio = @0.5;
    
    self.typeLabel.sd_layout
    .centerYEqualToView(self.typeLine)
    .leftSpaceToView(self.typeLine, 3)
    .heightIs(17)
    .widthIs(80);
    
    self.zhanKaiButton.sd_layout
    .centerYEqualToView(self.typeLine)
    .rightEqualToView(self.containerView)
    .widthIs(60)
    .heightIs(30);
    
    self.zhanKaiButton.imageView.sd_layout
    .centerYEqualToView(self.zhanKaiButton)
    .centerXEqualToView(self.zhanKaiButton)
    .widthIs(12)
    .heightIs(7);
    
    self.keJieNameLabel.sd_layout
    .leftEqualToView(self.typeLine)
    .topSpaceToView(self.typeLine, 10)
    .rightSpaceToView(self.containerView, 10)
    .heightIs(20);
    
    self.teacherLabel.sd_layout
    .leftEqualToView(self.typeLine)
    .topSpaceToView(self.keJieNameLabel, 6)
    .rightEqualToView(self.keJieNameLabel)
    .heightIs(17);
    
    self.classRoomLabel.sd_layout
    .leftEqualToView(self.typeLine)
    .topSpaceToView(self.teacherLabel, 6)
    .rightEqualToView(self.keJieNameLabel)
    .heightIs(17);
    
    self.addressLabel.sd_layout
    .leftEqualToView(self.typeLine)
    .topSpaceToView(self.classRoomLabel, 6)
    .rightEqualToView(self.keJieNameLabel)
    .autoHeightRatio(0);
    [self.addressLabel setMaxNumberOfLinesToShow:2];
    
    
    self.huiFangButton.sd_layout
    .topSpaceToView(self.addressLabel, 10)
    .rightSpaceToView(self.containerView, 10)
    .widthIs(60)
    .heightIs(26);
    
    self.huiFangButton.imageView.sd_layout
    .centerYEqualToView(self.huiFangButton)
    .rightEqualToView(self.huiFangButton)
    .widthIs(16)
    .heightEqualToWidth();
    
    self.huiFangButton.titleLabel.sd_layout
    .centerYEqualToView(self.huiFangButton)
    .rightSpaceToView(self.huiFangButton.imageView, 4)
    .leftEqualToView(self.huiFangButton)
    .heightIs(26);
    
    self.goLearnButton.sd_layout
    .centerYEqualToView(self.huiFangButton)
    .centerXEqualToView(self.huiFangButton)
    .widthRatioToView(self.huiFangButton, 1)
    .heightRatioToView(self.huiFangButton, 1);
    
    self.goLearnButton.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.zhiBoButton.sd_layout
    .centerYEqualToView(self.huiFangButton)
    .centerXEqualToView(self.huiFangButton)
    .widthRatioToView(self.huiFangButton, 1)
    .heightRatioToView(self.huiFangButton, 1);
    
    self.zhiBoButton.sd_cornerRadiusFromHeightRatio = @0.5;
    
    
    [self.containerView setupAutoHeightWithBottomView:self.huiFangButton bottomMargin:10];
    
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.containerView bottomMargin:5];
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:0];
}



#pragma mark - LazyLoad

-(UIView *)bigBackgroundView{
    if (!_bigBackgroundView) {
        _bigBackgroundView = [[UIView alloc] init];
        _bigBackgroundView.backgroundColor = [UIColor whiteColor];
        _bigBackgroundView.clipsToBounds = YES;
    }
    return _bigBackgroundView;
}

-(UILabel *)beginTimeLabel{
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc] init];
        _beginTimeLabel.textAlignment = NSTextAlignmentRight;
        _beginTimeLabel.font = HXFont(14);
        _beginTimeLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        
    }
    return _beginTimeLabel;
}

-(UILabel *)endimeLabel{
    if (!_endimeLabel) {
        _endimeLabel = [[UILabel alloc] init];
        _endimeLabel.textAlignment = NSTextAlignmentRight;
        _endimeLabel.font = HXFont(14);
        _endimeLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        
    }
    return _endimeLabel;
}

-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = COLOR_WITH_ALPHA(0xF6F6F6, 1);
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

-(UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
    }
    return _line1;
}

-(UIView *)yellowYuanDian{
    if (!_yellowYuanDian) {
        _yellowYuanDian = [[UIView alloc] init];
        _yellowYuanDian.backgroundColor = COLOR_WITH_ALPHA(0xFFAF53, 1);
    }
    return _yellowYuanDian;
}

-(UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
    }
    return _line2;
}

-(UIView *)blueYuanDian{
    if (!_blueYuanDian) {
        _blueYuanDian = [[UIView alloc] init];
        _blueYuanDian.backgroundColor = COLOR_WITH_ALPHA(0x4988FD, 1);
    }
    return _blueYuanDian;
}

-(UIView *)line3{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
    }
    return _line3;
}

-(UIView *)typeLine{
    if (!_typeLine) {
        _typeLine = [[UIView alloc] init];
        _typeLine.backgroundColor = COLOR_WITH_ALPHA(0x4988FD, 1);
    }
    return _typeLine;
}

-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = HXFont(12);
        _typeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _typeLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        
    }
    return _typeLabel;
}


-(UIButton *)zhanKaiButton{
    if (!_zhanKaiButton) {
        _zhanKaiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhanKaiButton setImage:[UIImage imageNamed:@"normalarrow_icon"] forState:UIControlStateNormal];
        [_zhanKaiButton setImage:[UIImage imageNamed:@"selectedarrow_icon"] forState:UIControlStateSelected];
        [_zhanKaiButton addTarget:self action:@selector(clickZhanKaiBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zhanKaiButton;
}





-(UILabel *)keJieNameLabel{
    if (!_keJieNameLabel) {
        _keJieNameLabel = [[UILabel alloc] init];
        _keJieNameLabel.textAlignment = NSTextAlignmentLeft;
        _keJieNameLabel.font = HXBoldFont(14);
        _keJieNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _keJieNameLabel.textColor = COLOR_WITH_ALPHA(0x474747, 1);
        _keJieNameLabel.numberOfLines = 0;
    }
    return _keJieNameLabel;
}

-(UILabel *)teacherLabel{
    if (!_teacherLabel) {
        _teacherLabel = [[UILabel alloc] init];
        _teacherLabel.textAlignment = NSTextAlignmentLeft;
        _teacherLabel.font = HXFont(12);
        _teacherLabel.textColor = COLOR_WITH_ALPHA(0x646464, 1);
        
    }
    return _teacherLabel;
}


-(UILabel *)classRoomLabel{
    if (!_classRoomLabel) {
        _classRoomLabel = [[UILabel alloc] init];
        _classRoomLabel.textAlignment = NSTextAlignmentLeft;
        _classRoomLabel.font = HXFont(12);
        _classRoomLabel.textColor = COLOR_WITH_ALPHA(0x646464, 1);
        
    }
    return _classRoomLabel;
}

-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.font = HXFont(12);
        _addressLabel.textColor = COLOR_WITH_ALPHA(0x646464, 1);
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}




-(UIButton *)huiFangButton{
    if (!_huiFangButton) {
        _huiFangButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _huiFangButton.titleLabel.font = HXFont(13);
        _huiFangButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_huiFangButton setTitleColor:COLOR_WITH_ALPHA(0x4988FD, 1) forState:UIControlStateNormal];
        [_huiFangButton setTitle:@"回放" forState:UIControlStateNormal];
        [_huiFangButton setImage:[UIImage imageNamed:@"huifangsamll_icon"] forState:UIControlStateNormal];
        _huiFangButton.userInteractionEnabled = NO;
        _huiFangButton.hidden = YES;
    }
    return _huiFangButton;
}

-(UIButton *)goLearnButton{
    if (!_goLearnButton) {
        _goLearnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _goLearnButton.backgroundColor = COLOR_WITH_ALPHA(0x4580F8, 1);
        _goLearnButton.titleLabel.font = HXFont(13);
        _goLearnButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_goLearnButton setTitleColor:COLOR_WITH_ALPHA(0xFFFFFF, 1) forState:UIControlStateNormal];
        [_goLearnButton setTitle:@"去上课" forState:UIControlStateNormal];
        _goLearnButton.userInteractionEnabled = NO;
        _goLearnButton.hidden = YES;
    }
    return _goLearnButton;
}

-(UIButton *)zhiBoButton{
    if (!_zhiBoButton) {
        _zhiBoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _zhiBoButton.backgroundColor = COLOR_WITH_ALPHA(0xFF8B19, 1);
        _zhiBoButton.titleLabel.font = HXFont(13);
        _zhiBoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_zhiBoButton setTitleColor:COLOR_WITH_ALPHA(0xFFFFFF, 1) forState:UIControlStateNormal];
        [_zhiBoButton setTitle:@"直播中" forState:UIControlStateNormal];
        _zhiBoButton.userInteractionEnabled = NO;
        _zhiBoButton.hidden = YES;
    }
    return _zhiBoButton;
}


@end
