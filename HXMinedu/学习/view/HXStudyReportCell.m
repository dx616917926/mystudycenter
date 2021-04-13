//
//  HXStudyReportCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/7.
//

#import "HXStudyReportCell.h"
#import "HXGradientProgressView.h"

@interface HXStudyReportCell ()

@property(nonatomic,strong) UIView *bigBackGroundView;
@property(nonatomic,strong) UILabel *courseLabel;
@property(nonatomic,strong) UILabel *detailLabel;

@property(nonatomic,strong) HXGradientProgressView *gradientProgressView;


@property(nonatomic,strong) UILabel *learnTimeLabel;//已经学习时间
@property(nonatomic,strong) UIButton *deFenBtn;//得分
@property(nonatomic,strong) UILabel *totalLabel;//总分/总题数/总分


@end

@implementation HXStudyReportCell

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
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}
#pragma mark - setter
-(void)setCourseDetailModel:(HXCourseDetailModel *)courseDetailModel{
    _courseDetailModel = courseDetailModel;
    self.courseLabel.text = HXSafeString(courseDetailModel.courseName);
    courseDetailModel.yzTopic = 2;
    courseDetailModel.wzTopic = 8;
    courseDetailModel.learnTime = 120;
    courseDetailModel.learnDuration = 1 + arc4random()%120;
    courseDetailModel.totalScore = 100;
    courseDetailModel.score = [NSString stringWithFormat:@"%u",(1 + arc4random()%100)];
    
    if (self.cellType == HXKeJianXueXiType) {
        self.totalLabel.text = [NSString stringWithFormat:@"%ld分钟",courseDetailModel.learnTime];
        NSString *needStr = [NSString stringWithFormat:@"%ld",courseDetailModel.learnDuration];
        NSString *content = [NSString stringWithFormat:@"已学 %ld 分钟",courseDetailModel.learnDuration];
        self.learnTimeLabel.attributedText = [HXCommonUtil getAttributedStringWith:needStr needAttributed:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0x5699FF, 1)} content:content defaultAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xAFAFAF, 1)}];
        self.gradientProgressView.progress = (courseDetailModel.learnDuration*1.0/courseDetailModel.learnTime);
    }else if (self.cellType == HXZhiShiDianPingType) {
        NSString *score = [NSString stringWithFormat:@"%ld分",(courseDetailModel.totalScore * courseDetailModel.yzTopic)];
        [self.deFenBtn setTitle:score forState:UIControlStateNormal];
        self.totalLabel.text = [NSString stringWithFormat:@"%ld题",(courseDetailModel.yzTopic + courseDetailModel.wzTopic)];
        self.gradientProgressView.progress = (courseDetailModel.yzTopic*1.0/(courseDetailModel.yzTopic+courseDetailModel.wzTopic));
    }else if (self.cellType == HXPingShiZuoYeType) {
        [self.deFenBtn setTitle:[HXSafeString(courseDetailModel.score) stringByAppendingString:@"分"] forState:UIControlStateNormal];
        self.totalLabel.text = [NSString stringWithFormat:@"%ld分",(courseDetailModel.totalScore)];
        self.gradientProgressView.progress = ([courseDetailModel.score integerValue]*1.0/courseDetailModel.totalScore);
    }
    
}


-(void)setCellType:(HXStudyReportCellType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case HXKeJianXueXiType:
        {
            self.learnTimeLabel.hidden = NO;
            self.deFenBtn.hidden = YES;
            self.gradientProgressView.bgProgressColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
            self.gradientProgressView.colorArr = @[COLOR_WITH_ALPHA(0x4BA4FE, 1) , COLOR_WITH_ALPHA(0x45EFCF, 1)];
        }
            break;
        case HXZhiShiDianPingType:
        case HXPingShiZuoYeType:
        {
            self.deFenBtn.hidden  = NO;
            self.learnTimeLabel.hidden = YES;
            self.gradientProgressView.bgProgressColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
            self.gradientProgressView.colorArr = @[COLOR_WITH_ALPHA(0x54C872, 1),COLOR_WITH_ALPHA(0x54C872, 1)];
        }
            
            break;
        default:
            break;
    }
}

