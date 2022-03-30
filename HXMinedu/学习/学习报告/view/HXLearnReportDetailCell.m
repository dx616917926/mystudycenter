//
//  HXLearnReportDetailCell.m
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXLearnReportDetailCell.h"
#import "HXGradientProgressView.h"

@interface HXLearnReportDetailCell ()

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *titleNameLabel;
@property(nonatomic,strong) UIButton *stateBtn;

@property(nonatomic,strong) HXGradientProgressView *gradientProgressView;
@property(nonatomic,strong) UILabel *finishNumLabel;
@property(nonatomic,strong) UIView *topLine;



@end

@implementation HXLearnReportDetailCell

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



#pragma mark - setter
-(void)setCellType:(HXLearnReportCellType)cellType{
    _cellType = cellType;
    
}

-(void)setLearnItemDetailModel:(HXLearnItemDetailModel *)learnItemDetailModel{
    
    _learnItemDetailModel = learnItemDetailModel;
    
    if (self.cellType == HXKeJianXueXiReportType) {
        self.iconImageView.image = [UIImage imageNamed:@"videolearn_icon"];
    }else if(self.cellType == HXPingShiZuoYeReportType) {
        self.iconImageView.image = [UIImage imageNamed:@"pszy_icon"];
    }else if(self.cellType == HXPingShiZuoYeReportType) {
        self.iconImageView.image = [UIImage imageNamed:@"qmks_icon"];
    }else if(self.cellType == HXPingShiZuoYeReportType) {
        self.iconImageView.image = [UIImage imageNamed:@"lnzt_icon"];
    }
    
    switch (self.cellType) {
        case HXKeJianXueXiReportType:
        {
            self.titleNameLabel.text =HXSafeString(learnItemDetailModel.catalogTitle);
            if (learnItemDetailModel.videoTime == 0) {
                self.gradientProgressView.progress = 0;
            }else{
                float progress = (self.learnItemDetailModel.accumulativeTime*1.0/self.learnItemDetailModel.videoTime);
                self.gradientProgressView.progress = (progress>1?1:progress);
            }
            if (self.gradientProgressView.progress ==1) {
                [self.stateBtn setTitle:@"已学完" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:COLOR_WITH_ALPHA(0x1A9E3B, 1) forState:UIControlStateNormal];
                [self.stateBtn setImage:[UIImage imageNamed:@"finishstate_icon"] forState:UIControlStateNormal];
                self.finishNumLabel.text = @"100%";
            }else if (self.gradientProgressView.progress==0) {
                [self.stateBtn setTitle:@"未学习" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:COLOR_WITH_ALPHA(0xDF4C3C, 1) forState:UIControlStateNormal];
                [self.stateBtn setImage:[UIImage imageNamed:@"nofinishstate_icon"] forState:UIControlStateNormal];
                self.finishNumLabel.text = @"0.0%";
            }else{
                [self.stateBtn setTitle:@"学习中" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:COLOR_WITH_ALPHA(0xFF7934, 1) forState:UIControlStateNormal];
                [self.stateBtn setImage:[UIImage imageNamed:@"xuexizhongstate_icon"] forState:UIControlStateNormal];
                self.finishNumLabel.text = [NSString stringWithFormat:@"%f",self.gradientProgressView.progress*100];
            }
            
        }
            break;
        case HXPingShiZuoYeReportType:
        case HXQiMoKaoShiReportType:
        case HXLiNianZhenTiReportType:
        {
            self.titleNameLabel.text =HXSafeString(learnItemDetailModel.examName);
    
            if (self.learnItemDetailModel.state == 1) {
                [self.stateBtn setTitle:@"已完成" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:COLOR_WITH_ALPHA(0x1A9E3B, 1) forState:UIControlStateNormal];
                [self.stateBtn setImage:[UIImage imageNamed:@"finishstate_icon"] forState:UIControlStateNormal];
                self.finishNumLabel.text = [NSString stringWithFormat:@"%@",self.learnItemDetailModel.score];
                self.gradientProgressView.progress = 1;
            }else if (self.learnItemDetailModel.state == 0) {
                [self.stateBtn setTitle:@"未完成" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:COLOR_WITH_ALPHA(0xDF4C3C, 1) forState:UIControlStateNormal];
                [self.stateBtn setImage:[UIImage imageNamed:@"nofinishstate_icon"] forState:UIControlStateNormal];
                self.finishNumLabel.text = @"";
                self.gradientProgressView.progress = 0;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UI
-(void)createUI{
    
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleNameLabel];
    [self.contentView addSubview:self.finishNumLabel];
    [self.contentView addSubview:self.gradientProgressView];
    [self.contentView addSubview:self.stateBtn];
    
    
    self.topLine.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .topEqualToView(self.contentView)
    .heightIs(1);
    
    self.iconImageView.sd_layout
    .topSpaceToView(self.contentView, 25)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(12)
    .heightEqualToWidth();
    
    self.titleNameLabel.sd_layout
    .centerYEqualToView(self.iconImageView)
    .leftSpaceToView(self.iconImageView, 5)
    .heightIs(21);
    [self.titleNameLabel setSingleLineAutoResizeWithMaxWidth:_kpw(230)];
    
    self.finishNumLabel.sd_layout
    .centerYEqualToView(self.titleNameLabel)
    .leftSpaceToView(self.titleNameLabel, 20)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(21);
    
    
    self.gradientProgressView.sd_layout
    .topSpaceToView(self.titleNameLabel, 13)
    .leftEqualToView(self.iconImageView)
    .widthIs(_kpw(250))
    .heightIs(14);
    [self.gradientProgressView updateLayout];
    
    self.stateBtn.sd_layout
    .centerYEqualToView(self.gradientProgressView)
    .leftSpaceToView(self.gradientProgressView, 15)
    .rightEqualToView(self.finishNumLabel)
    .heightIs(15);
    
    self.stateBtn.titleLabel.sd_layout
    .centerYEqualToView(self.stateBtn)
    .rightEqualToView(self.stateBtn)
    .heightIs(15);
    [self.stateBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:_kpw(60)];

    self.stateBtn.imageView.sd_layout
    .centerYEqualToView(self.stateBtn)
    .rightSpaceToView(self.stateBtn.titleLabel, 5)
    .heightIs(15)
    .widthEqualToHeight();
    
    
}


#pragma mark - LazyLoad

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

-(UILabel *)titleNameLabel{
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.textColor = COLOR_WITH_ALPHA(0x5A5A5A, 1);
        _titleNameLabel.font = HXFont(16);
        _titleNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleNameLabel;
}

-(HXGradientProgressView *)gradientProgressView{
    if (!_gradientProgressView) {
        _gradientProgressView = [[HXGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, _kpw(250), 14)];
        _gradientProgressView.bgProgressColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
        _gradientProgressView.colorArr = @[COLOR_WITH_ALPHA(0x3EADFF, 1),COLOR_WITH_ALPHA(0x15E88D, 1)];
        _gradientProgressView.progress = 0;
    }
    return _gradientProgressView;
}

- (UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stateBtn.titleLabel.font = HXFont(10);
        _stateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_stateBtn setTitleColor:COLOR_WITH_ALPHA(0x1A9E3B, 1) forState:UIControlStateNormal];
    }
    return _stateBtn;
}


-(UILabel *)finishNumLabel{
    if (!_finishNumLabel) {
        _finishNumLabel = [[UILabel alloc] init];
        _finishNumLabel.textColor = COLOR_WITH_ALPHA(0x5A5A5A, 1);
        _finishNumLabel.font = HXFont(16);
        _finishNumLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _finishNumLabel;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = COLOR_WITH_ALPHA(0xF2F2F2, 1);
    }
    return _topLine;
}

@end


