//
//  HXRiLiKeJieCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/12.
//

#import "HXRiLiKeJieCell.h"

@interface HXRiLiKeJieCell ()

@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *beginTimeLabel;
@property(nonatomic,strong) UILabel *shiChangLabel;
@property(nonatomic,strong) UIView *fenGeLine;
@property(nonatomic,strong) UILabel *keJieNameLabel;
@property(nonatomic,strong) UILabel *teacherLabel;
@property(nonatomic,strong) UIButton *huiFangButton;
@property(nonatomic,strong) UIButton *goLearnButton;
@property(nonatomic,strong) UIButton *zhiBoButton;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXRiLiKeJieCell

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
-(void)setKeJieModel:(HXKeJieModel *)keJieModel{
    
    _keJieModel = keJieModel;
    self.huiFangButton.hidden = self.goLearnButton.hidden = self.zhiBoButton.hidden = YES;
    self.beginTimeLabel.text = HXSafeString(keJieModel.ClassBeginTime);
    self.teacherLabel.text = [NSString stringWithFormat:@"授课教师：%@",HXSafeString(keJieModel.TeacherName)];
    self.keJieNameLabel.text = HXSafeString(keJieModel.ClassName);
    if (keJieModel.LiveType==1) {
        self.beginTimeLabel.sd_layout.centerYEqualToView(self.bigBackgroundView).offset(-12);
        self.shiChangLabel.text = [HXSafeString(keJieModel.ClassTimeSpan) stringByAppendingString:@"分钟"];
    }else{
        self.beginTimeLabel.sd_layout.centerYEqualToView(self.bigBackgroundView).offset(0);
        self.shiChangLabel.text = nil;
    }
    ///直播状态 0待开始  1直播中  2已结束
    if (keJieModel.LiveState==1) {
        self.zhiBoButton.hidden = NO;
    }else if (keJieModel.LiveState==2) {
        self.huiFangButton.hidden = NO;
    }else{
        self.goLearnButton.hidden =NO;
    }
    
}

#pragma mark - Event



#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.beginTimeLabel];
    [self.bigBackgroundView addSubview:self.shiChangLabel];
    [self.bigBackgroundView addSubview:self.fenGeLine];
    [self.bigBackgroundView addSubview:self.keJieNameLabel];
    [self.bigBackgroundView addSubview:self.teacherLabel];
    [self.bigBackgroundView addSubview:self.huiFangButton];
    [self.bigBackgroundView addSubview:self.goLearnButton];
    [self.bigBackgroundView addSubview:self.zhiBoButton];
    [self.bigBackgroundView addSubview:self.bottomLine];
    

    self.bigBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    

    self.fenGeLine.sd_layout
    .leftSpaceToView(self.bigBackgroundView, 87)
    .centerYEqualToView(self.bigBackgroundView)
    .widthIs(1)
    .heightIs(54);
    
    self.beginTimeLabel.sd_layout
    .centerYEqualToView(self.bigBackgroundView).offset(-12)
    .leftSpaceToView(self.bigBackgroundView, 10)
    .rightSpaceToView(self.fenGeLine, 0)
    .heightIs(22);
    
    self.shiChangLabel.sd_layout
    .topSpaceToView(self.beginTimeLabel, 3)
    .leftEqualToView(self.beginTimeLabel)
    .rightEqualToView(self.beginTimeLabel)
    .heightIs(15);
    
    
    self.huiFangButton.sd_layout
    .centerYEqualToView(self.bigBackgroundView)
    .rightSpaceToView(self.bigBackgroundView, 25)
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
    
    
    self.keJieNameLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 15)
    .leftSpaceToView(self.fenGeLine, 20)
    .rightSpaceToView(self.huiFangButton, 10)
    .autoHeightRatio(0);
    [self.keJieNameLabel setMaxNumberOfLinesToShow:2];
    
    self.teacherLabel.sd_layout
    .topSpaceToView(self.keJieNameLabel, 6)
    .leftEqualToView(self.keJieNameLabel)
    .rightEqualToView(self.keJieNameLabel)
    .heightIs(14);
 
    
    self.bottomLine.sd_layout
    .bottomEqualToView(self.bigBackgroundView)
    .leftSpaceToView(self.bigBackgroundView, 12)
    .rightSpaceToView(self.bigBackgroundView, 12)
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

-(UILabel *)beginTimeLabel{
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc] init];
        _beginTimeLabel.textAlignment = NSTextAlignmentCenter;
        _beginTimeLabel.font = HXFont(14);
        _beginTimeLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        
    }
    return _beginTimeLabel;
}

-(UILabel *)shiChangLabel{
    if (!_shiChangLabel) {
        _shiChangLabel = [[UILabel alloc] init];
        _shiChangLabel.textAlignment = NSTextAlignmentCenter;
        _shiChangLabel.font = HXFont(11);
        _shiChangLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _shiChangLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        
    }
    return _shiChangLabel;
}

-(UIView *)fenGeLine{
    if (!_fenGeLine) {
        _fenGeLine = [[UIView alloc] init];
        _fenGeLine.backgroundColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
    }
    return _fenGeLine;
}


-(UILabel *)keJieNameLabel{
    if (!_keJieNameLabel) {
        _keJieNameLabel = [[UILabel alloc] init];
        _keJieNameLabel.textAlignment = NSTextAlignmentLeft;
        _keJieNameLabel.font = HXBoldFont(14);
        _keJieNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _keJieNameLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _keJieNameLabel.numberOfLines = 0;
    }
    return _keJieNameLabel;
}

-(UILabel *)teacherLabel{
    if (!_teacherLabel) {
        _teacherLabel = [[UILabel alloc] init];
        _teacherLabel.textAlignment = NSTextAlignmentLeft;
        _teacherLabel.font = HXFont(11);
        _teacherLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        
    }
    return _teacherLabel;
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

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0xEBEBEB, 1);
    }
    return _bottomLine;
}

@end