-(void)setCornerRadiusType:(HXCornerRadiusType)cornerRadiusType{
    _cornerRadiusType = cornerRadiusType;
    [self.bigBackGroundView updateLayout];
    switch (cornerRadiusType) {
        case HXNoneCornerRadiusType:
        {
            self.bigBackGroundView.layer.mask = [self getMaskLayerWithRoundedRect:self.bigBackGroundView.bounds byroundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0 ,0)];
        }
            break;
        case HXTopCornerRadiusType:
        {
            self.bigBackGroundView.layer.mask = [self getMaskLayerWithRoundedRect:self.bigBackGroundView.bounds byroundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8 ,8)];
        }
            break;
        case HXBottomCornerRadiusType:
        {
            
            self.bigBackGroundView.layer.mask = [self getMaskLayerWithRoundedRect:self.bigBackGroundView.bounds byroundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(8 ,8)];
            
        }
            break;
        case HXBothCornerRadiusType:
        {
           
            self.bigBackGroundView.layer.mask = [self getMaskLayerWithRoundedRect:self.bigBackGroundView.bounds byroundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8 ,8)];
           
        }
            break;
            
        default:
            break;
    }
    [self.bigBackGroundView updateLayout];
    
}

-(CALayer *)getMaskLayerWithRoundedRect:(CGRect)rect byroundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

#pragma mark - UI
-(void)createUI{
    
    [self addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.courseLabel];
    [self.bigBackGroundView addSubview:self.learnTimeLabel];
    [self.bigBackGroundView addSubview:self.deFenBtn];
    [self.bigBackGroundView addSubview:self.totalLabel];
    [self.bigBackGroundView addSubview:self.gradientProgressView];

    
    self.bigBackGroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 15));
//    self.bigBackGroundView.layer.cornerRadius = 8;
    
    self.courseLabel.sd_layout
    .topSpaceToView(self.bigBackGroundView, 18)
    .leftSpaceToView(self.bigBackGroundView, _kpw(30))
    .heightIs(22);
    [self.courseLabel setSingleLineAutoResizeWithMaxWidth:_kpw(160)];
    
    
    
    self.gradientProgressView.sd_layout
    .topSpaceToView(self.courseLabel, 10)
    .leftEqualToView(self.courseLabel)
    .widthIs(_kpw(250))
    .heightIs(18);
    [self.gradientProgressView updateLayout];
    
    self.learnTimeLabel.sd_layout
    .bottomEqualToView(self.courseLabel)
    .leftSpaceToView(self.courseLabel, 5)
    .rightEqualToView(self.gradientProgressView)
    .heightIs(20);
    
    
    self.totalLabel.sd_layout
    .centerYEqualToView(self.gradientProgressView)
    .leftSpaceToView(self.gradientProgressView, 5)
    .rightSpaceToView(self.bigBackGroundView, 5)
    .heightIs(14);
    
    
    self.deFenBtn.sd_layout
    .centerYEqualToView(self.courseLabel)
    .rightEqualToView(self.gradientProgressView);
    [self.deFenBtn setupAutoSizeWithHorizontalPadding:8 buttonHeight:18];
    self.deFenBtn.sd_cornerRadiusFromHeightRatio = @0.5;

    
}

-(UIView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIView alloc] init];
        _bigBackGroundView.backgroundColor = [UIColor whiteColor];
//        _bigBackGroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.10).CGColor;
//        _bigBackGroundView.layer.shadowOffset = CGSizeMake(0, 2);
//        _bigBackGroundView.layer.shadowRadius = 4;
//        _bigBackGroundView.layer.shadowOpacity = 0.5;
    }
    return _bigBackGroundView;;
}

-(HXGradientProgressView *)gradientProgressView{
    if (!_gradientProgressView) {
        _gradientProgressView = [[HXGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, _kpw(250), 18)];
        _gradientProgressView.bgProgressColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
    }
    return _gradientProgressView;
}

-(UILabel *)courseLabel{
    if (!_courseLabel) {
        _courseLabel = [[UILabel alloc] init];
        _courseLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _courseLabel.font = HXFont(16);
        _courseLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _courseLabel;
}

- (UIButton *)deFenBtn{
    if (!_deFenBtn) {
        _deFenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deFenBtn.hidden = YES;
        _deFenBtn.titleLabel.font = HXFont(10);
        _deFenBtn.backgroundColor = COLOR_WITH_ALPHA(0x54C872, 1);
        [_deFenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _deFenBtn;
}

-(UILabel *)learnTimeLabel{
    if (!_learnTimeLabel) {
        _learnTimeLabel = [[UILabel alloc] init];
        _learnTimeLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _learnTimeLabel.font = HXFont(10);
        _learnTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _learnTimeLabel;
}

-(UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _totalLabel.font = HXFont(10);
        _totalLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _totalLabel;
}




@end
