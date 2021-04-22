//
//  HXStudyCourseCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/19.
//

#import "HXStudyCourseCell.h"
#import "HXGradientProgressView.h"

@interface HXStudyCourseCell ()

@property(nonatomic,strong) UIView *bigBackGroundView;
@property(nonatomic,strong) UILabel *courseLabel;
@property(nonatomic,strong) UIImageView *courseImageView;
@property(nonatomic,strong) UIImageView *crownImageView;
@property(nonatomic,strong) UIImageView *rectangleImageView;
@property(nonatomic,strong) UILabel *jingpinLabel;
@property(nonatomic,strong) UILabel *learnTimeLabel;

@property(nonatomic,strong) HXGradientProgressView *gradientProgressView;



@end

@implementation HXStudyCourseCell

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

#pragma mark - UI
-(void)createUI{
    
    [self addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.courseImageView];
    [self.bigBackGroundView addSubview:self.courseLabel];
    [self.bigBackGroundView addSubview:self.learnTimeLabel];
    [self.bigBackGroundView addSubview:self.rectangleImageView];
    [self.bigBackGroundView addSubview:self.crownImageView];
    [self.rectangleImageView addSubview:self.jingpinLabel];
    [self.bigBackGroundView addSubview:self.learnTimeLabel];
    [self.bigBackGroundView addSubview:self.gradientProgressView];

    
    self.bigBackGroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, _kpw(23), 5, _kpw(23)));
    self.bigBackGroundView.layer.cornerRadius = 8;
    
    self.courseImageView.sd_layout
    .topSpaceToView(self.bigBackGroundView, 20)
    .leftSpaceToView(self.bigBackGroundView, 20)
    .widthIs(_kpw(130))
    .heightIs(_kpw(83));
    self.courseImageView.sd_cornerRadius = @4;
    
    self.courseLabel.sd_layout
    .topEqualToView(self.courseImageView)
    .leftSpaceToView(self.courseImageView, 24)
    .rightSpaceToView(self.bigBackGroundView, 24)
    .heightIs(22);
    
    self.crownImageView.sd_layout
    .topSpaceToView(self.courseLabel, 2)
    .leftSpaceToView(self.courseImageView, 15)
    .widthIs(20)
    .heightIs(20);
    
    self.rectangleImageView.sd_layout
    .topSpaceToView(self.courseLabel, 14)
    .leftSpaceToView(self.courseImageView, 24)
    .widthIs(102)
    .heightIs(23);
    
    self.jingpinLabel.sd_layout
    .centerYEqualToView(self.rectangleImageView)
    .leftSpaceToView(self.rectangleImageView, 5)
    .rightSpaceToView(self.rectangleImageView, 5)
    .heightIs(17);
    
    self.learnTimeLabel.sd_layout
    .bottomEqualToView(self.courseImageView)
    .leftEqualToView(self.courseLabel)
    .rightEqualToView(self.courseLabel)
    .heightIs(17);
    
    
    self.gradientProgressView.sd_layout
    .topSpaceToView(self.courseImageView, 13)
    .leftEqualToView(self.courseImageView);
    [self.gradientProgressView updateLayout];
    
    
    
}

-(UIView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIView alloc] init];
        _bigBackGroundView.backgroundColor = [UIColor whiteColor];
        _bigBackGroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bigBackGroundView.layer.shadowOffset = CGSizeMake(0, 2);
        _bigBackGroundView.layer.shadowRadius = 4;
        _bigBackGroundView.layer.shadowOpacity = 1;
    }
    return _bigBackGroundView;;
}

-(UIImageView *)courseImageView{
    if (!_courseImageView) {
        _courseImageView = [[UIImageView alloc] init];
        _courseImageView.backgroundColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _courseImageView.clipsToBounds = YES;
        _courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _courseImageView;;
}


-(UILabel *)courseLabel{
    if (!_courseLabel) {
        _courseLabel = [[UILabel alloc] init];
        _courseLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _courseLabel.font = HXFont(16);
        _courseLabel.textAlignment = NSTextAlignmentLeft;
        _courseLabel.text = @"毛泽东思想邓小平理论和三个代表";
    }
    return _courseLabel;
}

-(UIImageView *)crownImageView{
    if (!_crownImageView) {
        _crownImageView = [[UIImageView alloc] init];
        _crownImageView.image = [UIImage imageNamed:@"jingping_crown"];
    }
    return _crownImageView;
}

-(UIImageView *)rectangleImageView{
    if (!_rectangleImageView) {
        _rectangleImageView = [[UIImageView alloc] init];
        _rectangleImageView.image = [UIImage resizedImageWithName:@"jingpin_rectangle"];
    }
    return _rectangleImageView;
}

-(UILabel *)jingpinLabel{
    if (!_jingpinLabel) {
        _jingpinLabel = [[UILabel alloc] init];
        _jingpinLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _jingpinLabel.font = HXFont(12);
        _jingpinLabel.textAlignment = NSTextAlignmentCenter;
        _jingpinLabel.text = @"职业资格精品课";
    }
    return _jingpinLabel;
}

-(UILabel *)learnTimeLabel{
    if (!_learnTimeLabel) {
        _learnTimeLabel = [[UILabel alloc] init];
        _learnTimeLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _learnTimeLabel.font = HXFont(12);
        _learnTimeLabel.textAlignment = NSTextAlignmentLeft;
        _learnTimeLabel.text = @"已学：9分钟/159分钟";
    }
    return _learnTimeLabel;
}

-(HXGradientProgressView *)gradientProgressView{
    if (!_gradientProgressView) {
        _gradientProgressView = [[HXGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, _kpw(295), 18)];
        _gradientProgressView.bgProgressColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
    }
    return _gradientProgressView;
}



@end
