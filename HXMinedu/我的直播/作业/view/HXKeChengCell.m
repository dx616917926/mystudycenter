//
//  HXKeChengCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXKeChengCell.h"
#import "SDWebImage.h"

@interface HXKeChengCell ()

@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIImageView *coverImageView;
@property(nonatomic,strong) UIButton *typeBtn;
@property(nonatomic,strong) UIView *fenGeLine;
@property(nonatomic,strong) UILabel *keChengNameLabel;
@property(nonatomic,strong) UILabel *shiYongTypeLabel;
@property(nonatomic,strong) UILabel *totalNumLabel;
@property(nonatomic,strong) UILabel *unfinishNumLabel;
@property(nonatomic,strong) UILabel *teacherNameLabel;
@property(nonatomic,strong) UILabel *timeLabel;


@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXKeChengCell

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

-(void)setKeChengModel:(HXKeChengModel *)keChengModel{
    
    _keChengModel = keChengModel;
    
    self.shiYongTypeLabel.hidden = self.totalNumLabel.hidden = self.unfinishNumLabel.hidden = YES;
    self.teacherNameLabel.hidden = self.timeLabel.hidden = YES;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[HXCommonUtil stringEncoding:keChengModel.imgUrl]] placeholderImage:[UIImage imageNamed:@"kechengzhanwei_bg"]];
    
    [self.typeBtn setTitle:(keChengModel.LiveType==3?@"面授":@"直播") forState:UIControlStateNormal];
    
    self.keChengNameLabel.text = HXSafeString(keChengModel.MealName);
    
    ///直播类型 1ClassIn  2保利威 保利威直接跳转页面直播 ClassIn进入下一页面展示课节
    if (keChengModel.LiveType==1) {
        self.shiYongTypeLabel.sd_layout.heightIs(14);
        self.shiYongTypeLabel.hidden = self.totalNumLabel.hidden = self.unfinishNumLabel.hidden = NO;
        self.shiYongTypeLabel.text = [NSString stringWithFormat:@"适用类型：%@",keChengModel.MealApplyTypeName];
        self.totalNumLabel.text = [NSString stringWithFormat:@"总课节数：%ld节",keChengModel.ClassNum];
        self.unfinishNumLabel.text = [NSString stringWithFormat:@"待完成课节数：%ld节",keChengModel.UndoneClassNum];
    }else if (keChengModel.LiveType==2) {
        self.shiYongTypeLabel.sd_layout.heightIs(14);
        self.teacherNameLabel.hidden = self.timeLabel.hidden = NO;
        self.teacherNameLabel.text = [NSString stringWithFormat:@"授课教师：%@",HXSafeString(keChengModel.TeacherName)];
        self.timeLabel.text = [NSString stringWithFormat:@"上课时间：%@ %@",HXSafeString(keChengModel.MealBeginDate),HXSafeString(keChengModel.MealBeginTime)];
    }else{
        self.shiYongTypeLabel.sd_layout.heightIs(0);
        self.totalNumLabel.hidden = self.unfinishNumLabel.hidden = NO;
        self.totalNumLabel.text = [NSString stringWithFormat:@"总课节数：%ld节",keChengModel.ClassNum];
        self.unfinishNumLabel.text = [NSString stringWithFormat:@"待完成课节数：%ld节",keChengModel.UndoneClassNum];
    }
    
}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.coverImageView];
    [self.coverImageView addSubview:self.typeBtn];
    [self.bigBackgroundView addSubview:self.fenGeLine];
    [self.bigBackgroundView addSubview:self.keChengNameLabel];
    [self.bigBackgroundView addSubview:self.shiYongTypeLabel];
    [self.bigBackgroundView addSubview:self.totalNumLabel];
    [self.bigBackgroundView addSubview:self.unfinishNumLabel];
    [self.bigBackgroundView addSubview:self.teacherNameLabel];
    [self.bigBackgroundView addSubview:self.timeLabel];
    [self.bigBackgroundView addSubview:self.bottomLine];
    



    self.bigBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.coverImageView.sd_layout
    .leftSpaceToView(self.bigBackgroundView, 20)
    .topSpaceToView(self.bigBackgroundView, 20)
    .widthIs(92)
    .heightIs(62);
    self.coverImageView.sd_cornerRadius = @4;
    
    self.typeBtn.sd_layout
    .bottomEqualToView(self.coverImageView)
    .rightEqualToView(self.coverImageView);
    self.typeBtn.sd_cornerRadius = @4;
    
    [self.typeBtn setupAutoSizeWithHorizontalPadding:6 buttonHeight:20];
    
    self.fenGeLine.sd_layout
    .leftSpaceToView(self.coverImageView, 20)
    .centerYEqualToView(self.coverImageView)
    .widthIs(1)
    .heightIs(50);
    
    
    self.keChengNameLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 12)
    .leftSpaceToView(self.fenGeLine, 20)
    .rightSpaceToView(self.bigBackgroundView, 10)
    .heightIs(20);
    
    self.shiYongTypeLabel.sd_layout
    .topSpaceToView(self.keChengNameLabel, 5)
    .leftEqualToView(self.keChengNameLabel)
    .rightEqualToView(self.keChengNameLabel)
    .heightIs(14);
    
    self.totalNumLabel.sd_layout
    .topSpaceToView(self.shiYongTypeLabel, 5)
    .leftEqualToView(self.keChengNameLabel)
    .rightEqualToView(self.keChengNameLabel)
    .heightIs(14);
    
    self.unfinishNumLabel.sd_layout
    .topSpaceToView(self.totalNumLabel, 5)
    .leftEqualToView(self.keChengNameLabel)
    .rightEqualToView(self.keChengNameLabel)
    .heightRatioToView(self.totalNumLabel, 1);
    
    self.teacherNameLabel.sd_layout
    .topSpaceToView(self.keChengNameLabel, 10)
    .leftEqualToView(self.keChengNameLabel)
    .rightEqualToView(self.keChengNameLabel)
    .heightIs(14);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.teacherNameLabel, 5)
    .leftEqualToView(self.keChengNameLabel)
    .rightEqualToView(self.keChengNameLabel)
    .heightRatioToView(self.totalNumLabel, 1);
    
    self.bottomLine.sd_layout
    .bottomEqualToView(self.bigBackgroundView)
    .leftSpaceToView(self.bigBackgroundView, 10)
    .rightSpaceToView(self.bigBackgroundView, 10)
    .heightIs(1);
    
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

