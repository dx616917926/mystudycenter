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

//回放、上课中（直播中）、去上课、请假
@property(nonatomic,strong) UIButton *operationButton;


//审核状态 LiveType等于3时处理 0未提交请假显示请假按钮 1待审核显示审核中 2已通过显示已请假 3已驳回显示已驳回不可再次申请
@property(nonatomic,strong) UIButton *auditStateButton;

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


-(void)  setKeJieModel:(HXKeJieModel *)keJieModel{
    
    _keJieModel = keJieModel;
    
    self.zhanKaiButton.selected = keJieModel.IsZhanKai;
    
    self.operationButton.hidden = YES;
    self.beginTimeLabel.text = HXSafeString(keJieModel.ClassBeginTime);
    self.endimeLabel.text = HXSafeString(keJieModel.ClassEndTime);
    self.keJieNameLabel.text = HXSafeString(keJieModel.ClassName);
    self.teacherLabel.text = [NSString stringWithFormat:@"授课教师：%@",HXSafeString(keJieModel.TeacherName)];
    self.classRoomLabel.text = [NSString stringWithFormat:@"上课教室：%@",HXSafeString(keJieModel.RoomName)];
   
    if (keJieModel.LiveType<=2) {
        self.typeLabel.text = @"直播课";
        self.typeLine.backgroundColor = self.typeLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
    }else{
        self.typeLabel.text = @"面授课";
        self.typeLine.backgroundColor = self.typeLabel.textColor = COLOR_WITH_ALPHA(0x51C29B, 1);
    }
    
    ///审核状态 LiveType等于3时处理 0未提交请假显示请假按钮 1待审核显示审核中 2已通过显示已请假 3已驳回显示已驳回不可再次申请
    if (keJieModel.LiveType==3) {
        self.auditStateButton.hidden = NO;
        if (keJieModel.AuditState==1) {
            self.auditStateButton.backgroundColor = COLOR_WITH_ALPHA(0xFB9D55, 1);
            [self.auditStateButton setTitle:@"审核中" forState:UIControlStateNormal];
        }else if (keJieModel.AuditState==2) {
            self.auditStateButton.backgroundColor = COLOR_WITH_ALPHA(0x42CBB4, 1);
            [self.auditStateButton setTitle:@"已请假" forState:UIControlStateNormal];
        }else if (keJieModel.AuditState==3) {
            self.auditStateButton.backgroundColor = COLOR_WITH_ALPHA(0xFF6868, 1);
            [self.auditStateButton setTitle:@"已驳回" forState:UIControlStateNormal];
        }else{
            self.auditStateButton.backgroundColor = UIColor.clearColor;
            [self.auditStateButton setTitle:@"" forState:UIControlStateNormal];
        }
    }else{
        self.auditStateButton.hidden = YES;
    }
    
    self.addressLabel.text = nil;
    
    if (keJieModel.IsZhanKai) {//展开
        if (keJieModel.LiveType<=2) {
            self.teacherLabel.sd_layout.topSpaceToView(self.keJieNameLabel, 6).heightIs(17);
            self.classRoomLabel.sd_layout.topSpaceToView(self.teacherLabel, 0).heightIs(0);
            self.addressLabel.sd_layout.topSpaceToView(self.classRoomLabel, 0);
            self.operationButton.sd_layout.topSpaceToView(self.addressLabel, 0);
        }else{
            self.addressLabel.text = [NSString stringWithFormat:@"教室地址：%@",HXSafeString(keJieModel.RoomAddr)];
            self.teacherLabel.sd_layout.topSpaceToView(self.keJieNameLabel, 6).heightIs(17);
            self.classRoomLabel.sd_layout.topSpaceToView(self.teacherLabel, 6).heightIs(17);
            self.addressLabel.sd_layout.topSpaceToView(self.classRoomLabel, 6).autoHeightRatio(0);
            self.operationButton.sd_layout.topSpaceToView(self.addressLabel, 10);
        }
        if (keJieModel.LiveType==3) {
           
            //审核状态  0未提交请假显示请假按钮 1待审核显示审核中 2已通过显示已请假 3已驳回显示已驳回不可再次申请
            //签到状态 -1未签到可提交请假申请 0提交请假申请审核中 1到课 2迟到 3请假 4未到 LiveType等于3时处理
            if (keJieModel.AuditState==0&&keJieModel.LiveState==0&&keJieModel.Status==-1) {
                self.operationButton.backgroundColor = COLOR_WITH_ALPHA(0x42CBB4, 1);
                [self.operationButton setTitle:@"请假" forState:UIControlStateNormal];
                self.operationButton.hidden = NO;
                self.auditStateButton.hidden = YES;
            }else{
                self.operationButton.hidden = NO;
                self.auditStateButton.hidden = NO;
                ///直播状态 0待开始  1直播中  2已结束
                if (keJieModel.LiveState==1) {
                    self.auditStateButton.hidden = YES;
                    self.operationButton.backgroundColor = COLOR_WITH_ALPHA(0xFF8B19, 1);
                    [self.operationButton setTitle:@"上课中" forState:UIControlStateNormal];
                }else if (keJieModel.LiveState==2) {
                    self.auditStateButton.hidden = YES;
                    self.operationButton.backgroundColor = COLOR_WITH_ALPHA(0x4580F8, 1);
                    [self.operationButton setTitle:(keJieModel.IsEvaluate==0?@"点评":@"查看点评") forState:UIControlStateNormal];
                }else{
                    self.operationButton.hidden = YES;
                }
            }
        }else{
            self.operationButton.hidden = NO;
            self.auditStateButton.hidden = YES;
            ///直播状态 0待开始  1直播中  2已结束
            if (keJieModel.LiveState==1) {
                self.operationButton.backgroundColor = COLOR_WITH_ALPHA(0xFF8B19, 1);
                [self.operationButton setTitle:@"直播中" forState:UIControlStateNormal];
            }else if (keJieModel.LiveState==2) {
                self.operationButton.backgroundColor = COLOR_WITH_ALPHA(0x4580F8, 1);
                [self.operationButton setTitle:@"回放" forState:UIControlStateNormal];
            }else{
                self.operationButton.backgroundColor = COLOR_WITH_ALPHA(0x4580F8, 1);
                [self.operationButton setTitle:@"去上课" forState:UIControlStateNormal];
            }
        }
    
    }else{
        if (keJieModel.LiveType==3) {
            self.operationButton.hidden = YES;
            self.auditStateButton.hidden = NO;
        }else{
            self.operationButton.hidden = YES;
            self.auditStateButton.hidden = YES;
        }
        self.teacherLabel.sd_layout.topSpaceToView(self.keJieNameLabel, 0).heightIs(0);
        self.classRoomLabel.sd_layout.topSpaceToView(self.teacherLabel, 0).heightIs(0);
        self.addressLabel.sd_layout.topSpaceToView(self.classRoomLabel, 0);
        self.operationButton.sd_layout.topSpaceToView(self.addressLabel, 0);
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
    [self.containerView addSubview:self.operationButton];
 
    [self.containerView addSubview:self.auditStateButton];
    

   
    

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
    
    
    self.operationButton.sd_layout
    .topSpaceToView(self.addressLabel, 10)
    .rightSpaceToView(self.containerView, 10)
    .widthIs(65)
    .heightIs(26);
    self.operationButton.sd_cornerRadiusFromHeightRatio = @0.5;
    
    
    [self.containerView setupAutoHeightWithBottomView:self.operationButton bottomMargin:10];
    
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.containerView bottomMargin:5];
    
    self.auditStateButton.sd_layout
    .rightEqualToView(self.containerView)
    .bottomEqualToView(self.containerView);
    self.auditStateButton.sd_cornerRadius=@8;
    [self.auditStateButton setupAutoSizeWithHorizontalPadding:7 buttonHeight:22];
    
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






-(UIButton *)operationButton{
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.titleLabel.font = HXFont(13);
        _operationButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_operationButton setTitleColor:COLOR_WITH_ALPHA(0xFFFFFF, 1) forState:UIControlStateNormal];
        _operationButton.userInteractionEnabled = NO;
        _operationButton.hidden = YES;
    }
    return _operationButton;
}



-(UIButton *)auditStateButton{
    if (!_auditStateButton) {
        _auditStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _auditStateButton.titleLabel.font = HXFont(12);
        _auditStateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_auditStateButton setTitleColor:COLOR_WITH_ALPHA(0xFFFFFF, 1) forState:UIControlStateNormal];
        _auditStateButton.userInteractionEnabled = NO;
        _auditStateButton.hidden = YES;
    }
    return _auditStateButton;
}


@end
