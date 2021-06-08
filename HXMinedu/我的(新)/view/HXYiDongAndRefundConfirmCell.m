//
//  HXYiDongAndRefundConfirmCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/3.
//

#import "HXYiDongAndRefundConfirmCell.h"

@interface HXYiDongAndRefundConfirmCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIImageView *confirmStateImageView;//确认状态：待确认 、确认无误、已驳回
@property(nonatomic,strong) UILabel *timeTitleLabel;
@property(nonatomic,strong) UILabel *timeContentLabel;

@property(nonatomic,strong) UIImageView *topDashLine;
@property(nonatomic,strong) UILabel *typeTitleLabel;///退费类型/异动类型
@property(nonatomic,strong) UILabel *typeContentLabel;

@property(nonatomic,strong) UIButton *markBtn1;
@property(nonatomic,strong) UIButton *markBtn2;
@property(nonatomic,strong) UIButton *markBtn3;

@property(nonatomic,strong) UILabel *nameAndVersinContentLabel;
@property(nonatomic,strong) UILabel *majorContentLabel;

@property(nonatomic,strong) UIImageView *bottomDashLine;
@property(nonatomic,strong) UIButton *goConfirmBtn;//去确认
@property(nonatomic,strong) UIButton *checkDetailBtn;//查看详情

@end



@implementation HXYiDongAndRefundConfirmCell

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

#pragma mark - Event

-(void)clickItem:(UIButton *)sender{
    NSInteger tag = sender.tag;
    
}

#pragma mark - Setter
-(void)setConfirmType:(HXConfirmType)confirmType{
    _confirmType = confirmType;
    self.timeTitleLabel.text = (confirmType == HXYiDongConfirmType ? @"异动时间：" : @"申请时间：");
    self.typeTitleLabel.text = (confirmType == HXYiDongConfirmType ? @"异动类型：" : @"退费类型：");
}

