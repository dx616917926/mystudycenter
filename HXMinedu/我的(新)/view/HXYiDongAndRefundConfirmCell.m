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

-(void)setStudentRefundModel:(HXStudentRefundModel *)studentRefundModel{
    _studentRefundModel = studentRefundModel;
    //0-待确认           1-确认无误       2-待退费  4-已退费     3-已驳回  5-已撤消
    //0-时不显示任何标签   1-时显示审核中   2和4-时显示已通过       3和5-时不显示标签
    
    self.goConfirmBtn.hidden = YES;
    self.checkDetailBtn.hidden = NO;
    switch (studentRefundModel.reviewStatus) {
        case 0://待确认
            
        {   self.goConfirmBtn.hidden = NO;
            self.checkDetailBtn.hidden = YES;
            self.confirmStateImageView.image = [UIImage imageNamed:@"waitconfirm"];
            self.markBtn1.hidden = YES;
        }
            break;
        case 1://确认无误
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"confirmnoerror"];
            self.markBtn1.hidden = NO;
            self.markBtn1.backgroundColor = COLOR_WITH_ALPHA(0xFFF5DA, 1);
            [self.markBtn1 setTitle:@"审核中" forState:UIControlStateNormal];
            [self.markBtn1 setTitleColor:COLOR_WITH_ALPHA(0xFE664B, 1) forState:UIControlStateNormal];
        }
            break;
        case 2://待退费
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"waitrefund"];
            self.markBtn1.hidden = NO;
            self.markBtn1.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
            [self.markBtn1 setTitle:@"已通过" forState:UIControlStateNormal];
            [self.markBtn1 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
        }
            break;
        case 4://已退费
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"refunded"];
            self.markBtn1.hidden = NO;
            self.markBtn1.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
            [self.markBtn1 setTitle:@"已通过" forState:UIControlStateNormal];
            [self.markBtn1 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
            
        }
            break;
        case 3://已驳回
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"rejected"];
            self.markBtn1.hidden = YES;
        }
            break;
        case 5://已撤消
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"reversed"];
            self.markBtn1.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    self.timeContentLabel.text = HXSafeString(studentRefundModel.createtime);
    self.typeContentLabel.text = HXSafeString(studentRefundModel.refundTypeName);
    self.nameAndVersinContentLabel.text = HXSafeString(studentRefundModel.name);
    self.majorContentLabel.text = HXSafeString(studentRefundModel.title);
}

-(void)setStudentYiDongModel:(HXStudentYiDongModel *)studentYiDongModel{
    
    _studentYiDongModel = studentYiDongModel;
    
    ///0-待确认           1-已确认         2-审核中     3-待终审       4-已同意       5-已驳回
    /// 015 不显示    23审核中         4已通过  
    
    self.goConfirmBtn.hidden = YES;
    self.checkDetailBtn.hidden = NO;
    switch (studentYiDongModel.reviewStatus) {
        case 0://待确认
            
        {   self.goConfirmBtn.hidden = NO;
            self.checkDetailBtn.hidden = YES;
            self.confirmStateImageView.image = [UIImage imageNamed:@"waitconfirm"];
            self.markBtn1.hidden = YES;
        }
            break;
        case 1://确认无误
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"confirmnoerror"];
            self.markBtn1.hidden = YES;
    
        }
            break;
        case 2://审核中
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"shenhezhong"];
            self.markBtn1.hidden = NO;
            self.markBtn1.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
            [self.markBtn1 setTitle:@"审核中 " forState:UIControlStateNormal];
            [self.markBtn1 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
        }
            break;
        case 3://待终审
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"daizhongshen"];
            self.markBtn1.hidden = NO;
            self.markBtn1.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
            [self.markBtn1 setTitle:@"审核中 " forState:UIControlStateNormal];
            [self.markBtn1 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
        }
            break;
        case 4://已同意
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"yitongyi"];
            self.markBtn1.hidden = NO;
            self.markBtn1.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
            [self.markBtn1 setTitle:@"已通过" forState:UIControlStateNormal];
            [self.markBtn1 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
            
        }
            break;
        case 5://已驳回
        {
            self.confirmStateImageView.image = [UIImage imageNamed:@"rejected"];
            self.markBtn1.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    self.timeContentLabel.text = HXSafeString(studentYiDongModel.stopTypeTime);
    self.typeContentLabel.text = HXSafeString(studentYiDongModel.stopTypeName);
    self.nameAndVersinContentLabel.text = HXSafeString(studentYiDongModel.name);
    self.majorContentLabel.text = HXSafeString(studentYiDongModel.title);
}



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
        
    }
    return _typeContentLabel;;
}
-(UIButton *)markBtn1{
    if (!_markBtn1) {
        _markBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _markBtn1.titleLabel.font = HXBoldFont(12);
        
    }
    return _markBtn1;
}


-(UILabel *)nameAndVersinContentLabel{
    if (!_nameAndVersinContentLabel) {
        _nameAndVersinContentLabel = [[UILabel alloc] init];
        _nameAndVersinContentLabel.textAlignment = NSTextAlignmentLeft;
        _nameAndVersinContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _nameAndVersinContentLabel.font = HXFont(14);
        _nameAndVersinContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
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
        _goConfirmBtn.hidden = YES;
        _goConfirmBtn.userInteractionEnabled = NO;
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
        _checkDetailBtn.userInteractionEnabled = NO;
    }
    return _checkDetailBtn;
}





@end