-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.image = [UIImage imageNamed:@"kechengzhanwei_bg"];
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

-(UIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeBtn.backgroundColor = COLOR_WITH_ALPHA(0x000000, 0.4);
        _typeBtn.titleLabel.font = HXFont(12);
        [_typeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _typeBtn;
}

-(UIView *)fenGeLine{
    if (!_fenGeLine) {
        _fenGeLine = [[UIView alloc] init];
        _fenGeLine.backgroundColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
    }
    return _fenGeLine;
}


-(UILabel *)keChengNameLabel{
    if (!_keChengNameLabel) {
        _keChengNameLabel = [[UILabel alloc] init];
        _keChengNameLabel.textAlignment = NSTextAlignmentLeft;
        _keChengNameLabel.font = HXBoldFont(14);
        _keChengNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _keChengNameLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
       
    }
    return _keChengNameLabel;
}

-(UILabel *)shiYongTypeLabel{
    if (!_shiYongTypeLabel) {
        _shiYongTypeLabel = [[UILabel alloc] init];
        _shiYongTypeLabel.textAlignment = NSTextAlignmentLeft;
        _shiYongTypeLabel.font = HXFont(11);
        _shiYongTypeLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        
    }
    return _shiYongTypeLabel;
}

-(UILabel *)totalNumLabel{
    if (!_totalNumLabel) {
        _totalNumLabel = [[UILabel alloc] init];
        _totalNumLabel.textAlignment = NSTextAlignmentLeft;
        _totalNumLabel.font = HXFont(11);
        _totalNumLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        
    }
    return _totalNumLabel;
}

-(UILabel *)unfinishNumLabel{
    if (!_unfinishNumLabel) {
        _unfinishNumLabel = [[UILabel alloc] init];
        _unfinishNumLabel.textAlignment = NSTextAlignmentLeft;
        _unfinishNumLabel.font = HXFont(11);
        _unfinishNumLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        
    }
    return _unfinishNumLabel;
}

-(UILabel *)teacherNameLabel{
    if (!_teacherNameLabel) {
        _teacherNameLabel = [[UILabel alloc] init];
        _teacherNameLabel.textAlignment = NSTextAlignmentLeft;
        _teacherNameLabel.font = HXFont(11);
        _teacherNameLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _teacherNameLabel.hidden = YES;
    }
    return _teacherNameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = HXFont(11);
        _timeLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _timeLabel.hidden = YES;
    }
    return _timeLabel;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0xEBEBEB, 1);
    }
    return _bottomLine;
}

@end