//-(void)setCourseModel:(HXCourseModel *)courseModel{
//    _courseModel = courseModel;
//    [self.topDashLine sd_setImageWithURL:[NSURL URLWithString:[HXCommonUtil stringEncoding:courseModel.imageURL]] placeholderImage:nil];
//    self.courseNameLabel.text = HXSafeString(courseModel.courseName);
//
//    //5001-必修 5002-选修 以外其它
//    if (courseModel.courseType_id == 5001) {
//        self.confirmStateImageView.image = [UIImage imageNamed:@"bixiuke"];
//        self.confirmStateLabel.text = @"必修课";
//    }else if (courseModel.courseType_id == 5002) {
//        self.confirmStateImageView.image = [UIImage imageNamed:@"xuanxiuke"];
//        self.confirmStateLabel.text = @"选修课";
//    }else{
//        self.confirmStateImageView.image = [UIImage imageNamed:@"qitake"];
//        self.confirmStateLabel.text = @"其它";
//    }
//
//
//    [self.markContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        //移除关联对象
//        objc_removeAssociatedObjects(obj);
//        [obj removeFromSuperview];
//        obj = nil;
//    }];
//    if (courseModel.modules.count == 0) {
//        self.markContainerView.sd_layout.heightIs(0);
//    }else{
//        self.markContainerView.sd_layout.heightIs(46);
//        for (int i= 0; i<courseModel.modules.count; i++) {
//            HXModelItem *item = courseModel.modules[i];
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self.markContainerView addSubview:btn];
//            //将数据关联按钮
//            objc_setAssociatedObject(btn, &BtnWithItemKey, item, OBJC_ASSOCIATION_RETAIN);
//            btn.titleLabel.font = HXFont(_kpAdaptationWidthFont(10));
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [btn setTitle:HXSafeString(item.ModuleName) forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
//            if ([item.ExamCourseType isEqualToString:@"1"]) {//课件学习
//                btn.tag = 7777;
//                [btn setBackgroundColor:COLOR_WITH_ALPHA(0x5699FF, 1)];
//                [btn setImage:[UIImage imageNamed:@"kejian_icon"] forState:UIControlStateNormal];
//            }else if ([item.ExamCourseType isEqualToString:@"2"]) {//平时作业
//                btn.tag = 8888;
//                [btn setBackgroundColor:COLOR_WITH_ALPHA(0x4DC656, 1)];
//                [btn setImage:[UIImage imageNamed:@"pingshi_icon"] forState:UIControlStateNormal];
//            }else{//期末考试
//                btn.tag = 9999;
//                [btn setBackgroundColor:COLOR_WITH_ALPHA(0xFAC639, 1)];
//                [btn setImage:[UIImage imageNamed:@"qimo_icon"] forState:UIControlStateNormal];
//            }
//
//            btn.sd_layout
//            .topEqualToView(self.markContainerView)
//            .leftSpaceToView(self.markContainerView, _kpw(23)+i*(_kpw(80)+_kpw(23)))
//            .widthIs(_kpw(80))
//            .heightIs(30);
//            btn.sd_cornerRadiusFromHeightRatio = @0.5;
//
//            btn.imageView.sd_layout
//            .centerYEqualToView(btn)
//            .leftSpaceToView(btn, 10)
//            .widthIs(12)
//            .heightEqualToWidth();
//
//            btn.titleLabel.sd_layout
//            .centerYEqualToView(btn)
//            .leftSpaceToView(btn.imageView, 5)
//            .rightSpaceToView(btn, 10)
//            .heightRatioToView(btn, 1);
//        }
//    }
//
//}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.confirmStateImageView];
    [self.bigBackgroundView addSubview:self.timeTitleLabel];
    [self.bigBackgroundView addSubview:self.timeContentLabel];
    [self.bigBackgroundView addSubview:self.topDashLine];
    [self.bigBackgroundView addSubview:self.typeTitleLabel];
    [self.bigBackgroundView addSubview:self.typeContentLabel];
    [self.bigBackgroundView addSubview:self.markBtn1];
    [self.bigBackgroundView addSubview:self.markBtn2];
    [self.bigBackgroundView addSubview:self.markBtn3];
    [self.bigBackgroundView addSubview:self.nameAndVersinContentLabel];
    [self.bigBackgroundView addSubview:self.majorContentLabel];
    [self.bigBackgroundView addSubview:self.bottomDashLine];
    [self.bigBackgroundView addSubview:self.goConfirmBtn];
    [self.bigBackgroundView addSubview:self.checkDetailBtn];
   

    
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, _kpw(10))
    .topSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, _kpw(10));
    self.bigBackgroundView.sd_cornerRadius = @6;
    
    self.confirmStateImageView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .widthIs(70)
    .heightIs(43);
    
    self.timeTitleLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 18)
    .leftSpaceToView(self.bigBackgroundView, 24)
    .widthIs(76)
    .heightIs(20);
   
    
    self.timeContentLabel.sd_layout
    .centerYEqualToView(self.timeTitleLabel)
    .leftSpaceToView(self.timeTitleLabel, 5)
    .rightSpaceToView(self.confirmStateImageView, 5)
    .heightRatioToView(self.timeTitleLabel, 1);
    
    
    self.topDashLine.sd_layout
    .topSpaceToView(self.timeTitleLabel, 12)
    .leftSpaceToView(self.bigBackgroundView, 14)
    .rightSpaceToView(self.bigBackgroundView, 14)
    .heightIs(1);
   
    
    self.typeTitleLabel.sd_layout
    .topSpaceToView(self.topDashLine, 15)
    .leftEqualToView(self.timeTitleLabel)
    .widthIs(76)
    .heightRatioToView(self.timeTitleLabel, 1);
    
    
    self.typeContentLabel.sd_layout
    .centerYEqualToView(self.typeTitleLabel)
    .leftSpaceToView(self.typeTitleLabel, 5)
    .heightRatioToView(self.timeTitleLabel, 1);
    [self.typeContentLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.markBtn1.sd_layout
    .leftSpaceToView(self.typeContentLabel, 8)
    .centerYEqualToView(self.typeContentLabel);
    [self.markBtn1 setupAutoSizeWithHorizontalPadding:8 buttonHeight:22];
    self.markBtn1.sd_cornerRadius = @2;
    
    self.markBtn2.sd_layout
    .leftSpaceToView(self.markBtn1, 8)
    .centerYEqualToView(self.typeContentLabel);
    [self.markBtn2 setupAutoSizeWithHorizontalPadding:8 buttonHeight:22];
    self.markBtn2.sd_cornerRadius = @2;
    
    self.markBtn3.sd_layout
    .leftSpaceToView(self.markBtn2, 8)
    .centerYEqualToView(self.typeContentLabel);
    [self.markBtn3 setupAutoSizeWithHorizontalPadding:8 buttonHeight:22];
    self.markBtn3.sd_cornerRadius = @2;
    
    self.nameAndVersinContentLabel.sd_layout
    .topSpaceToView(self.typeTitleLabel, 12)
    .leftEqualToView(self.timeTitleLabel)
    .rightSpaceToView(self.bigBackgroundView, 24)
    .heightRatioToView(self.timeTitleLabel, 1);
    
    self.majorContentLabel.sd_layout
    .topSpaceToView(self.nameAndVersinContentLabel, 12)
    .leftEqualToView(self.timeTitleLabel)
    .rightSpaceToView(self.bigBackgroundView, 24)
    .autoHeightRatio(0);
    [self.majorContentLabel setMaxNumberOfLinesToShow:2];
    
    self.bottomDashLine.sd_layout
    .topSpaceToView(self.majorContentLabel, 16)
    .leftEqualToView(self.topDashLine)
    .rightEqualToView(self.topDashLine)
    .heightRatioToView(self.topDashLine, 1);
    
    
    self.goConfirmBtn.sd_layout
    .topSpaceToView(self.bottomDashLine, 10)
    .rightSpaceToView(self.bigBackgroundView, 24)
    .widthIs(90)
    .heightIs(30);
    self.goConfirmBtn.sd_cornerRadiusFromHeightRatio = @0.5;
   
    self.checkDetailBtn.sd_layout
    .centerYEqualToView(self.goConfirmBtn)
    .centerXEqualToView(self.goConfirmBtn)
    .widthRatioToView(self.goConfirmBtn, 1)
    .heightRatioToView(self.goConfirmBtn, 1);
    self.checkDetailBtn.sd_cornerRadiusFromHeightRatio = @0.5;

    //设置bigBackgroundView自适应高度
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.goConfirmBtn bottomMargin:12];
    
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 6;
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:0];
}


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

