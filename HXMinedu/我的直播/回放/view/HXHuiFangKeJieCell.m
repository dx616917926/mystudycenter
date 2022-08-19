//
//  HXHuiFangKeJieCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXHuiFangKeJieCell.h"

@interface HXHuiFangKeJieCell ()

@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *riQiLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIView *fenGeLine;
@property(nonatomic,strong) UILabel *keJieNameLabel;
@property(nonatomic,strong) UILabel *teacherLabel;
@property(nonatomic,strong) UIButton *dianPingButton;
@property(nonatomic,strong) UIButton *huiFangButton;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXHuiFangKeJieCell

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

- (void)setKeJieModel:(HXKeJieModel *)keJieModel{
    
    _keJieModel = keJieModel;
    
    self.riQiLabel.text = HXSafeString(keJieModel.ClassBeginDate);
    self.timeLabel.text = HXSafeString(keJieModel.ClassBeginTime);
    self.keJieNameLabel.text = HXSafeString(keJieModel.ClassName);
    self.teacherLabel.text = [NSString stringWithFormat:@"授课教师：%@",HXSafeString(keJieModel.TeacherName)];
    
    if (keJieModel.IsEvaluate==1) {
        [self.dianPingButton setImage:[UIImage imageNamed:@"checkdianping_icon"] forState:UIControlStateNormal];
    }else{
        [self.dianPingButton setImage:[UIImage imageNamed:@"dianping_icon"] forState:UIControlStateNormal];
    }
}


#pragma mark - Event
-(void)dianPing:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(dianPingWithModel:)]){
        [self.delegate dianPingWithModel:self.keJieModel];
    }
}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.riQiLabel];
    [self.bigBackgroundView addSubview:self.timeLabel];
    [self.bigBackgroundView addSubview:self.fenGeLine];
    [self.bigBackgroundView addSubview:self.keJieNameLabel];
    [self.bigBackgroundView addSubview:self.teacherLabel];
    [self.bigBackgroundView addSubview:self.dianPingButton];
    [self.bigBackgroundView addSubview:self.huiFangButton];
    [self.bigBackgroundView addSubview:self.bottomLine];
    

    self.bigBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    

    self.fenGeLine.sd_layout
    .leftSpaceToView(self.bigBackgroundView, 75)
    .centerYEqualToView(self.bigBackgroundView)
    .widthIs(1)
    .heightIs(50);
    
    self.riQiLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 18)
    .leftSpaceToView(self.bigBackgroundView, 10)
    .rightSpaceToView(self.fenGeLine, 0)
    .heightIs(20);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.riQiLabel, 8)
    .leftEqualToView(self.riQiLabel)
    .rightEqualToView(self.riQiLabel)
    .heightIs(14);
    
    
    self.dianPingButton.sd_layout
    .topSpaceToView(self.bigBackgroundView, 10)
    .rightSpaceToView(self.bigBackgroundView, 10)
    .widthIs(45)
    .heightIs(20);
    
    self.huiFangButton.sd_layout
    .topSpaceToView(self.dianPingButton, 5)
    .centerXEqualToView(self.dianPingButton)
    .widthRatioToView(self.dianPingButton, 1)
    .heightRatioToView(self.dianPingButton, 1);
    
    
    self.keJieNameLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 18)
    .leftSpaceToView(self.fenGeLine, 6)
    .rightSpaceToView(self.dianPingButton, 10)
    .heightIs(20);
    
    self.teacherLabel.sd_layout
    .topSpaceToView(self.keJieNameLabel, 6)
    .leftEqualToView(self.keJieNameLabel)
    .rightEqualToView(self.keJieNameLabel)
    .heightIs(14);
 
    
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

-(UILabel *)riQiLabel{
    if (!_riQiLabel) {
        _riQiLabel = [[UILabel alloc] init];
        _riQiLabel.textAlignment = NSTextAlignmentCenter;
        _riQiLabel.font = HXFont(14);
        _riQiLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        
    }
    return _riQiLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = HXFont(11);
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _timeLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        
    }
    return _timeLabel;
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

-(UIButton *)dianPingButton{
    if (!_dianPingButton) {
        _dianPingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dianPingButton addTarget:self action:@selector(dianPing:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianPingButton;
}

-(UIButton *)huiFangButton{
    if (!_huiFangButton) {
        _huiFangButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_huiFangButton setImage:[UIImage imageNamed:@"huifangsamll_icon"] forState:UIControlStateNormal];
    }
    return _huiFangButton;
}


-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0xEBEBEB, 1);
    }
    return _bottomLine;
}

@end


