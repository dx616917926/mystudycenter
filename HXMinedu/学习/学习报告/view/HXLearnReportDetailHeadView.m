//
//  HXLearnReportDetailHeadView.m
//  HXMinedu
//
//  Created by mac on 2022/3/25.
//

#import "HXLearnReportDetailHeadView.h"
#import "HXGradientProgressView.h"

@interface HXLearnReportDetailHeadView ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *titleNameLabel;
@property(nonatomic,strong) UIButton *totalNumBtn;
@property(nonatomic,strong) UILabel *ciShuLabel;
@property(nonatomic,strong) UILabel *dengJiLabel;


@property(nonatomic,strong) HXGradientProgressView *gradientProgressView;
@property(nonatomic,strong) UILabel *finishNumLabel;


@end

@implementation HXLearnReportDetailHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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
            self.iconImageView.image = [UIImage imageNamed:@"videolearn_icon"];
            [self.totalNumBtn setTitle:@"共30章" forState:UIControlStateNormal];
            self.ciShuLabel.text = @"学习次数：10";
            self.dengJiLabel.text = @"精品";
            self.finishNumLabel.text = @"已学习66章";
        }
            break;
        case HXPingShiZuoYeReportType:
       
        {
            self.iconImageView.image = [UIImage imageNamed:@"pszy_icon"];
            [self.totalNumBtn setTitle:@"共10套" forState:UIControlStateNormal];
            self.ciShuLabel.text = @"练习次数：5";
            self.dengJiLabel.text = nil;
            self.finishNumLabel.text = @"已完成2套";
        }

            break;
        case HXQiMoKaoShiReportType:
       
        {
            self.iconImageView.image = [UIImage imageNamed:@"qmks_icon"];
            [self.totalNumBtn setTitle:@"共10套" forState:UIControlStateNormal];
            self.ciShuLabel.text = @"考试次数：5";
            self.dengJiLabel.text = nil;
            self.finishNumLabel.text = @"已完成2套";
        }

            break;
        case HXLiNianZhenTiReportType:
       
        {
            self.iconImageView.image = [UIImage imageNamed:@"lnzt_icon"];
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
    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.iconImageView];
    [self.bigBackgroundView addSubview:self.titleNameLabel];
    [self.bigBackgroundView addSubview:self.totalNumBtn];
    [self.bigBackgroundView addSubview:self.ciShuLabel];
    [self.bigBackgroundView addSubview:self.dengJiLabel];
    [self.bigBackgroundView addSubview:self.gradientProgressView];
    [self.bigBackgroundView addSubview:self.finishNumLabel];
    
    self.shadowBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(20, 12, 20, 12));
    self.shadowBackgroundView.layer.cornerRadius = 8;
    
    self.bigBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(20, 12, 20, 12));
    self.bigBackgroundView.sd_cornerRadius = @8;
    
    self.iconImageView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 25)
    .leftSpaceToView(self.bigBackgroundView, 13)
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
    .rightSpaceToView(self.bigBackgroundView, 13)
    .heightIs(16);
    
    self.gradientProgressView.sd_layout
    .topSpaceToView(self.titleNameLabel, 13)
    .leftEqualToView(self.iconImageView)
    .widthIs(_kpw(250))
    .heightIs(14);
    [self.gradientProgressView updateLayout];
    
    self.finishNumLabel.sd_layout
    .centerYEqualToView(self.gradientProgressView)
    .leftSpaceToView(self.gradientProgressView, 13)
    .rightSpaceToView(self.bigBackgroundView, 13)
    .heightIs(14);

}


#pragma mark - LazyLoad
-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowBackgroundView.layer.shadowRadius = 6;
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
        _titleNameLabel.text = @"中国近代史纲要";
    }
    return _titleNameLabel;
}

-(HXGradientProgressView *)gradientProgressView{
    if (!_gradientProgressView) {
        _gradientProgressView = [[HXGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, _kpw(250), 14)];
        _gradientProgressView.bgProgressColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
        _gradientProgressView.colorArr = @[COLOR_WITH_ALPHA(0x3EADFF, 1),COLOR_WITH_ALPHA(0x15E88D, 1)];
    }
    return _gradientProgressView;
}

- (UIButton *)totalNumBtn{
    if (!_totalNumBtn) {
        _totalNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _totalNumBtn.titleLabel.font = HXFont(10);
        _totalNumBtn.backgroundColor = COLOR_WITH_ALPHA(0xE8F1FF, 1);
        [_totalNumBtn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
        
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



@end