-(UIImageView *)confirmStateImageView{
    if (!_confirmStateImageView) {
        _confirmStateImageView = [[UIImageView alloc] init];
        _confirmStateImageView.image = [UIImage imageNamed:@"waitconfirm"];
    }
    return _confirmStateImageView;
}



-(UILabel *)timeTitleLabel{
    if (!_timeTitleLabel) {
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _timeTitleLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _timeTitleLabel.font = HXFont(14);
    }
    return _timeTitleLabel;;
}

-(UILabel *)timeContentLabel{
    if (!_timeContentLabel) {
        _timeContentLabel = [[UILabel alloc] init];
        _timeContentLabel.textAlignment = NSTextAlignmentLeft;
        _timeContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _timeContentLabel.font = HXBoldFont(14);
        _timeContentLabel.text = @"2021-12-24  12:20";
    }
    return _timeContentLabel;;
}

-(UIImageView *)topDashLine{
    if (!_topDashLine) {
        _topDashLine = [[UIImageView alloc] init];
        _topDashLine.image = [UIImage imageNamed:@"xidashline"];
        _topDashLine.clipsToBounds = YES;
        _topDashLine.contentMode = UIViewContentModeScaleToFill;
    }
    return _topDashLine;;
}

-(UILabel *)typeTitleLabel{
    if (!_typeTitleLabel) {
        _typeTitleLabel = [[UILabel alloc] init];
        _typeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _typeTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _typeTitleLabel.font = HXFont(14);
    }
    return _typeTitleLabel;;
}

