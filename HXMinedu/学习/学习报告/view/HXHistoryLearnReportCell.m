//
//  HXHistoryLearnReportCell.m
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXHistoryLearnReportCell.h"
#import "HXGradientProgressView.h"

@interface HXHistoryLearnReportCell ()

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *titleNameLabel;
@property(nonatomic,strong) UIButton *totalNumBtn;
@property(nonatomic,strong) UILabel *ciShuLabel;
@property(nonatomic,strong) UILabel *dengJiLabel;


@property(nonatomic,strong) HXGradientProgressView *gradientProgressView;
@property(nonatomic,strong) UILabel *finishNumLabel;
@property(nonatomic,strong) UIView *bottonLine;



@end

@implementation HXHistoryLearnReportCell

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
    switch (cellType) {
        case HXKeJianXueXiReportType:
        {
            self.iconImageView.image = [UIImage imageNamed:@"historyvideolearn_icon"];
            [self.totalNumBtn setTitle:@"共30章" forState:UIControlStateNormal];
            self.ciShuLabel.text = @"学习次数：10";
            self.dengJiLabel.text = @"精品";
            self.finishNumLabel.text = @"已学习66章";
        }
            break;
        case HXPingShiZuoYeReportType:
       
        {
            self.iconImageView.image = [UIImage imageNamed:@"historypszy_icon"];
            [self.totalNumBtn setTitle:@"共10套" forState:UIControlStateNormal];
            self.ciShuLabel.text = @"练习次数：5";
            self.dengJiLabel.text = nil;
            self.finishNumLabel.text = @"已完成2套";
        }

            break;
        case HXQiMoKaoShiReportType:
       
        {
            self.iconImageView.image = [UIImage imageNamed:@"historyqmks_icon"];
            [self.totalNumBtn setTitle:@"共10套" forState:UIControlStateNormal];
            self.ciShuLabel.text = @"考试次数：5";
            self.dengJiLabel.text = nil;
            self.finishNumLabel.text = @"已完成2套";
        }

            break;
        case HXLiNianZhenTiReportType:
       
        {
            self.iconImageView.image = [UIImage imageNamed:@"historylnzt_icon"];
            [self.totalNumBtn setTitle:@"共10套" forState:UIControlStateNormal];
            self.ciShuLabel.text = @"练习次数：5";
            self.dengJiLabel.text = nil;
            self.finishNumLabel.text = @"已完成2套";
        }

            break;
        default:
            break;
    }
}

#pragma mark - UI
-(void)createUI{
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleNameLabel];
    [self.contentView addSubview:self.totalNumBtn];
    [self.contentView addSubview:self.ciShuLabel];
    [self.contentView addSubview:self.dengJiLabel];
    [self.contentView addSubview:self.gradientProgressView];
    [self.contentView addSubview:self.finishNumLabel];
    [self.contentView addSubview:self.bottonLine];
    
    self.iconImageView.sd_layout
    .topSpaceToView(self.contentView, 25)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(12)
    .heightEqualToWidth();
    
    self.titleNameLabel.sd_layout
    .centerYEqualToView(self.iconImageView)
    .leftSpaceToView(self.iconImageView, 5)
    .heightIs(21);
    [self.titleNameLabel setSingleLineAutoResizeWithMaxWidth:_kpw(130)];
    
    self.totalNumBtn.sd_layout
    .centerYEqualToView(self.titleNameLabel)
    .leftSpaceToView(self.titleNameLabel, 15);
    [self.totalNumBtn setupAutoSizeWithHorizontalPadding:9 buttonHeight:20];
    self.totalNumBtn.sd_cornerRadiusFromHeightRatio =@0.5;
    
    self.ciShuLabel.sd_layout
    .centerYEqualToView(self.titleNameLabel)
    .leftSpaceToView(self.totalNumBtn, 10)
    .heightIs(14);
    [self.ciShuLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.dengJiLabel.sd_layout
    .centerYEqualToView(self.titleNameLabel)
    .leftSpaceToView(self.ciShuLabel, 10)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(16);
    
    self.gradientProgressView.sd_layout
    .topSpaceToView(self.titleNameLabel, 13)
    .leftEqualToView(self.iconImageView)
    .widthIs(_kpw(250))
    .heightIs(14);
    [self.gradientProgressView updateLayout];
    
    self.finishNumLabel.sd_layout
    .centerYEqualToView(self.gradientProgressView)
    .leftSpaceToView(self.gradientProgressView, 20)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(14);

    self.bottonLine.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
    
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
        _titleNameLabel.text = @"国际财务管理";
    }
    return _titleNameLabel;
}

-(HXGradientProgressView *)gradientProgressView{
    if (!_gradientProgressView) {
        _gradientProgressView = [[HXGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, _kpw(250), 14)];
        _gradientProgressView.bgProgressColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
        _gradientProgressView.colorArr = @[COLOR_WITH_ALPHA(0xFE955F, 1),COLOR_WITH_ALPHA(0xFFBE68, 1)];
    }
    return _gradientProgressView;
}

- (UIButton *)totalNumBtn{
    if (!_totalNumBtn) {
        _totalNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _totalNumBtn.titleLabel.font = HXFont(10);
        _totalNumBtn.backgroundColor = COLOR_WITH_ALPHA(0xFFF7E8, 1);
        [_totalNumBtn setTitleColor:COLOR_WITH_ALPHA(0xFF7934, 1) forState:UIControlStateNormal];
        
    }
    return _totalNumBtn;
}

-(UILabel *)ciShuLabel{
    if (!_ciShuLabel) {
        _ciShuLabel = [[UILabel alloc] init];
        _ciShuLabel.textColor = COLOR_WITH_ALPHA(0x858585, 1);
        _ciShuLabel.font = HXFont(10);
        _ciShuLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _ciShuLabel;
}

-(UILabel *)dengJiLabel{
    if (!_dengJiLabel) {
        _dengJiLabel = [[UILabel alloc] init];
        _dengJiLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _dengJiLabel.font = HXFont(12);
        _dengJiLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _dengJiLabel;
}

-(UILabel *)finishNumLabel{
    if (!_finishNumLabel) {
        _finishNumLabel = [[UILabel alloc] init];
        _finishNumLabel.textColor = COLOR_WITH_ALPHA(0x858585, 1);
        _finishNumLabel.font = HXFont(10);
        _finishNumLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _finishNumLabel;
}

- (UIView *)bottonLine{
    if (!_bottonLine) {
        _bottonLine = [[UIView alloc] init];
        _bottonLine.backgroundColor = COLOR_WITH_ALPHA(0xF2F2F2, 1);
    }
    return _bottonLine;
}

@end