-(UILabel *)typeContentLabel{
    if (!_typeContentLabel) {
        _typeContentLabel = [[UILabel alloc] init];
        _typeContentLabel.textAlignment = NSTextAlignmentLeft;
        _typeContentLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _typeContentLabel.font = HXBoldFont(14);
        _typeContentLabel.text = @"退学";
    }
    return _typeContentLabel;;
}
-(UIButton *)markBtn1{
    if (!_markBtn1) {
        _markBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _markBtn1.titleLabel.font = HXBoldFont(12);
        _markBtn1.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
        [_markBtn1 setTitle:@"确认无误" forState:UIControlStateNormal];
        [_markBtn1 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
    }
    return _markBtn1;
}

-(UIButton *)markBtn2{
    if (!_markBtn2) {
        _markBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _markBtn2.titleLabel.font = HXBoldFont(12);
        _markBtn2.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
        [_markBtn2 setTitle:@"已通过" forState:UIControlStateNormal];
        [_markBtn2 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
    }
    return _markBtn2;
}

-(UIButton *)markBtn3{
    if (!_markBtn3) {
        _markBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _markBtn3.titleLabel.font = HXBoldFont(12);
        _markBtn3.backgroundColor = COLOR_WITH_ALPHA(0xFFF5DA, 1);
        [_markBtn3 setTitle:@"审核中" forState:UIControlStateNormal];
        [_markBtn3 setTitleColor:COLOR_WITH_ALPHA(0xFE664B, 1) forState:UIControlStateNormal];
    }
    return _markBtn3;
}
-(UILabel *)nameAndVersinContentLabel{
    if (!_nameAndVersinContentLabel) {
        _nameAndVersinContentLabel = [[UILabel alloc] init];
        _nameAndVersinContentLabel.textAlignment = NSTextAlignmentLeft;
        _nameAndVersinContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _nameAndVersinContentLabel.font = HXFont(14);
        _nameAndVersinContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameAndVersinContentLabel.text = @"薛志强_成人高考";
    }
    return _nameAndVersinContentLabel;
}

-(UILabel *)majorContentLabel{
    if (!_majorContentLabel) {
        _majorContentLabel = [[UILabel alloc] init];
        _majorContentLabel.textAlignment = NSTextAlignmentLeft;
        _majorContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _majorContentLabel.font = HXFont(14);
        _majorContentLabel.numberOfLines = 0;
        _majorContentLabel.text = @"2013_本科_怀化学院_中小学教育";
    }
    return _majorContentLabel;
}

-(UIImageView *)bottomDashLine{
    if (!_bottomDashLine) {
        _bottomDashLine = [[UIImageView alloc] init];
        _bottomDashLine.image = [UIImage imageNamed:@"xidashline"];
        _bottomDashLine.clipsToBounds = YES;
        _bottomDashLine.contentMode = UIViewContentModeScaleToFill;
    }
    return _bottomDashLine;;
}


-(UIButton *)goConfirmBtn{
    if (!_goConfirmBtn) {
        _goConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goConfirmBtn.titleLabel.font = HXBoldFont(14);
        _goConfirmBtn.backgroundColor = COLOR_WITH_ALPHA(0xFF9F0A, 1);
        [_goConfirmBtn setTitle:@"去确认" forState:UIControlStateNormal];
        [_goConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _goConfirmBtn;
}

-(UIButton *)checkDetailBtn{
    if (!_checkDetailBtn) {
        _checkDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkDetailBtn.titleLabel.font = HXBoldFont(14);
        _checkDetailBtn.backgroundColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        [_checkDetailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_checkDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkDetailBtn.hidden = YES;
    }
    return _checkDetailBtn;
}





@end


